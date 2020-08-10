//
//  FilterViewController.m
//  OpenGL-ES
//
//  Created by nucarf on 2020/8/10.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterBar/FilterBar.h"
#import <GLKit/GLKit.h>

typedef struct {
    GLKVector3 positionCoord; // (X, Y, Z)
    GLKVector2 textureCoord; // (U, V)
} SceneVertex;

@interface FilterViewController ()<FilterBarDelegate>

@property (nonatomic, assign) SceneVertex *vertices;

@property (nonatomic, strong) EAGLContext *context;
// 用于刷新屏幕
@property (nonatomic, strong) CADisplayLink *displayLink;
// 开始的时间戳
@property (nonatomic, assign) NSTimeInterval startTimeInterval;
// 着色器程序
@property (nonatomic, assign) GLuint program;
// 顶点缓存
@property (nonatomic, assign) GLuint vertexBuffer;
// 纹理 ID
@property (nonatomic, assign) GLuint textureID;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;

    [self setupFilterBar];

    [self setupFilter];

    [self startFilterAnimation];
}

#pragma mark --  开始滤镜动画 --
- (void)startFilterAnimation {
    //1. CADisplayLink 定时器
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
    //2. 设置displayLink 的方法
    self.startTimeInterval = 0;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timeAction)];

    //3. 将displayLink 添加到runloop 运行循环
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop]
                           forMode:NSRunLoopCommonModes];
}

- (void)timeAction {
    //DisplayLink 的当前时间撮
    if (self.startTimeInterval == 0) {
        self.startTimeInterval = self.displayLink.timestamp;
    }
    //使用program
    glUseProgram(self.program);
    //绑定buffer
    glBindBuffer(GL_ARRAY_BUFFER, self.vertexBuffer);

    // 传入时间
    CGFloat currentTime = self.displayLink.timestamp - self.startTimeInterval;
    GLuint time = glGetUniformLocation(self.program, "Time");
    glUniform1f(time, currentTime);

    // 清除画布
    glClear(GL_COLOR_BUFFER_BIT);
    glClearColor(1, 1, 1, 1);

    // 重绘
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    //渲染到屏幕上
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

#pragma mark --  滤镜相关初始化 --
- (void)setupFilter {
    //1. 初始化上下文并设置
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!self.context) {
        NSAssert(NO, @"create content failed");
    }

    if (![EAGLContext setCurrentContext:self.context]) {
        NSAssert(NO, @"set current content failed");
    }

    //2. 创建图层并添加
    CAEAGLLayer *layer = [[CAEAGLLayer alloc] init];
    layer.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width);
    layer.contentsScale = [[UIScreen mainScreen] scale];
    [self.view.layer addSublayer:layer];

    //3. 开辟空间,并设置顶点数据
    self.vertices = malloc(sizeof(SceneVertex) * 4);
    self.vertices[0] = (SceneVertex) { { -1, 1, 0 }, { 0, 1 } };
    self.vertices[1] = (SceneVertex) { { -1, -1, 0 }, { 0, 0 } };
    self.vertices[2] = (SceneVertex) { { 1, 1, 0 }, { 1, 1 } };
    self.vertices[3] = (SceneVertex) { { 1, -1, 0 }, { 1, 0 } };

    //4. 绑定渲染缓冲区
    [self bindRenderLayer:layer];

    //5. 获取图片路径
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"img4" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];

    //6. 图片转换成纹理数据
    GLuint textureId = [self createTextureWithImage:image];
    self.textureID = textureId;

    //7. 设置视口
    glViewport(0, 0, self.drawableWidth, self.drawableHeight);

    //8. 设置顶点缓冲区
    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    GLsizeiptr bufferSizeBytes = sizeof(SceneVertex) * 4;
    glBufferData(GL_ARRAY_BUFFER, bufferSizeBytes, self.vertices, GL_STATIC_DRAW);

    //9. 设置默认着色器
    [self setupNormalShaderProgram]; // 一开始选用默认的着色器

    //10. 将顶点缓存保存，退出时才释放
    self.vertexBuffer = vertexBuffer;
}

#pragma mark --  设置着色器 --
- (void)setupNormalShaderProgram {
    //设置着色器程序
    [self setupShaderProgramWithName:@"splitScreen_normal"];
}

- (void)setupShaderProgramWithName:(NSString *)name {
    //1. 获取着色器program
    GLuint program = [self programWithShaderName:name];

    //2. use Program
    glUseProgram(program);

    //3. 获取Position,Texture,TextureCoords 的索引位置
    GLuint positionSlot = glGetAttribLocation(program, "Position");
    GLuint textureSlot = glGetUniformLocation(program, "Texture");
    GLuint textureCoordsSlot = glGetAttribLocation(program, "TextureCoords");

    //4.激活纹理,绑定纹理ID
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, self.textureID);

    //5.纹理sample
    glUniform1i(textureSlot, 0);

    //6.打开positionSlot 属性并且传递数据到positionSlot中(顶点坐标)
    glEnableVertexAttribArray(positionSlot);
    glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL + offsetof(SceneVertex, positionCoord));

    //7.打开textureCoordsSlot 属性并传递数据到textureCoordsSlot(纹理坐标)
    glEnableVertexAttribArray(textureCoordsSlot);
    glVertexAttribPointer(textureCoordsSlot, 2, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL + offsetof(SceneVertex, textureCoord));

    //8.保存program,界面销毁则释放
    self.program = program;
}

#pragma mark --  编译链接着色器 --
- (GLuint)programWithShaderName:(NSString *)shaderName {
    //1. 编译顶点着色器/片元着色器
    GLuint vertexShader = [self compileShaderWithName:shaderName type:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShaderWithName:shaderName type:GL_FRAGMENT_SHADER];

    //2. 将顶点/片元附着到program
    GLuint program = glCreateProgram();
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);

    //3.linkProgram
    glLinkProgram(program);

    //4.检查是否link成功
    GLint linkSuccess;
    glGetProgramiv(program, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(program, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSAssert(NO, @"program链接失败：%@", messageString);
        exit(1);
    }
    //5.返回program
    return program;
}

#pragma mark --  编译着色器 --
- (GLuint)compileShaderWithName:(NSString *)name type:(GLenum)shaderType {
    //1.获取shader 路径
    NSString *shaderPath = [[NSBundle mainBundle] pathForResource:name ofType:shaderType == GL_VERTEX_SHADER ? @"vsh" : @"fsh"];
    NSError *error;
    NSString *shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSAssert(NO, @"读取shader失败");
        exit(1);
    }

    //2. 创建shader->根据shaderType
    GLuint shader = glCreateShader(shaderType);

    //3.获取shader source
    const char *shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = (int)[shaderString length];
    glShaderSource(shader, 1, &shaderStringUTF8, &shaderStringLength);

    //4.编译shader
    glCompileShader(shader);

    //5.查看编译是否成功
    GLint compileSuccess;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shader, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSAssert(NO, @"shader编译失败：%@", messageString);
        exit(1);
    }
    //6.返回shader
    return shader;
}

#pragma mark --  图片转换成纹理数据 --
- (GLuint)createTextureWithImage:(UIImage *)image {
    //1、将 UIImage 转换为 CGImageRef
    CGImageRef cgImageRef = [image CGImage];
    if (!cgImageRef) {
        NSLog(@"Failed to load image");
        NSAssert(NO, @"failed to load image");
    }

    //2. 读取大小
    GLuint width = (GLuint)CGImageGetWidth(cgImageRef);
    GLuint height = (GLuint)CGImageGetHeight(cgImageRef);
    CGRect rect = CGRectMake(0, 0, width, height);

    //3. 获取图片颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    //4. 获取图片大小
    void *imageData = malloc(width * height * 4);

    //5. 创建上下文
    /*
        参数1：data,指向要渲染的绘制图像的内存地址
        参数2：width,bitmap的宽度，单位为像素
        参数3：height,bitmap的高度，单位为像素
        参数4：bitPerComponent,内存中像素的每个组件的位数，比如32位RGBA，就设置为8
        参数5：bytesPerRow,bitmap的没一行的内存所占的比特数
        参数6：colorSpace,bitmap上使用的颜色空间  kCGImageAlphaPremultipliedLast：RGBA
        */
    CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

    //6. 反转图片
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGColorSpaceRelease(colorSpace);
    CGContextClearRect(context, rect);

    //7. 图片重新绘制
    CGContextDrawImage(context, rect, cgImageRef);

    //8. 设置纹理id
    GLuint textureID;
    glGenTextures(1, &textureID);
    glBindTexture(GL_TEXTURE_2D, textureID);

    //9. 载入纹理2D数据
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
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);

    //10. 设置纹理属性
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    /*
     1.GL_CLAMP ：在边界处双线性处理，但是很多硬件不支持边界处理，故此效果跟GL_CLAMP_TO_EDGE效果看起来相同
     2.GL_CLAMP_TO_EDGE：边界处采用纹理边缘自己的的颜色，和边框无关。采样范围在[0 + 0.5 * texel ,  1 - 0.5 * texel](texel：纹理的宽(高)像素，比如纹理是1024 * 512，则宽就是1024，高就是512)
     3.GL_CLAMP_TO_BORDER：采样纹理边界的颜色，跟纹理边缘自己的颜色没半毛钱关系
     */

    //11. 绑定纹理
    /*
     参数1：纹理维度
     参数2：纹理ID,因为只有一个纹理，给0就可以了。
     */
    glBindTexture(GL_TEXTURE_2D, 0);

    //12. 释放context,imageData
    CGContextRelease(context);
    free(imageData);

    //13. 返回纹理
    return textureID;
}

#pragma mark --  绑定渲染缓冲区 --
- (void)bindRenderLayer:(CALayer <EAGLDrawable> *)layer {
    //1.渲染缓存区,帧缓存区对象
    GLuint renderBuffer;
    GLuint frameBuffer;

    //2.获取帧渲染缓存区名称,绑定渲染缓存区以及将渲染缓存区与layer建立连接
    glGenRenderbuffers(1, &renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);
    [self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];

    //3.获取帧缓存区名称,绑定帧缓存区以及将渲染缓存区附着到帧缓存区上
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderBuffer);
}

- (void)filterBar:(FilterBar *)filterBar didScrollToIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            [self setupNormalShaderProgram];
            break;
        case 1:
            [self setupShaderProgramWithName:@"splitScreen_2"];

            break;
        case 2:
            [self setupShaderProgramWithName:@"splitScreen_3"];

            break;
        case 3:
            [self setupShaderProgramWithName:@"splitScreen_4"];

            break;
        case 4:
            [self setupShaderProgramWithName:@"splitScreen_6"];

            break;

        case 5:
            [self setupShaderProgramWithName:@"splitScreen_9"];

            break;

        default:
            break;
    }

    [self startFilterAnimation];
}

#pragma mark --  初始化 FilterBar --
- (void)setupFilterBar {
    CGFloat barHeight = 100;
    FilterBar *filterBar = [[FilterBar alloc] initWithFrame:CGRectMake(0, kScreenHeight - barHeight, kScreenWidth, barHeight)];

    filterBar.delegate = self;
    [self.view addSubview:filterBar];

    filterBar.itemList = @[@"无", @"2分屏", @"3分屏", @"4分屏", @"6分屏", @"9分屏"];
}

//获取渲染缓存区的宽
- (GLint)drawableWidth {
    GLint backingWidth;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    return backingWidth;
}

//获取渲染缓存区的高
- (GLint)drawableHeight {
    GLint backingHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    return backingHeight;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
