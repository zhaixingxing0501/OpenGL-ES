//
//  VideoManager.h
//  OpenGL-ES
//
//  Created by nucarf on 2020/8/19.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPUImage.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VideoManagerDelegate <NSObject>

/** 开始录制 */
-(void)didStartRecordVideo;

/** 视频压缩中 */
-(void)didCompressingVideo;

/** 结束录制 */
-(void)didEndRecordVideoWithTime:(CGFloat)totalTime outputFile:(NSString *)filePath;


@end

@interface VideoManager : NSObject

/** 录制视频区域 */
@property (nonatomic,assign) CGRect frame;
/** 录制视频最大时长 */
@property (nonatomic,assign) CGFloat maxTime;

@property (nonatomic,weak) id <VideoManagerDelegate> delegate;


+ (instancetype)manager;

- (void)showWithFrame:(CGRect)frame superView:(UIView *)superView;
/**
 开始录制
 */
-(void)startRecording;


/**
 结束录制
 */
-(void)endRecording;


/**
 暂停录制
 */
-(void)pauseRecording;


/**
 继续录制
 */
-(void)resumeRecording;

/**
 打开闪光灯
 
 @param on YES开  NO关
 */
-(void)turnTorchOn:(BOOL)on;


@end

NS_ASSUME_NONNULL_END
