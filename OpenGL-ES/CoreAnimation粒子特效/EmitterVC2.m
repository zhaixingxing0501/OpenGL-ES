//
//  EmitterVC2.m
//  OpenGL-ES
//
//  Created by nucarf on 2020/8/6.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import "EmitterVC2.h"

@interface EmitterVC2 ()

@property (nonatomic, strong) CAEmitterLayer *colorBallLayer;

@end

@implementation EmitterVC2

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.blackColor;

    [self setupEmitter];
}

- (void)setupEmitter {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight - 20, kScreenWidth, 20)];
    label.text = @"轻点或者拖动改变发射源位置";
    label.textColor = UIColor.whiteColor;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];

    /*
      emitterShape: 形状:
      1. 点;kCAEmitterLayerPoint .
      2. 线;kCAEmitterLayerLine
      3. 矩形框: kCAEmitterLayerRectangle
      4. 立体矩形框: kCAEmitterLayerCuboid
      5. 圆形: kCAEmitterLayerCircle
      6. 立体圆形: kCAEmitterLayerSphere

      emitterMode:
      kCAEmitterLayerPoints
      kCAEmitterLayerOutline
      kCAEmitterLayerSurface
      kCAEmitterLayerVolume

      */

    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    [self.view.layer addSublayer:emitterLayer];
    self.colorBallLayer = emitterLayer;

    emitterLayer.emitterSize = self.view.frame.size;
    emitterLayer.emitterShape = kCAEmitterLayerPoint;
    emitterLayer.emitterMode = kCAEmitterLayerPoints;
    emitterLayer.emitterPosition = CGPointMake(self.view.layer.bounds.size.width / 2, 0.0f);

    //2.配置CAEmitterCell
    CAEmitterCell *colorBarCell = [CAEmitterCell emitterCell];
    colorBarCell.name = @"colorBarCell";
    colorBarCell.birthRate = 20.0f;
    colorBarCell.lifetime = 10.0f;
    colorBarCell.velocity = 40.0f;
    colorBarCell.velocityRange = 100.0f;
    colorBarCell.yAcceleration = 15.0f;
    colorBarCell.emissionLatitude = M_PI;
    colorBarCell.emissionRange = M_PI_4;
    colorBarCell.scale = 0.2;
    colorBarCell.scaleRange = 0.1;
    colorBarCell.scaleSpeed = 0.02;
    colorBarCell.contents = (id)[[UIImage imageNamed:@"circle_white"]CGImage];
    colorBarCell.color = [[UIColor colorWithRed:0.5 green:0.0f blue:0.5f alpha:1.0f]CGColor];
    colorBarCell.redRange = 1.0f;
    colorBarCell.greenRange = 1.0f;
    colorBarCell.alphaRange = 0.8f;
    colorBarCell.blueSpeed = 1.0f;
    colorBarCell.alphaSpeed = -0.1f;

    emitterLayer.emitterCells = @[colorBarCell];
}

#pragma mark -- 更新发射源位置 --
- (void)updateEmitterPosition:(CGPoint)position {
    self.colorBallLayer.emitterPosition = position;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [self locationFromTouchEvent:event];
    [self updateEmitterPosition:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [self locationFromTouchEvent:event];
    [self updateEmitterPosition:point];
}

#pragma mark -- 获取手指点击位置 --
- (CGPoint)locationFromTouchEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    return [touch locationInView:self.view];
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
