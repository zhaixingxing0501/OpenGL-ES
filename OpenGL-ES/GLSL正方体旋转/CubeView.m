//
//  CubeView.m
//  OpenGL-ES
//
//  Created by zhaixingxing on 2020/7/31.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import "CubeView.h"
#import <OpenGLES/ES2/gl.h>

/*
 不采用GLKBaseEffect，使用编译链接自定义的着色器（shader）。用简单的glsl语言来实现顶点、片元着色器，并图形进行简单的变换。
 思路：
 1.创建图层
 2.创建上下文
 3.清空缓存区
 4.设置RenderBuffer
 5.设置FrameBuffer
 6.开始绘制

 */

@interface CubeView ()

//在iOS和tvOS上绘制OpenGL ES内容的图层，继承与CALayer
@property (nonatomic, strong) CAEAGLLayer *myEagLayer;

@property (nonatomic, strong) EAGLContext *myContext;

@property (nonatomic, assign) GLuint myColorRenderBuffer;

@property (nonatomic, assign) GLuint myColorFrameBuffer;

@property (nonatomic, assign) GLuint myPrograme;

@end

@implementation CubeView

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    //1. 创建图层
    //2. 设置上下文
    //3. 清空缓冲区
    //4. 设置RenderBuffer
    //5. 设置FrameBuffer
    //6.开始绘制
}

#pragma mark -- 1. 创建图层 --
- (void)setupLayer {
    //1. 创建特殊图层
    //重写layerClass 修改CALayer为CAEAGLLayer
    self.myEagLayer = (CAEAGLLayer *)self.layer;

    //2. 设置scale
    [self setContentScaleFactor:[UIScreen mainScreen].scale];

    //3. 设置描述属性，这里设置不维持渲染内容以及颜色格式为RGBA8
    self.myEagLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:@false, kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];

    /*
     kEAGLDrawablePropertyRetainedBacking  表示绘图表面显示后，是否保留其内容。
     kEAGLDrawablePropertyColorFormat
     可绘制表面的内部颜色缓存区格式，这个key对应的值是一个NSString指定特定颜色缓存区对象。默认是kEAGLColorFormatRGBA8；
     kEAGLColorFormatRGBA8：32位RGBA的颜色，4*8=32位
     kEAGLColorFormatRGB565：16位RGB的颜色，
     kEAGLColorFormatSRGBA8：sRGB代表了标准的红、绿、蓝，即CRT显示器、LCD显示器、投影机、打印机以及其他设备中色彩再现所使用的三个基本色素。sRGB的色彩空间基于独立的色彩坐标，可以使色彩在不同的设备使用传输中对应于同一个色彩坐标体系，而不受这些设备各自具有的不同色彩坐标的影响。
     */
}

#pragma mark -- 2. 设置上下文 --
- (void)setupContext {
    //1. 创建content并指定OpenGL ES 渲染API版本
    EAGLContext *content = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    //2. 判断是否创建成功
    if (!content) {
        NSLog(@"create content failed");
    }

    //3. 设置当前上下文
    if (![EAGLContext setCurrentContext:content]) {
        NSLog(@"setCurrentContext failer");
    }

    self.myContext = content;
}

#pragma mark -- 3. 清空缓冲区 --
- (void)deleteRenderAndFrameBuffer {
    /*
     buffer分为frame buffer 和 render buffer2个大类。
     其中frame buffer 相当于render buffer的管理者。
     frame buffer object即称FBO。
     render buffer则又可分为3类。colorBuffer、depthBuffer、stencilBuffer。
     */

    glDeleteBuffers(1, &_myColorRenderBuffer);
    self.myColorRenderBuffer = 0;

    glDeleteBuffers(1, &_myColorFrameBuffer);
    self.myColorFrameBuffer = 0;
}

#pragma mark -- 4. 设置RenderBuffer --
- (void)setupRenderBuffer {
    //1. 定义缓冲区id
    GLuint buffer;

    //2. 申请缓冲区标志
    glGenBuffers(1, &buffer);
    self.myColorRenderBuffer = buffer;

    //3. 将标识符绑定到GL_RENDERBUFFER
    glBindBuffer(GL_RENDERBUFFER, self.myColorRenderBuffer);

    //4. 将可绘制对象drawable object's  CAEAGLLayer的存储绑定到OpenGL ES renderBuffer对象
    [self.myContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.myEagLayer];
}

#pragma mark -- 5. 设置FrameBuffer --
- (void)setupFrameBuffer {
    //1. 定义缓冲区id
    GLuint buffer;
    
    //2. 申请缓冲区标志
    glGenBuffers(1, &buffer);
    self.myColorFrameBuffer = buffer;
    
    //3. 将标识符绑定到
    glBindBuffer(GL_FRAMEBUFFER, self.myColorFrameBuffer);
    
    /*生成帧缓存区之后，则需要将renderbuffer跟framebuffer进行绑定，
    调用glFramebufferRenderbuffer函数进行绑定到对应的附着点上，后面的绘制才能起作用
    */
    //4. 将渲染缓存区myColorRenderBuffer 通过glFramebufferRenderbuffer函数绑定到 GL_COLOR_ATTACHMENT0上。
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, self.myColorFrameBuffer);
    
}

#pragma mark -- 6. 开始绘制 --
- (void)setupRenderLayer {
    
}

@end
