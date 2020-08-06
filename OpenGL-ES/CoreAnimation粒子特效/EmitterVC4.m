//
//  EmitterVC4.m
//  OpenGL-ES
//
//  Created by nucarf on 2020/8/6.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import "EmitterVC4.h"
#import "AnimationButton.h"

@interface EmitterVC4 ()

@end

@implementation EmitterVC4

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)btnAction:(AnimationButton *)sender {
    if (!sender.selected) { // 点赞
        sender.selected = !sender.selected;
        NSLog(@"点赞");
    } else {  // 取消点赞
        sender.selected = !sender.selected;
        NSLog(@"取消赞");
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
