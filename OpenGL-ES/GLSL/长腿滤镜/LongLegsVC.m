//
//  LongLegsVC.m
//  OpenGL-ES
//
//  Created by nucarf on 2020/8/17.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import "LongLegsVC.h"
#import "LongLegsView.h"

@interface LongLegsVC ()

@property (strong, nonatomic) IBOutlet UIButton *topBtn;
@property (strong, nonatomic) IBOutlet UIButton *bottomBtn;
@property (strong, nonatomic) IBOutlet UIView *topLine;
@property (strong, nonatomic) IBOutlet UIView *bottomLine;
@property (strong, nonatomic) IBOutlet UIView *maskView;
@property (strong, nonatomic) IBOutlet UISlider *sliderView;

@end

@implementation LongLegsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createtUI];
}

//当调用buttopTop按钮时,界面变换(需要重新子view的位置以及约束信息)
- (void)actionPanTop:(UIPanGestureRecognizer *)pan {
    //1.判断springView是否发生改变
//    if ([self.springView hasChange]) {
//        //2.给springView 更新纹理
//        [self.springView updateTexture];
//        //3.重置滑杆位置(因为此时相当于对一个张新图重新进行拉伸处理~)
//        self.slider.value = 0.5f;
//    }
//
//    //修改约束信息;
    CGPoint translation = [pan translationInView:self.view];
//    //修改topLineSpace的预算条件;
//    self.topLineSpace.constant = MIN(self.topLineSpace.constant + translation.y,
//                                     self.bottomLineSpace.constant);
//
//    //纹理Top = springView的height * textureTopY
//    //606
//    CGFloat textureTop = self.springView.bounds.size.height * self.springView.textureTopY;
//    NSLog(@"%f,%f",self.springView.bounds.size.height,self.springView.textureTopY);
//    NSLog(@"%f",textureTop);
//
//    //设置topLineSpace的约束常量;
//    self.topLineSpace.constant = MAX(self.topLineSpace.constant, textureTop);
//    //将pan移动到view的Zero位置;
//    [pan setTranslation:CGPointZero inView:self.view];
//
//    //计算移动了滑块后的currentTop和currentBottom
//    self.currentTop = [self stretchAreaYWithLineSpace:self.topLineSpace.constant];
//    self.currentBottom = [self stretchAreaYWithLineSpace:self.bottomLineSpace.constant];
}

//与buttopTop 按钮事件所发生的内容几乎一样,不做详细注释了.
- (void)actionPanBottom:(UIPanGestureRecognizer *)pan {
//    if ([self.springView hasChange]) {
//        [self.springView updateTexture];
//        self.slider.value = 0.5f;
//    }
//    
//    CGPoint translation = [pan translationInView:self.view];
//    self.bottomLineSpace.constant = MAX(self.bottomLineSpace.constant + translation.y,
//                                        self.topLineSpace.constant);
//    CGFloat textureBottom = self.springView.bounds.size.height * self.springView.textureBottomY;
//    self.bottomLineSpace.constant = MIN(self.bottomLineSpace.constant, textureBottom);
//    [pan setTranslation:CGPointZero inView:self.view];
//    
//    self.currentTop = [self stretchAreaYWithLineSpace:self.topLineSpace.constant];
//    self.currentBottom = [self stretchAreaYWithLineSpace:self.bottomLineSpace.constant];
}

#pragma mark -- 初始化View --

- (void)createtUI {
    self.topBtn.layer.cornerRadius = 15;
    [self.topBtn addGestureRecognizer:[[UIPanGestureRecognizer alloc]
                                       initWithTarget:self
                                               action:@selector(actionPanTop:)]];

    self.bottomBtn.layer.cornerRadius = 15;
    [self.bottomBtn addGestureRecognizer:[[UIPanGestureRecognizer alloc]
                                          initWithTarget:self
                                                  action:@selector(actionPanBottom:)]];
}

- (void)setViewsHidden:(BOOL)hidden {
    self.topLine.hidden = hidden;
    self.bottomLine.hidden = hidden;
    self.topBtn.hidden = hidden;
    self.bottomBtn.hidden = hidden;
    self.maskView.hidden = hidden;
}

- (IBAction)silderValueChanged:(UISlider *)sender {
}

- (IBAction)sliderDidTouchDown:(UISlider *)sender {
    [self setViewsHidden:YES];
}

- (IBAction)sliderDidTouchUp:(id)sender {
    [self setViewsHidden:NO];
}

- (IBAction)saveBtnAction:(UIButton *)sender {
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
