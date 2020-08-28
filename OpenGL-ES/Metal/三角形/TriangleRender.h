//
//  TriangleRender.h
//  OpenGL-ES
//
//  Created by nucarf on 2020/8/20.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MetalKit;

NS_ASSUME_NONNULL_BEGIN

/// 这是一个独立于平台的渲染类
/// MTKViewDelegate协议:允许对象呈现在视图中并响应调整大小事件
@interface TriangleRender : NSObject<MTKViewDelegate>

- (instancetype)initWithMetalMTKView:(MTKView *)mtkView;

@end

NS_ASSUME_NONNULL_END
