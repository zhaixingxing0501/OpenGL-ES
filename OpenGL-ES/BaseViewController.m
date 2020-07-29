//
//  BaseViewController.m
//  NucarfProject
//
//  Created by zhaixingxing on 2019/8/7.
//  Copyright © 2019 zhaixingxing. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    // Do any additional setup after loading the view.
}

- (NSDictionary *)makeItemWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(NSString *)imageName className:(NSString *)className selector:(NSString *)selectorName {
    return @{ @"title": title,
              @"subTitle": subTitle,
              @"imageName": imageName,
              @"class": className,
              @"selector": selectorName };
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
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
