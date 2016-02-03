//
//  MainViewController.m
//  瀑布流
//
//  Created by apple on 13-10-14.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MainViewController.h"
#import "WaterFlowCellView.h"
#import "MGJData.h"
#import "UIImageView+WebCache.h"

@interface MainViewController ()

// 数据列表
@property (strong, nonatomic) NSMutableArray *dataList;
// 当前显示列数
@property (assign, nonatomic) NSInteger dataColumns;

#pragma mark - 加载网络数据属性
// 当前是否正在加载数据
@property (assign, nonatomic) BOOL isLoadingData;

@end

@implementation MainViewController

#pragma mark - 私有方法
- (void)loadMGJData
{
    self.isLoadingData = YES;

    NSString *path = [[NSBundle mainBundle] pathForResource:@"mogujie" ofType:@"plist"];

    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:path];

    NSArray *array = dict[@"result"][@"list"];
    
    if (self.dataList == nil) {
        self.dataList = [NSMutableArray array];
    }
    
    // 对self.dataList直接进行拼接
    for (NSDictionary *dict in array) {
        NSDictionary *showDict = dict[@"show"];
        
        MGJData *data = [[MGJData alloc]init];
        [data setValuesForKeysWithDictionary:showDict];
        
        [self.dataList addObject:data];
    }
    
    // 重新刷新数据
    self.isLoadingData = NO;
    [self.waterFlowView reloadData];
    
    // 2. 强烈提醒，需要测试
//    NSLog(@"%@", self.dataList);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadMGJData];
}

#pragma mark 从某个方向旋转设备
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // 如果发生设备旋转，重新加载数据
    [self.waterFlowView reloadData];
}

#pragma mark - 数据源方法
#pragma mark - 列数
- (NSInteger)numberOfColumnsInWaterFlowView:(WaterFlowView *)waterFlowView
{
    // 可以根据设备的当前方向，设定要显示的数据列数
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        
        self.dataColumns = 4;
    } else {
        self.dataColumns = 3;
    }
    
    return self.dataColumns;
}

#pragma mark - 行数
- (NSInteger)waterFlowView:(WaterFlowView *)waterFlowView numberOfRowsInColumns:(NSInteger)columns
{
    return self.dataList.count;
}

- (WaterFlowCellView *)waterFlowView:(WaterFlowView *)waterFlowView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MyCell";
    
    WaterFlowCellView *cell = [waterFlowView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[WaterFlowCellView alloc]initWithResueIdentifier:ID];
    }
    
    // 设置cell
    MGJData *data = self.dataList[indexPath.row];
    
    [cell.textLabel setText:data.price];
    
    // 异步加载图像
    /*
     提示，使用SDWebImage可以指定缓存策略，包括内存缓存 并 磁盘缓存
     */
    [cell.imageView setImageWithURL:data.img];
    
    return cell;
}

#pragma mark - 每个单元格的高度
- (CGFloat)waterFlowView:(WaterFlowView *)waterFlowView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGJData *data = self.dataList[indexPath.row];
    
    // 计算图像的高度
    // 例如：h = 275 w = 200 目前的宽度是 320 / 3 = 106.667
    CGFloat colWidth = self.view.bounds.size.width / self.dataColumns;
    
    return colWidth / data.w * data.h;
}

#pragma mark - 选中单元格
- (void)waterFlowView:(WaterFlowView *)waterFlowView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选中单元格： %@", indexPath);
    
//    MGJData *data = self.dataList[indexPath.row];
    // 取大图URL，异步加载并显示相册
    
}

#pragma mark - 刷新网络数据
- (void)waterFlowViewRefreshData:(WaterFlowView *)waterFlowView
{
    NSLog(@"加载数据。。。");
    
    // 1. 如果当前正在刷新数据，则不在执行后续方法
    if (self.isLoadingData) {
        return;
    }
    
    [self loadMGJData];
}

@end
