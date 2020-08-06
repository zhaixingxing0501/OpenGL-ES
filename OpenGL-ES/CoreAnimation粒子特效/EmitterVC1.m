//
//  EmitterVC1.m
//  OpenGL-ES
//
//  Created by nucarf on 2020/8/5.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import "EmitterVC1.h"

@interface EmitterVC1 ()

@property (nonatomic, strong) CAEmitterLayer *rainLayer;

@end

@implementation EmitterVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self rainHongBao];
}

- (void)rainHongBao {
    //1.设置粒子发射器
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    [self.view.layer addSublayer:emitter];

    //2.粒子发现形状
    emitter.emitterShape = kCAEmitterLayerLine;
    emitter.emitterMode = kCAEmitterLayerSurface;
    emitter.emitterSize = self.view.frame.size;
    //粒子发射源
    emitter.emitterPosition = CGPointMake(self.view.bounds.size.width * 0.5, -10);

    //配置粒子发射cell
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    emitterCell.contents = (id)[[UIImage imageNamed:@"hongbao.png"] CGImage];
    emitterCell.birthRate = 1.0;
    emitterCell.lifetime = 30;
    emitterCell.speed = 2;
    emitterCell.velocity = 10.f;
    emitterCell.velocityRange = 10.f;
    emitterCell.yAcceleration = 60;
    emitterCell.scale = 0.05;
    emitterCell.scaleRange = 0.f;

    // 3.添加到图层上
//    emitter.emitterCells = @[emitterCell];
    

    self.rainLayer = emitter;
    
    [self setupEmitterCell];

}

#pragma mark --  配置多种粒子特效 --
- (void)setupEmitterCell {
    //2. 配置cell
    CAEmitterCell * snowCell = [CAEmitterCell emitterCell];
    snowCell.contents = (id)[[UIImage imageNamed:@"jinbi.png"] CGImage];
    snowCell.birthRate = 1.0;
    snowCell.lifetime = 30;
    snowCell.speed = 2;
    snowCell.velocity = 10.f;
    snowCell.velocityRange = 10.f;
    snowCell.yAcceleration = 60;
    snowCell.scale = 0.1;
    snowCell.scaleRange = 0.f;
    
    CAEmitterCell * hongbaoCell = [CAEmitterCell emitterCell];
    hongbaoCell.contents = (id)[[UIImage imageNamed:@"hongbao.png"] CGImage];
    hongbaoCell.birthRate = 1.0;
    hongbaoCell.lifetime = 30;
    hongbaoCell.speed = 2;
    hongbaoCell.velocity = 10.f;
    hongbaoCell.velocityRange = 10.f;
    hongbaoCell.yAcceleration = 60;
    hongbaoCell.scale = 0.05;
    hongbaoCell.scaleRange = 0.f;
    
    CAEmitterCell * zongziCell = [CAEmitterCell emitterCell];
    zongziCell.contents = (id)[[UIImage imageNamed:@"zongzi2.jpg"] CGImage];
    zongziCell.birthRate = 1.0;
    zongziCell.lifetime = 30;
    zongziCell.speed = 2;
    zongziCell.velocity = 10.f;
    zongziCell.velocityRange = 10.f;
    zongziCell.yAcceleration = 60;
    zongziCell.scale = 0.05;
    zongziCell.scaleRange = 0.f;
    

    self.rainLayer.emitterCells = @[snowCell,hongbaoCell,zongziCell];
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
