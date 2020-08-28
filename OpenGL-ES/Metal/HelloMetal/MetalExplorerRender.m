//
//  MetalExplorerRender.m
//  OpenGL-ES
//
//  Created by nucarf on 2020/8/20.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import "MetalExplorerRender.h"

@implementation MetalExplorerRender
{
    id<MTLDevice> _device;
    // The command queue used to pass commands to the device.
    id<MTLCommandQueue> _commandQueue;

    // The current size of the view, used as an input to the vertex shader.
    vector_uint2 _viewportSize;
}

//颜色结构体
typedef struct {
    float red, green, blue, alpha;
} Color;

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView {
    self = [super init];
    if (self) {
        _device = mtkView.device;

        //所有应用程序需要与GPU交互的第一个对象是一个对象。MTLCommandQueue.
        //你使用MTLCommandQueue 去创建对象,并且加入MTLCommandBuffer 对象中.确保它们能够按照正确顺序发送到GPU.对于每一帧,一个新的MTLCommandBuffer 对象创建并且填满了由GPU执行的命令.
        _commandQueue = [_device newCommandQueue];
    }
    return self;
}

- (Color)setupColorGradient {
    //1. 增加颜色/减小颜色的 标记
    static BOOL growing = YES;
    //2.颜色通道值(0~3)
    static NSUInteger primaryChannel = 0;
    //3.颜色通道数组colorChannels(颜色值)
    static float colorChannels[] = { 1.0, 0.0, 0.0, 1.0 };
    //4.颜色调整步长
    const float DynamicColorRate = 0.015;

    //5.判断
    if (growing) {
        //动态信道索引 (1,2,3,0)通道间切换
        NSUInteger dynamicChannelIndex = (primaryChannel + 1) % 3;

        //修改对应通道的颜色值 调整0.015
        colorChannels[dynamicChannelIndex] += DynamicColorRate;

        //当颜色通道对应的颜色值 = 1.0
        if (colorChannels[dynamicChannelIndex] >= 1.0) {
            //设置为NO
            growing = NO;

            //将颜色通道修改为动态颜色通道
            primaryChannel = dynamicChannelIndex;
        }
    } else {
        //获取动态颜色通道
        NSUInteger dynamicChannelIndex = (primaryChannel + 2) % 3;

        //将当前颜色的值 减去0.015
        colorChannels[dynamicChannelIndex] -= DynamicColorRate;

        //当颜色值小于等于0.0
        if (colorChannels[dynamicChannelIndex] <= 0.0) {
            //又调整为颜色增加
            growing = YES;
        }
    }

    //创建颜色
    Color color;

    //修改颜色的RGBA的值
    color.red = colorChannels[0];
    color.green = colorChannels[1];
    color.blue = colorChannels[2];
    color.alpha = colorChannels[3];

    //返回颜色
    return color;
}

#pragma mark - MTKViewDelegate methods
//当MTKView视图发生大小改变时调用
- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
}

/// 需要渲染的时候调用
- (void)drawInMTKView:(MTKView *)view {
    //1. 获取颜色值
    Color color = [self setupColorGradient];

    //2. 设置view的clearColor
    view.clearColor = MTLClearColorMake(color.red, color.green, color.blue, color.alpha);

    //3. 使用MTLCommandQueue 创建对象并且加入到MTCommandBuffer对象中去.
    //为当前渲染的每个渲染传递创建一个新的命令缓冲区
    id<MTLCommandBuffer> commandBuff = [_commandQueue commandBuffer];
    commandBuff.label = @"myCommandBuffer";

    //4.从视图绘制中,获得渲染描述符
    MTLRenderPassDescriptor *renderPassDesriptor = view.currentRenderPassDescriptor;

    //5.判断renderPassDescriptor 渲染描述符是否创建成功,否则则跳过任何渲染.
    if (!renderPassDesriptor) {
        NSAssert(YES, @"renderPassDesriptor create failed");
    }

    if (!renderPassDesriptor) {
        
    }
    
    //6.通过渲染描述符renderPassDescriptor创建MTLRenderCommandEncoder 对象
    id<MTLRenderCommandEncoder> renderEncorder = [commandBuff renderCommandEncoderWithDescriptor:renderPassDesriptor];
    renderEncorder.label = @"myRenderEncorder";

    //7.我们可以使用MTLRenderCommandEncoder 来绘制对象,但是这个demo我们仅仅创建编码器就可以了,我们并没有让Metal去执行我们绘制的东西,这个时候表示我们的任务已经完成.
    //即可结束MTLRenderCommandEncoder 工作
    [renderEncorder endEncoding];

    /*
     当编码器结束之后,命令缓存区就会接受到2个命令.
     1) present
     2) commit
     因为GPU是不会直接绘制到屏幕上,因此你不给出去指令.是不会有任何内容渲染到屏幕上.
     */
    //8.添加一个最后的命令来显示清除的可绘制的屏幕
    [commandBuff presentDrawable:view.currentDrawable];

    //9. 在这里完成渲染并将命令缓冲区提交给GPU
    [commandBuff commit];
}

@end
