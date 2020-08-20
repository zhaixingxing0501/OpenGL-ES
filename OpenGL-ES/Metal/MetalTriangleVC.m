//
//  MetalTriangleVC.m
//  OpenGL-ES
//
//  Created by nucarf on 2020/8/20.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import "MetalTriangleVC.h"
#import "TriangleRender.h"

@import MetalKit;

@interface MetalTriangleVC ()
{
    MTKView *_view;
    TriangleRender *_render;
}

@end

@implementation MetalTriangleVC

- (void)viewDidLoad {
    [super viewDidLoad];

    _view = (MTKView *)self.view;

    _view.device = MTLCreateSystemDefaultDevice();

    NSAssert(_view.device, @"device create failed");

    _render = [[TriangleRender alloc] initWithMetalMTKView:_view];

    NSAssert(_render, @"render create failed");

    [_render mtkView:_view drawableSizeWillChange:_view.drawableSize];

    _view.delegate = _render;
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
