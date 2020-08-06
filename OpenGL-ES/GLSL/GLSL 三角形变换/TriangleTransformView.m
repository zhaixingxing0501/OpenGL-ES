//
//  TriangleTransformView.m
//  OpenGL-ES
//
//  Created by nucarf on 2020/8/6.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import "TriangleTransformView.h"
#import "GLESMath.h"
#import "GLESUtils.h"
#import <OpenGLES/ES2/gl.h>

@interface TriangleTransformView ()

@property (nonatomic, strong) EAGLContext *myContext;
@property (nonatomic, strong) CAEAGLLayer *myEagLayer;

@property (nonatomic, assign) GLuint myColorRenderBuffer;

@property (nonatomic, assign) GLuint myColorFrameBuffer;

@property (nonatomic, assign) GLuint myProgram;

@property (nonatomic, assign) GLuint myVertices;

@end

@implementation TriangleTransformView
{
    float xDegree;
    float yDegree;
    float zDegree;
    BOOL bX;
    BOOL bY;
    BOOL bZ;
    NSTimer *myTimer;
}

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)layoutSubviews {
//    [super layoutSubviews];

    [self setupLayer];
    [self setupContext];
    [self deleteBuffer];
    [self setupRenderBuffer];
    [self setupFrameBuffer];
    [self setupRender];
}

#pragma mark -- 1.设置图层 --
- (void)setupLayer {
    self.myEagLayer = (CAEAGLLayer *)self.layer;
    [self setContentScaleFactor:[UIScreen mainScreen].scale];

    self.opaque = YES;
    self.myEagLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
}

#pragma mark -- 2.创建上下文 --
- (void)setupContext {
    EAGLContext *content = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!content) {
        NSLog(@"create content failed");
        return;
    }

    if (![EAGLContext setCurrentContext:content]) {
        NSLog(@"set current conttext failed");
        return;
    }

    self.myContext = content;
}

#pragma mark -- 3.清除缓冲区 --
- (void)deleteBuffer {
    glDeleteShader(_myColorRenderBuffer);
    self.myColorRenderBuffer = 0;

    glDeleteShader(_myColorFrameBuffer);
    self.myColorFrameBuffer = 0;
}

#pragma mark -- 4.设置RenderBuffer --
- (void)setupRenderBuffer {
    GLuint buffer;
    glGenRenderbuffers(1, &buffer);
    self.myColorRenderBuffer = buffer;
    glBindRenderbuffer(GL_RENDERBUFFER, self.myColorRenderBuffer);
    //4.将标识符绑定到GL_RENDERBUFFER
    [self.myContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.myEagLayer];
}

#pragma mark -- 5.设置FrameBuffer --
- (void)setupFrameBuffer {
    GLuint buffer;
    glGenFramebuffers(1, &buffer);
    self.myColorFrameBuffer = buffer;
    glBindFramebuffer(GL_FRAMEBUFFER, self.myColorFrameBuffer);
    //5.将_myColorRenderBuffer 装配到GL_COLOR_ATTACHMENT0 附着点上
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, self.myColorRenderBuffer);
}

#pragma mark -- 6.渲染 --
- (void)setupRender {
    glClearColor(0, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);

    CGFloat scale = [UIScreen mainScreen].scale;
    glViewport(self.frame.origin.x * scale, self.frame.origin.y * scale, self.frame.size.width * scale, self.frame.size.height * scale);

    NSString *vertFile = [[NSBundle bundleForClass:[self class]] pathForResource:@"shaderV1" ofType:@"glsl"];
    NSString *fragFile = [[NSBundle bundleForClass:[self class]] pathForResource:@"shaderF1" ofType:@"glsl"];

    if (self.myProgram) {
        glDeleteProgram(self.myProgram);
        self.myProgram = 0;
    }

    self.myProgram = [self loadShader:vertFile frag:fragFile];

    glLinkProgram(self.myProgram);

    GLint linkStatus;
    glGetProgramiv(self.myProgram, GL_LINK_STATUS, &linkStatus);
    if (linkStatus == GL_FALSE) {
        GLchar message[1024];
        glGetProgramInfoLog(self.myProgram, sizeof(message), 0, &message[0]);
        NSString *messageString = [NSString stringWithUTF8String:message];
        NSLog(@"link error%@", messageString);

        return;
    }

    glUseProgram(self.myProgram);

    //处理顶点数据 顶点坐标(3), 颜色(3) 纹理(2)
    GLfloat attrArr[] =
    {
        -0.5f, 0.5f,   0.0f,   0.0f,   0.0f,   0.5f,   0.0f,  1.0f,//左上
        0.5f,  0.5f,   0.0f,   0.0f,   0.5f,   0.0f,   1.0f,  1.0f, //右上
        -0.5f, -0.5f,  0.0f,   0.5f,   0.0f,   1.0f,   0.0f,  0.0f, //左下
        0.5f,  -0.5f,  0.0f,   0.0f,   0.0f,   0.5f,   1.0f,  0.0f, //右下
        0.0f,  0.0f,   1.0f,   1.0f,   1.0f,   1.0f,   0.5f,  0.5f,//顶点
    };

    //索引数组
    GLuint indexs[] =
    {
        0, 3, 2,
        0, 1, 3,
        0, 2, 4,
        0, 4, 1,
        2, 3, 4,
        1, 4, 3,
    };

    if (self.myVertices == 0) {
        glGenBuffers(1, &_myVertices);
    }

    glBindBuffer(GL_ARRAY_BUFFER, self.myVertices);
    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_DYNAMIC_DRAW);

    GLuint postion = glGetAttribLocation(self.myProgram, "position");
    glEnableVertexAttribArray(postion);
    glVertexAttribPointer(postion, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 8, NULL);

    GLuint positionColor = glGetAttribLocation(self.myProgram, "positionColor");
    glEnableVertexAttribArray(positionColor);
    glVertexAttribPointer(positionColor, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 8, (GLfloat *)NULL + 3);

    GLuint textCoor = glGetAttribLocation(self.myProgram, "textCoor");
    glEnableVertexAttribArray(textCoor);
    glVertexAttribPointer(textCoor, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 8, (GLfloat *)NULL + 6);

    // 加载纹理
    [self setupTexture:@"img2.jpg"];

    glUniform1i(glGetUniformLocation(self.myProgram, "colorMap"), 0);

    //MVP
    GLuint projectionMatrixSlot = glGetUniformLocation(self.myProgram, "projectionMatrix");
    GLuint modelViewMatrixSlot = glGetUniformLocation(self.myProgram, "modelViewMatrix");

    float width = self.frame.size.width;
    float height = self.frame.size.height;

    //4*4投影矩阵
    KSMatrix4 _projectMatrix;
    ksMatrixLoadIdentity(&_projectMatrix);
    float aspect = width / height;
    ksPerspective(&_projectMatrix, 45, aspect, 5.0, 20);
    glUniformMatrix4fv(projectionMatrixSlot, 1, GL_FALSE, (GLfloat *)&_projectMatrix.m[0][0]);

    //4*4模型视图矩阵
    KSMatrix4 _modelViewMatrix;
    ksMatrixLoadIdentity(&_modelViewMatrix);
    ksTranslate(&_modelViewMatrix, 0, 0, -10.0f);

    KSMatrix4 _rotationMatrix;
    ksMatrixLoadIdentity(&_rotationMatrix);
    //XYZ
    ksRotate(&_rotationMatrix, xDegree, 1.0, 0, 0);
    ksRotate(&_rotationMatrix, yDegree, 0, 1, 0);
    ksRotate(&_rotationMatrix, zDegree, 0, 0, 1);

    //矩阵相乘
    ksMatrixMultiply(&_modelViewMatrix, &_rotationMatrix, &_modelViewMatrix);
    glUniformMatrix4fv(modelViewMatrixSlot, 1, GL_FALSE, (GLfloat *)&_modelViewMatrix.m[0][0]);

    glEnable(GL_CULL_FACE);

    /*
        void glDrawElements(GLenum mode,GLsizei count,GLenum type,const GLvoid * indices);
        参数列表：
        mode:要呈现的画图的模型
        GL_POINTS
        GL_LINES
        GL_LINE_LOOP
        GL_LINE_STRIP
        GL_TRIANGLES
        GL_TRIANGLE_STRIP
        GL_TRIANGLE_FAN
        count:绘图个数
        type:类型
        GL_BYTE
        GL_UNSIGNED_BYTE
        GL_SHORT
        GL_UNSIGNED_SHORT
        GL_INT
        GL_UNSIGNED_INT
        indices：绘制索引数组

        */

    //使用索引绘图
    glDrawElements(GL_TRIANGLES, sizeof(indexs) / sizeof(indexs[0]), GL_UNSIGNED_INT, indexs);

    [self.myContext presentRenderbuffer:GL_RENDERBUFFER];

//    self.myEagLayer.backgroundColor = colorRandom.CGColor;
}

#pragma mark -- 6.1加载shader --
- (GLuint)loadShader:(NSString *)vertFile frag:(NSString *)fragFile {
    GLuint verShader, fragShader;
    GLuint program = glCreateProgram();

    [self compileShader:&verShader type:GL_VERTEX_SHADER file:vertFile];
    [self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragFile];

    glAttachShader(program, verShader);
    glAttachShader(program, fragShader);

    glDeleteShader(verShader);
    glDeleteShader(fragShader);

    return program;
}

#pragma mark -- 6.1.1编译shader --
- (void)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file {
    //1. 读取文字路径字符串
    NSString *content = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    //2.读取文件字符串 C语言字符串
    const GLchar *source = (GLchar *)[content UTF8String];

    *shader = glCreateShader(type);

    glShaderSource(*shader, 1, &source, NULL);

    glCompileShader(*shader);
}

#pragma mark -- 6.2加载纹理图片 --
- (GLuint)setupTexture:(NSString *)fileName {
    CGImageRef image = [UIImage imageNamed:fileName].CGImage;
    if (!image) {
        NSLog(@"load image failed:%@", fileName);
        return 0;
    }

    //获取图片的宽高
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);

    //获取图片字节数
    GLubyte *sprintData = (GLubyte *)calloc(width * height * 4, sizeof(GLubyte));

    //创建上下文
    /*
       参数1：data,指向要渲染的绘制图像的内存地址
       参数2：width,bitmap的宽度，单位为像素
       参数3：height,bitmap的高度，单位为像素
       参数4：bitPerComponent,内存中像素的每个组件的位数，比如32位RGBA，就设置为8
       参数5：bytesPerRow,bitmap的没一行的内存所占的比特数
       参数6：colorSpace,bitmap上使用的颜色空间  kCGImageAlphaPremultipliedLast：RGBA
       */

    CGContextRef sprintContent = CGBitmapContextCreate(sprintData, width, height, 8, width * 4, CGImageGetColorSpace(image), kCGImageAlphaPremultipliedLast);

    //在CGContextRef上--> 将图片绘制出来
    /*
     CGContextDrawImage 使用的是Core Graphics框架，坐标系与UIKit 不一样。UIKit框架的原点在屏幕的左上角，Core Graphics框架的原点在屏幕的左下角。
     CGContextDrawImage
     参数1：绘图上下文
     参数2：rect坐标
     参数3：绘制的图片
     */

    CGRect rect = CGRectMake(0, 0, width, height);

    //使用默认绘制方式
    CGContextDrawImage(sprintContent, rect, image);

    //画图完毕释放上下文
    CGContextRelease(sprintContent);

    //绑定纹理到默认的纹理id
    glBindTexture(GL_TEXTURE_2D, 0);

    //设置纹理属性
    /*
     参数1：纹理维度
     参数2：线性过滤、为s,t坐标设置模式
     参数3：wrapMode,环绕模式
     */
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    //载入纹理2D数据
    /*
     参数1：纹理模式，GL_TEXTURE_1D、GL_TEXTURE_2D、GL_TEXTURE_3D
     参数2：加载的层次，一般设置为0
     参数3：纹理的颜色值GL_RGBA
     参数4：宽
     参数5：高
     参数6：border，边界宽度
     参数7：format
     参数8：type
     参数9：纹理数据
     */
    float fw = width, fh = height;
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, sprintData);

    //释放sprintData
    free(sprintData);

    return 0;
}

#pragma mark -- 按钮点击方法 --

- (IBAction)Xclick:(UIButton *)sender {
    if (!myTimer) {
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(reDegree) userInfo:nil repeats:YES];
    }
    bX = !bX;
}

- (IBAction)Yclick:(UIButton *)sender {
    if (!myTimer) {
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(reDegree) userInfo:nil repeats:YES];
    }
    bY = !bY;
}

- (IBAction)Zclick:(UIButton *)sender {
    if (!myTimer) {
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(reDegree) userInfo:nil repeats:YES];
    }
    bZ = !bZ;
}

- (void)reDegree {
    xDegree += bX * 5;
    yDegree += bY * 5;
    zDegree += bZ * 5;

    [self setupRender];
}

@end
