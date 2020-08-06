//
//  EmitterVC3.m
//  OpenGL-ES
//
//  Created by nucarf on 2020/8/6.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import "EmitterVC3.h"

@interface EmitterVC3 ()

@property (nonatomic, strong) CAEmitterLayer *rainLayer;

@end

@implementation EmitterVC3

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupRain];
}

- (void)setupRain {
    CAEmitterLayer *rainLayer = [CAEmitterLayer layer];
    [self.view.layer addSublayer:rainLayer];
    self.rainLayer = rainLayer;

    //3.发射形状--线性
    rainLayer.emitterShape = kCAEmitterLayerLine;
    //发射模式
    rainLayer.emitterMode = kCAEmitterLayerSurface;
    //发射源大小
    rainLayer.emitterSize = self.view.frame.size;
    //发射源位置 y最好不要设置为0 最好<0
    rainLayer.emitterPosition = CGPointMake(self.view.bounds.size.width * 0.5, -10);

    // 2. 配置cell
    CAEmitterCell *snowCell = [CAEmitterCell emitterCell];
    //粒子内容
    snowCell.contents = (id)[[UIImage imageNamed:@"rain_white"] CGImage];
    //每秒产生的粒子数量的系数
    snowCell.birthRate = 25.f;
    //粒子的生命周期
    snowCell.lifetime = 20.f;
    //speed粒子速度.图层的速率。用于将父时间缩放为本地时间，例如，如果速率是2，则本地时间的进度是父时间的两倍。默认值为1。
    snowCell.speed = 10.f;
    //粒子速度系数, 默认1.0
    snowCell.velocity = 10.f;
    //每个发射物体的初始平均范围,默认等于0
    snowCell.velocityRange = 10.f;
    //粒子在y方向的加速的
    snowCell.yAcceleration = 1000.f;
    //粒子缩放比例: scale
    snowCell.scale = 0.1;
    //粒子缩放比例范围:scaleRange
    snowCell.scaleRange = 0.f;

    // 3.添加到图层上
    rainLayer.emitterCells = @[snowCell];
}

- (IBAction)rainAction:(UIButton *)sender {
    if (!sender.selected) {
        NSLog(@"雨停了");
        // 停止下雨
        [self.rainLayer setValue:@0.f forKeyPath:@"birthRate"];
    } else {
        NSLog(@"开始下雨了");
        // 开始下雨
        [self.rainLayer setValue:@1.f forKeyPath:@"birthRate"];
    }
    sender.selected = !sender.selected;
}

- (IBAction)bigAction:(UIButton *)sender {
    NSInteger rate = 1;
    CGFloat scale = 0.05;
    if (sender.tag == 100) {
        NSLog(@"下大了");

        if (self.rainLayer.birthRate < 30) {
            [self.rainLayer setValue:@(self.rainLayer.birthRate + rate) forKeyPath:@"birthRate"];
            [self.rainLayer setValue:@(self.rainLayer.scale + scale) forKeyPath:@"scale"];
        }
    } else if (sender.tag == 200) {
        NSLog(@"变小了");

        if (self.rainLayer.birthRate > 1) {
            [self.rainLayer setValue:@(self.rainLayer.birthRate - rate) forKeyPath:@"birthRate"];
            [self.rainLayer setValue:@(self.rainLayer.scale - scale) forKeyPath:@"scale"];
        }
    }
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
