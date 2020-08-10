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

    [self setupFilterBar];

    [self startFilterAnimation];
}

#pragma mark --  开始滤镜动画 --
- (void)startFilterAnimation {
}

#pragma mark --  滤镜相关初始化 --
- (void)setupFilter {
    //1. 初始化上下文并设置
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self.context = nil;
    if (!self.context) {
        NSAssert(NO, @"create content failed");
    }
    
    if (![EAGLContext setCurrentContext:self.context]) {
        
    }
    
}

- (void)filterBar:(FilterBar *)filterBar didScrollToIndex:(NSUInteger)index {
    switch (index) {
        case 0:

            break;

        default:
            break;
    }
}

#pragma mark --  初始化 FilterBar --
- (void)setupFilterBar {
    CGFloat barHeight = 100;
    FilterBar *filterBar = [[FilterBar alloc] initWithFrame:CGRectMake(0, kScreenHeight - barHeight, kScreenWidth, barHeight)];

    filterBar.delegate = self;
    [self.view addSubview:filterBar];

    filterBar.itemList = @[@"无", @"2分屏", @"3分屏", @"4分屏", @"6分屏", @"9分屏"];
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
