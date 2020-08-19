//
//  GPUImagePhotoVC.m
//  OpenGL-ES
//
//  Created by nucarf on 2020/8/18.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import "GPUImagePhotoVC.h"
#import <GPUImage.h>

@interface GPUImagePhotoVC ()

@property (nonatomic, strong) GPUImageSaturationFilter *mFilter;

@property (strong, nonatomic) IBOutlet UIImageView *filterIMGV;

@property (nonatomic, strong) UIImage *renderImage;

@end

@implementation GPUImagePhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //1. 获取图片
    self.renderImage = [UIImage imageNamed:@"img5.jpeg"];
    //显示图片
    self.filterIMGV.image = self.renderImage;
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    //2. 选择滤镜设置饱和度
    self.mFilter.saturation = 1;

    //3. 设置徐然区域的大小 -> 图片大小
    [self.mFilter forceProcessingAtSize:self.renderImage.size];

    //4. 使用单个滤镜
    [self.mFilter useNextFrameForImageCapture];

    //5. 设置饱和度
    self.mFilter.saturation = sender.value;

    //6. 读取图片
    GPUImagePicture *stillImageSoucer = [[GPUImagePicture alloc] initWithImage:self.renderImage];

    //7. 图片设置滤镜
    [stillImageSoucer addTarget:self.mFilter];

    //8. 渲染图片
    [stillImageSoucer processImage];

    //9. 获取渲染图片
    UIImage *newImage = [self.mFilter imageFromCurrentFramebuffer];

    //10. 显示图片
    self.filterIMGV.image = newImage;
}

- (GPUImageSaturationFilter *)mFilter {
    if (!_mFilter) {
        _mFilter = [[GPUImageSaturationFilter alloc] init];
    }
    return _mFilter;
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
