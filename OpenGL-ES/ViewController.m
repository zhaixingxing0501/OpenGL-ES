//
//  ViewController.m
//  OpenGL-ES
//
//  Created by nucarf on 2020/7/29.
//  Copyright © 2020 zhaixingxing. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = [UIView new];

    
    NSArray *arr1 = @[
        [self makeItemWithTitle:@"CoreAnimation粒子动画1" subTitle:@"" image:@"" className:@"EmitterVC1" selector:@""],
        [self makeItemWithTitle:@"CoreAnimation粒子动画2" subTitle:@"" image:@"" className:@"EmitterVC2" selector:@""],
        [self makeItemWithTitle:@"CoreAnimation粒子动画3" subTitle:@"" image:@"" className:@"EmitterVC3" selector:@""],
        [self makeItemWithTitle:@"CoreAnimation粒子动画4" subTitle:@"" image:@"" className:@"EmitterVC4" selector:@""],
    ];

    NSArray *arr2 = @[
        [self makeItemWithTitle:@"GLSL加载图片" subTitle:@"" image:@"" className:@"CubeViewController" selector:@""],
        [self makeItemWithTitle:@"GLSL三角形变换" subTitle:@"" image:@"" className:@"GLSLTriangleTransformVC" selector:@""],
        [self makeItemWithTitle:@"滤镜效果" subTitle:@"" image:@"" className:@"FilterViewController" selector:@""],
        [self makeItemWithTitle:@"长腿滤镜" subTitle:@"" image:@"" className:@"LongLegsVC" selector:@""],
        [self makeItemWithTitle:@"GPUImage静态图片-饱和度滤镜" subTitle:@"" image:@"" className:@"GPUImagePhotoVC" selector:@""],
        [self makeItemWithTitle:@"GPUImage拍照-灰度滤镜" subTitle:@"" image:@"" className:@"GPUImagePhotosVC" selector:@""],
        [self makeItemWithTitle:@"GPUImage适配录制-饱和度滤镜" subTitle:@"" image:@"" className:@"GPUImageVideoVC" selector:@""],

    ];

    self.dataSource = [@[arr1, arr2] mutableCopy];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dataSource[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.dataSource.count - 1) return 0.0;
    return 30.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    NSArray *arr = self.dataSource[indexPath.section];

    NSDictionary *item = arr[indexPath.row];
    cell.textLabel.text = item[@"title"];
    cell.detailTextLabel.text = item[@"subTitle"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = self.dataSource[indexPath.section];
    NSDictionary *item = arr[indexPath.row];

    if ([item[@"selector"] length] > 0 && [self respondsToSelector:NSSelectorFromString(item[@"selector"])]) {
        SEL selector = NSSelectorFromString(item[@"selector"]);
        ((void (*)(id, SEL))[self methodForSelector:selector])(self, selector);
    } else if (!kStringIsEmpty(item[@"class"])) {
        BaseViewController *vc = [[NSClassFromString(item[@"class"]) alloc] init];
        vc.title = item[@"title"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSLog(@"没有跳转方法:%@", item);
    }
}

@end
