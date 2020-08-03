//
//  CubeViewController.m
//  OpenGL-ES
//
//  Created by nucarf on 2020/7/29.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import "CubeViewController.h"
#import <GLKit/GLKit.h>
#import "CubeView.h"

@interface CubeViewController ()

@end

@implementation CubeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    CubeView *cube = [[CubeView alloc] initWithFrame:self.view.bounds];

    [self.view addSubview:cube];
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
