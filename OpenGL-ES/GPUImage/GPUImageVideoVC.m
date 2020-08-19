//
//  GPUImageVideoVC.m
//  OpenGL-ES
//
//  Created by nucarf on 2020/8/18.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import "GPUImageVideoVC.h"
#import <AVKit/AVKit.h>
#import "VideoManager.h"

@interface GPUImageVideoVC ()<VideoManagerDelegate>

@property (strong, nonatomic) IBOutlet UIView *videoView;

@property (nonatomic, strong) VideoManager *videoManger;

@property (nonatomic, strong) AVPlayerViewController *player;

@property (nonatomic, strong) NSString *VideoFilePath;

@end

@implementation GPUImageVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.videoManger = [VideoManager manager];
    self.videoManger.delegate = self;
    self.videoManger.maxTime = 30.0;

    [self.videoManger showWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavigationBarHeight - kTabBarHeight - 30) superView:self.videoView];
}

- (IBAction)playAction:(UIButton *)sender {
    _player = [[AVPlayerViewController alloc] init];
    _player.player = [[AVPlayer alloc] initWithURL:[NSURL fileURLWithPath:self.VideoFilePath ]];
    _player.videoGravity = AVLayerVideoGravityResizeAspect;
    [self presentViewController:_player animated:NO completion:nil];
}

- (IBAction)startRecordAction:(UIButton *)sender {
    [self.videoManger startRecording];
}

- (IBAction)endRecordAction:(UIButton *)sender {
    [self.videoManger endRecording];
}

- (void)didStartRecordVideo {
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"开始录制..."];
}

- (void)didCompressingVideo {
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"视频压缩中..."];
}

- (void)didEndRecordVideoWithTime:(CGFloat)totalTime outputFile:(NSString *)filePath {
    [[TKAlertCenter defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"录制完毕，时长:%lu", totalTime]];
    self.VideoFilePath = filePath;
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
