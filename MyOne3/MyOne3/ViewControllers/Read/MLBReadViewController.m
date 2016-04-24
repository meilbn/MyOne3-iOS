//
//  MLBReadViewController.m
//  MyOne3
//
//  Created by meilbn on 2/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "MLBReadCarouselItem.h"
#import "MLBReadIndex.h"
#import "MLBReadBaseView.h"
#import "MLBReadDetailsViewController.h"
#import "MLBTopTenArticalViewController.h"
#import "MLBPreviousViewController.h"

@interface MLBReadViewController () <GMCPagingScrollViewDataSource, GMCPagingScrollViewDelegate> {
    AAPullToRefresh *pullToRefreshLeft;
    AAPullToRefresh *pullToRefreshRight;
}

@property (strong, nonatomic) SDCycleScrollView *carouselView;
@property (strong, nonatomic) GMCPagingScrollView *pagingScrollView;

@end

@implementation MLBReadViewController {
    NSArray *carousels;
    NSMutableArray *carouselCovers;
    MLBReadIndex *readIndex;
}

#pragma mark - Lifecycle

- (void)dealloc {
    pullToRefreshLeft.showPullToRefresh = NO;
    pullToRefreshRight.showPullToRefresh = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = MLBReadTitle;
    [self addNavigationBarLeftSearchItem];
    [self addNavigationBarRightMeItem];
    
    [self initDatas];
    [self setupViews];
    [self loadCache];
    [self requestCarousel];
    [self requestIndex];
}

#pragma mark - Private Method

- (void)initDatas {
    carouselCovers = @[].mutableCopy;
}

- (void)setupViews {
    __weak typeof(self) weakSelf = self;
    
    _carouselView = ({
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView new];
        cycleScrollView.backgroundColor = [UIColor colorWithWhite:170 / 255.0 alpha:1];// #AAAAAA
        cycleScrollView.placeholderImage = [UIImage imageNamed:@"top10"];
        cycleScrollView.autoScrollTimeInterval = 5;
        cycleScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            [weakSelf showTopTenArticalWithIndex:currentIndex];
        };
        [self.view addSubview:cycleScrollView];
        [cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.height.equalTo(@143.5);
        }];
        
        cycleScrollView;
    });
    
    _pagingScrollView = ({
        GMCPagingScrollView *pagingScrollView = [GMCPagingScrollView new];
        pagingScrollView.backgroundColor = MLBViewControllerBGColor;
        [pagingScrollView registerClass:[MLBReadBaseView class] forReuseIdentifier:kMLBReadBaseViewID];
        pagingScrollView.dataSource = self;
        pagingScrollView.delegate = self;
        pagingScrollView.pageInsets = UIEdgeInsetsZero;
        pagingScrollView.interpageSpacing = 0;
        pullToRefreshLeft = [pagingScrollView.scrollView addPullToRefreshPosition:AAPullToRefreshPositionLeft actionHandler:^(AAPullToRefresh *v) {
            [weakSelf refreshReadIndex];
            [v performSelector:@selector(stopIndicatorAnimation) withObject:nil afterDelay:1];
        }];
        pullToRefreshLeft.threshold = 100;
        pullToRefreshLeft.borderColor = MLBAppThemeColor;
        pullToRefreshLeft.borderWidth = MLBPullToRefreshBorderWidth;
        pullToRefreshLeft.imageIcon = [UIImage new];
        
        pullToRefreshRight = [pagingScrollView.scrollView addPullToRefreshPosition:AAPullToRefreshPositionRight actionHandler:^(AAPullToRefresh *v) {
            [weakSelf loadMoreReadIndex];
            [v performSelector:@selector(stopIndicatorAnimation) withObject:nil afterDelay:1];
        }];
        pullToRefreshRight.borderColor = MLBAppThemeColor;
        pullToRefreshRight.borderWidth = MLBPullToRefreshBorderWidth;
        pullToRefreshRight.imageIcon = [UIImage new];
        
        [self.view addSubview:pagingScrollView];
        [pagingScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_carouselView.mas_bottom);
            make.left.bottom.right.equalTo(self.view);
        }];
        pagingScrollView.hidden = YES;
        
        pagingScrollView;
    });
}

- (void)loadCache {
    id cacheCarousels = [NSKeyedUnarchiver unarchiveObjectWithFile:MLBCacheReadCarouselFilePath];
    if (cacheCarousels) {
        carousels = cacheCarousels;
        [self setupCarouselViewDataSource];
    }
    
    id cacheReadIndex = [NSKeyedUnarchiver unarchiveObjectWithFile:MLBCacheReadIndexFilePath];
    if (cacheReadIndex) {
        readIndex = cacheReadIndex;
        _pagingScrollView.hidden = NO;
        [_pagingScrollView reloadData];
    }
}

- (void)setupCarouselViewDataSource {
    [carouselCovers removeAllObjects];
    
    for (MLBReadCarouselItem *carousel in carousels) {
        [carouselCovers addObject:carousel.cover];
    }
    
    _carouselView.imageURLStringsGroup = carouselCovers;
}

- (NSInteger)numberOfMaxIndex {
    return MAX(MAX(readIndex.essay.count, readIndex.serial.count), readIndex.question.count);
}

#pragma mark - Action

- (void)showTopTenArticalWithIndex:(NSInteger)index {
    MLBTopTenArticalViewController *topTenArticalViewController = [[MLBTopTenArticalViewController alloc] init];
    topTenArticalViewController.carouselItem = carousels[index];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:topTenArticalViewController];
    [self presentViewController:navigationController animated:NO completion:NULL];
}

- (void)refreshReadIndex {
    // 很奇怪，不写这行代码的话，_pagingScrollView 里面的 scrollview 的 contentOffset.x 会变成和释放刷新时 contentOffset.x 的绝对值差不多，导致第一个 item 看起来像是左移了，论脑洞的重要性
    [_pagingScrollView setCurrentPageIndex:0 reloadData:NO];
}

- (void)loadMoreReadIndex {
    // 原因同上
    [_pagingScrollView setCurrentPageIndex:([self numberOfMaxIndex] - 1) reloadData:NO];
    // 显示往期列表
    MLBPreviousViewController *previousViewController = [[MLBPreviousViewController alloc] init];
    previousViewController.previousType = MLBPreviousTypeRead;
    [self.navigationController pushViewController:previousViewController animated:YES];
}

- (void)openReadDetailsViewControllerWithReadType:(MLBReadType)type {
    MLBReadDetailsViewController *readDetailsViewController = [[MLBReadDetailsViewController alloc] init];
    readDetailsViewController.dataSource = type == MLBReadTypeEssay ? readIndex.essay : (type == MLBReadTypeSerial ? readIndex.serial : readIndex.question);
    [self.navigationController pushViewController:readDetailsViewController animated:YES];
}

#pragma mark - Network Request

- (void)requestCarousel {
    [MLBHTTPRequester requestReadCarouselWithSuccess:^(id responseObject) {
        if ([responseObject[@"res"] integerValue] == 0) {
            NSError *error;
            NSArray *carouselArray = [MTLJSONAdapter modelsOfClass:[MLBReadCarouselItem class] fromJSONArray:responseObject[@"data"] error:&error];
            if (!error) {
                carousels = carouselArray.copy;
                [self setupCarouselViewDataSource];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [NSKeyedArchiver archiveRootObject:carousels toFile:MLBCacheReadCarouselFilePath];
                });
            } else {
                [self modelTransformFailedWithError:error];
            }
        } else {
            [self showHUDErrorWithText:responseObject[@"msg"]];
        }
    } fail:^(NSError *error) {
        [self showHUDServerError];
    }];
}

- (void)requestIndex {
    [MLBHTTPRequester requestReadIndexWithSuccess:^(id responseObject) {
        if ([responseObject[@"res"] integerValue] == 0) {
            NSError *error;
            readIndex = [MTLJSONAdapter modelOfClass:[MLBReadIndex class] fromJSONDictionary:responseObject[@"data"] error:&error];
            if (!error) {
                _pagingScrollView.hidden = NO;
                [_pagingScrollView reloadData];
                // 防止加载出来前用户滑动而跳转到了最后一个
                [_pagingScrollView setCurrentPageIndex:0];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [NSKeyedArchiver archiveRootObject:readIndex toFile:MLBCacheReadIndexFilePath];
                });
            } else {
                [self modelTransformFailedWithError:error];
            }
        } else {
            [self showHUDErrorWithText:responseObject[@"msg"]];
        }
    } fail:^(NSError *error) {
        [self showHUDServerError];
    }];
}

#pragma mark - GMCPagingScrollViewDataSource

- (NSUInteger)numberOfPagesInPagingScrollView:(GMCPagingScrollView *)pagingScrollView {
    return [self numberOfMaxIndex];
}

- (UIView *)pagingScrollView:(GMCPagingScrollView *)pagingScrollView pageForIndex:(NSUInteger)index {
    MLBReadBaseView *view = [pagingScrollView dequeueReusablePageWithIdentifier:kMLBReadBaseViewID];
    [view configureViewWithReadEssay:readIndex.essay[index] readSerial:readIndex.serial[index] readQuestion:readIndex.question[index] atIndex:index inViewController:self];
    __weak typeof(self) weakSelf = self;
    view.readSelected = ^(MLBReadType type) {
        [weakSelf openReadDetailsViewControllerWithReadType:type];
    };
    
    return view;
}

#pragma mark - GMCPagingScrollViewDelegate

- (void)pagingScrollViewDidScroll:(GMCPagingScrollView *)pagingScrollView {
    if (_pagingScrollView.isDragging) {
        CGPoint contentOffset = pagingScrollView.scrollView.contentOffset;
        pagingScrollView.scrollView.contentOffset = CGPointMake(contentOffset.x, 0);
    }
}

@end
