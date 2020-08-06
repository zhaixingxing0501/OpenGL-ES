//
//  GLSLTriangleTransformVC.m
//  OpenGL-ES
//
//  Created by nucarf on 2020/8/6.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import "GLSLTriangleTransformVC.h"
#import "TriangleTransformView.h"

@interface GLSLTriangleTransformVC ()

@property (nonatomic, strong) TriangleTransformView *cView;

@end

@implementation GLSLTriangleTransformVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cView = (TriangleTransformView *)self.view;
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
