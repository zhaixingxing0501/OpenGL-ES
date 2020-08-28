//
//  BasicTextureRender.h
//  OpenGL-ES
//
//  Created by nucarf on 2020/8/25.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MetalKit;

NS_ASSUME_NONNULL_BEGIN

@interface BasicTextureRender : NSObject<MTKViewDelegate>

- (instancetype)initWithMetalMTKView:(MTKView *)mtkView;

@end

NS_ASSUME_NONNULL_END
