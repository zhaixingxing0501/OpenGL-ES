//
//  TriangleRender.m
//  OpenGL-ES
//
//  Created by nucarf on 2020/8/20.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import "TriangleRender.h"
#import "TriangleShaderTypes.h"

@implementation TriangleRender
{
    //我们用来渲染的设备(又名GPU)
    id<MTLDevice> _device;

    // 我们的渲染管道有顶点着色器和片元着色器 它们存储在.metal shader 文件中
    id<MTLRenderPipelineState> _pipelineState;

    //命令队列,从命令缓存区获取
    id<MTLCommandQueue> _commandQueue;

    //当前视图大小,这样我们才可以在渲染通道使用这个视图
    vector_uint2 _viewportSize;
}

- (instancetype)initWithMetalMTKView:(MTKView *)mtkView {
    self = [super init];
    if (self) {
        NSError *error = NULL;

        //1.获取设备GPU
        _device = mtkView.device;

        //2.加载着色器文件(.metal文件)
        id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
        //从库中加载顶点函数
        id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader"];
        //从库中加载片元函数
        id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"fragmentShader"];

        //3.配置用于创建管道状态的管道
        MTLRenderPipelineDescriptor *pipelineDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        //管道名称
        pipelineDescriptor.label = @"simple Pipeline";
        //可编程函数,用于处理渲染过程中的各个顶点
        pipelineDescriptor.vertexFunction = vertexFunction;
        //可编程函数,用于处理渲染过程中各个片段/片元
        pipelineDescriptor.fragmentFunction = fragmentFunction;
        //一组存储颜色数据的组件
        pipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;

        //4.同步创建并返回渲染管线状态对象
        _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];

        //判断是否返回了管线状态对象
        NSAssert(_pipelineState, @"Failed to created pipeline state, error %@", error);

        //5.创建命令队列
        _commandQueue = [_device newCommandQueue];
    }
    return self;
}

#pragma mark --  MTKView delegaet --
//每当视图改变方向或调整大小时调用
- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    // 保存可绘制的大小，因为当我们绘制时，我们将把这些值传递给顶点着色器
    _viewportSize.x = size.width;
    _viewportSize.y = size.height;
}

- (void)drawInMTKView:(MTKView *)view {
    //1. 设置顶点数据
    static const ZXVertex triangleVertices[] = {
        //顶点,    RGBA 颜色值
        { {  0.5,  -0.25,  0.0,   1.0              }, { 1, 0, 0, 1 } },
        { { -0.5,  -0.25,  0.0,   1.0              }, { 0, 1, 0, 1 } },
        { { -0.0f, 0.25,   0.0,   1.0              }, { 0, 0, 1, 1 } },
    };

    //2. 为当前渲染的每个渲染传递创建一个新的命令缓冲区
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    //指定缓冲区名称
    commandBuffer.label = @"myCommandBuffer";

    //3. MTLRenderPassDescriptor:一组渲染目标，用作渲染通道生成的像素的输出目标。

    MTLRenderPassDescriptor *renderPassDescripor = view.currentRenderPassDescriptor;
    //判断渲染目标是否为空
    NSAssert(renderPassDescripor, @"renderPassDescriptor create failed");

    //4.创建渲染命令编码器,这样我们才可以渲染到something
    id<MTLRenderCommandEncoder> renderEncorder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescripor];
    //渲染器名称
    renderEncorder.label = @"myRenderEncorder";

    //5. 设置我们绘制的可绘制区域
    /*
     typedef struct {
     double originX, originY, width, height, znear, zfar;
     } MTLViewport;
     */
    //视口指定Metal渲染内容的drawable区域。 视口是具有x和y偏移，宽度和高度以及近和远平面的3D区域
    //为管道分配自定义视口需要通过调用setViewport：方法将MTLViewport结构编码为渲染命令编码器。 如果未指定视口，Metal会设置一个默认视口，其大小与用于创建渲染命令编码器的drawable相同。
    MTLViewport viewPort = { 0, 0, _viewportSize.x, _viewportSize.y, 0.0, 1.0 };
    [renderEncorder setViewport:viewPort];
    //[renderEncoder setViewport:(MTLViewport){0.0, 0.0, _viewportSize.x, _viewportSize.y, -1.0, 1.0 }];

    //6. 设置当前渲染管道状态对象
    [renderEncorder setRenderPipelineState:_pipelineState];

    //7.从应用程序OC 代码 中发送数据给Metal 顶点着色器 函数
    //顶点数据+颜色数据
    //   1) 指向要传递给着色器的内存的指针
    //   2) 我们想要传递的数据的内存大小
    //   3)一个整数索引，它对应于我们的“vertexShader”函数中的缓冲区属性限定符的索引。
    [renderEncorder setVertexBytes:triangleVertices length:sizeof(triangleVertices) atIndex:ZXVertexInputIndexVertices];

    //viewPortSize 数据
    //1) 发送到顶点着色函数中,视图大小
    //2) 视图大小内存空间大小
    //3) 对应的索引
    [renderEncorder setVertexBytes:&_viewportSize length:sizeof(_viewportSize) atIndex:ZXVertexInputIndexViewportSize];

    //8.画出三角形的3个顶点
    // @method drawPrimitives:vertexStart:vertexCount:
    //@brief 在不使用索引列表的情况下,绘制图元
    //@param 绘制图形组装的基元类型
    //@param 从哪个位置数据开始绘制,一般为0
    //@param 每个图元的顶点个数,绘制的图型顶点数量
    /*
     MTLPrimitiveTypePoint = 0, 点
     MTLPrimitiveTypeLine = 1, 线段
     MTLPrimitiveTypeLineStrip = 2, 线环
     MTLPrimitiveTypeTriangle = 3,  三角形
     MTLPrimitiveTypeTriangleStrip = 4, 三角型扇
     */
    [renderEncorder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:3];

    //9.表示已该编码器生成的命令都已完成,并且从NTLCommandBuffer中分离
    [renderEncorder endEncoding];

    //10.一旦框架缓冲区完成，使用当前可绘制的进度表
    [commandBuffer presentDrawable:view.currentDrawable];

    //11.最后,在这里完成渲染并将命令缓冲区推送到GPU
    [commandBuffer commit];
}

@end
