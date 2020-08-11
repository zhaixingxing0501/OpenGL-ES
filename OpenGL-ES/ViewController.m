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

    self.dataSource = [@[
                           [self makeItemWithTitle:@"CoreAnimation粒子动画1" subTitle:@"" image:@"" className:@"EmitterVC1" selector:@""],
                           [self makeItemWithTitle:@"CoreAnimation粒子动画2" subTitle:@"" image:@"" className:@"EmitterVC2" selector:@""],
                           [self makeItemWithTitle:@"CoreAnimation粒子动画3" subTitle:@"" image:@"" className:@"EmitterVC3" selector:@""],
                           [self makeItemWithTitle:@"CoreAnimation粒子动画4" subTitle:@"" image:@"" className:@"EmitterVC4" selector:@""],

                           [self makeItemWithTitle:@"GLSL加载图片" subTitle:@"" image:@"" className:@"CubeViewController" selector:@""],
                           [self makeItemWithTitle:@"GLSL三角形变换" subTitle:@"" image:@"" className:@"GLSLTriangleTransformVC" selector:@""],
                           [self makeItemWithTitle:@"滤镜分屏" subTitle:@"" image:@"" className:@"FilterViewController" selector:@""],
                           [self makeItemWithTitle:@"GPUImage初探" subTitle:@"" image:@"" className:@"GPUImageExampleVC" selector:@""],
                                                      [self makeItemWithTitle:@"GPUImage初探" subTitle:@"" image:@"" className:@"GPUPhotoVC" selector:@""],

                           //                           [self makeItemWithTitle:@"GPUImage初探" subTitle:@"" image:@"" className:@"GPUImageExampleVC" selector:@""],

                           //                           [self makeItemWithTitle:@"GPUImage初探" subTitle:@"" image:@"" className:@"GPUImageExampleVC" selector:@""],

                           //                           [self makeItemWithTitle:@"GPUImage初探" subTitle:@"" image:@"" className:@"GPUImageExampleVC" selector:@""],

                       ] mutableCopy];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *item = self.dataSource[indexPath.row];
    cell.textLabel.text = item[@"title"];
    cell.detailTextLabel.text = item[@"subTitle"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = self.dataSource[indexPath.row];

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
