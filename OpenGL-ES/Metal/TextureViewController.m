//
//  TextureViewController.m
//  OpenGL-ES
//
//  Created by nucarf on 2020/8/25.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import "TextureViewController.h"
#import "BasicTextureRender.h"

@import MetalKit;

@interface TextureViewController (){
    BasicTextureRender *_render;
        MTKView *_mtkView;
}

@end

@implementation TextureViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _mtkView = (MTKView *)self.view;
    
    _mtkView.device = MTLCreateSystemDefaultDevice();
    
    NSAssert(_mtkView.device, @"Meatal is not supported on the device");
    
    
    _render = [[BasicTextureRender alloc] initWithMetalMTKView:_mtkView];
    
    NSAssert(_render, @"Renderer failed initialization");
    
    [_render mtkView:_mtkView drawableSizeWillChange:_mtkView.drawableSize];
    
    _mtkView.delegate = _render;
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
