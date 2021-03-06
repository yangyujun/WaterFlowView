//
//  WaterFlowViewController.m
//  瀑布流
//
//  Created by apple on 13-10-14.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "WaterFlowViewController.h"

@interface WaterFlowViewController ()

@end

@implementation WaterFlowViewController

#pragma mark - 实例化视图
- (void)loadView
{
    // 如此做法是为了保证视图控制器能够嵌套使用！
    // 1. 实例化一个没有大小的瀑布流视图
    _waterFlowView = [[WaterFlowView alloc]initWithFrame:CGRectZero];
    
    // 2. 要保证当前视图与父视图同样大小
    // 如果看到头文件中的枚举类型有位移符号，就可以使用 | “并”操作，可以同时使用多个选项！
    [_waterFlowView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    
    // 3. 设置代理和数据源
    [_waterFlowView setDataSource:self];
    [_waterFlowView setDelegate:self];
    
    // 4. 与根视图等同
    self.view = _waterFlowView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.waterFlowView reloadData];
}

#pragma mark - 数据源方法
// 提示：以下两个协议方法的实现，都是空方法，具体的实现，应该在子类中完成
- (NSInteger)waterFlowView:(WaterFlowView *)waterFlowView numberOfRowsInColumns:(NSInteger)columns
{
    return 0;
}

- (WaterFlowCellView *)waterFlowView:(WaterFlowView *)waterFlowView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
