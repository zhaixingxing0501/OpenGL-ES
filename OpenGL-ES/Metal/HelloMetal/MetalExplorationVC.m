//
//  MetalExplorationVC.m
//  OpenGL-ES
//
//  Created by nucarf on 2020/8/20.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import "MetalExplorationVC.h"
#import "MetalExplorerRender.h"

@import MetalKit;

@interface MetalExplorationVC ()
{
    MTKView *_mtkView;
    MetalExplorerRender *_render;
}

@end

@implementation MetalExplorationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1. 获取view
    _mtkView = (MTKView *)self.view;
    
    //2. 一个MTLDevice 对象就代表这着一个GPU,通常我们可以调用方法MTLCreateSystemDefaultDevice()来获取代表默认的GPU单个对象.
    _mtkView.device =  MTLCreateSystemDefaultDevice();
    
    //3.判断是否设置成功
    NSAssert(_mtkView.device, @"device create failed");
    
    //4. 分开你的渲染循环:
    //在我们开发Metal 程序时,将渲染循环分为自己创建的类,是非常有用的一种方式,使用单独的类,我们可以更好管理初始化Metal,以及Metal视图委托.
    _render = [[MetalExplorerRender alloc] initWithMetalKitView:_mtkView];
    NSAssert(_render, @"render create failed");
    
    //5. 设置delagate
    _mtkView.delegate = _render;
    
    //6. 视图可以根据视图属性上设置帧速率(指定时间来调用drawInMTKView方法--视图需要渲染时调用) 默认60FPS
    _mtkView.preferredFramesPerSecond = 60;

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
