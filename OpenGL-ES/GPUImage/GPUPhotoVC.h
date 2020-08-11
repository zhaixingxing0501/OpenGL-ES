//
//  GPUPhotoVC.h
//  OpenGL-ES
//
//  Created by nucarf on 2020/8/11.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import "BaseViewController.h"
#import <GPUImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPUPhotoVC : BaseViewController
{
    GPUImageStillCamera *stillCamera;
    GPUImageOutput<GPUImageInput> *filter, *secondFilter, *terminalFilter;
    UISlider *filterSettingsSlider;
    UIButton *photoCaptureButton;

    GPUImagePicture *memoryPressurePicture1, *memoryPressurePicture2;
}

@end

NS_ASSUME_NONNULL_END
