//
//  BaseViewController.h
//  NucarfProject
//
//  Created by zhaixingxing on 2019/8/7.
//  Copyright © 2019 zhaixingxing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *dataSource;


- (NSDictionary *)makeItemWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(NSString *)imageName className:(NSString *)className selector:(NSString *)selectorName;

@end

NS_ASSUME_NONNULL_END
