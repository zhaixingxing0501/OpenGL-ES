//
//  GPUImagePhotosVC.m
//  OpenGL-ES
//
//  Created by nucarf on 2020/8/18.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import "GPUImagePhotosVC.h"
#import <GPUImage.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <PhotosUI/PhotosUI.h>

@interface GPUImagePhotosVC ()

@property (nonatomic, strong) GPUImageGrayscaleFilter *mFilter;
@property (nonatomic, strong) GPUImageStillCamera *mCamera;
@property (strong, nonatomic) IBOutlet GPUImageView *mGPUImageView;

@end

@implementation GPUImagePhotosVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addFilterCamera];
}

- (void)addFilterCamera {
    NSLog(@"开始");
    //1. 设置相机
    self.mCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionBack];
    //竖屏方向
    self.mCamera.outputImageOrientation =  UIInterfaceOrientationPortrait;

    //设置滤镜
    self.mFilter = [[GPUImageGrayscaleFilter alloc] init];

    //相机添加滤镜
    [self.mCamera addTarget:self.mFilter];
    //滤镜渲染View
    [self.mFilter addTarget:self.mGPUImageView];

    // 开始捕捉
    [self.mCamera startCameraCapture];
    NSLog(@"结束");

}

- (IBAction)switchCamera:(id)sender {
    //旋转摄像头
    [self.mCamera rotateCamera];
}

- (IBAction)takePhoto:(id)sender {
    //拍照保存到相册

    [self.mCamera capturePhotoAsJPEGProcessedUpToFilter:self.mFilter withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            dispatch_async(dispatch_get_main_queue(),^{
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"保存成功"];
                
            });
            [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:processedJPEG options:nil];
        } completionHandler:^(BOOL success, NSError *_Nullable error) {
            
        }];

        
        //获取拍摄的图片
        UIImage *image = [UIImage imageWithData:processedJPEG];
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
