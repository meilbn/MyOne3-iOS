//
//  MLBReadViewController.m
//  MyOne3
//
//  Created by meilbn on 2/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "MLBReadingCarouselItem.h"
#import "MLBReadingIndex.h"
#import "MLBReadingBaseView.h"

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
    MLBReadingIndex *readingIndex;
}

#pragma mark - Lifecycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = MLBReadTitle;
    
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
    [self addNavigationBarRightItems];
    
    if (!_carouselView) {
        _carouselView = ({
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView new];
            cycleScrollView.backgroundColor = [UIColor colorWithWhite:170 / 255.0 alpha:1];// #AAAAAA
            cycleScrollView.autoScrollTimeInterval = 5;
            [self.view addSubview:cycleScrollView];
            [cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(self.view);
                make.height.equalTo(@143.5);
            }];
            
            cycleScrollView;
        });
    }
    
    if (!_pagingScrollView) {
        __weak typeof(self) weakSelf = self;
        
        _pagingScrollView = ({
            GMCPagingScrollView *pagingScrollView = [GMCPagingScrollView new];
            pagingScrollView.backgroundColor = MLBViewControllerBGColor;
            [pagingScrollView registerClass:[MLBReadingBaseView class] forReuseIdentifier:kMLBReadingBaseViewID];
            pagingScrollView.dataSource = self;
            pagingScrollView.delegate = self;
            pagingScrollView.pageInsets = UIEdgeInsetsZero;
            pagingScrollView.interpageSpacing = 0;
            pullToRefreshLeft = [pagingScrollView.scrollView addPullToRefreshPosition:AAPullToRefreshPositionLeft ActionHandler:^(AAPullToRefresh *v) {
                [weakSelf refreshReadingIndex];
                [v performSelector:@selector(stopIndicatorAnimation) withObject:nil afterDelay:1];
            }];
            pullToRefreshLeft.threshold = 100;
            pullToRefreshLeft.borderColor = MLBAppThemeColor;
            pullToRefreshLeft.borderWidth = MLBPullToRefreshBorderWidth;
            pullToRefreshLeft.imageIcon = [UIImage new];
            
            pullToRefreshRight = [pagingScrollView.scrollView addPullToRefreshPosition:AAPullToRefreshPositionRight ActionHandler:^(AAPullToRefresh *v) {
                [weakSelf loadMoreReadingIndex];
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
}

- (void)loadCache {
    id cacheCarousels = [NSKeyedUnarchiver unarchiveObjectWithFile:MLBCacheReadingCarouselFilePath];
    if (cacheCarousels) {
        carousels = cacheCarousels;
        [self setupCarouselViewDataSource];
    }
    
    id cacheReadingIndex = [NSKeyedUnarchiver unarchiveObjectWithFile:MLBCacheReadingIndexFilePath];
    if (cacheReadingIndex) {
        readingIndex = cacheReadingIndex;
        _pagingScrollView.hidden = NO;
        [_pagingScrollView reloadData];
    }
}

- (void)setupCarouselViewDataSource {
    [carouselCovers removeAllObjects];
    
    for (MLBReadingCarouselItem *carousel in carousels) {
        [carouselCovers addObject:carousel.cover];
    }
    
    _carouselView.imageURLStringsGroup = carouselCovers;
}

- (NSInteger)numberOfMaxIndex {
    return MAX(MAX(readingIndex.essay.count, readingIndex.serial.count), readingIndex.question.count);
}

#pragma mark - Action

- (void)refreshReadingIndex {
    // 很奇怪，不写这行代码的话，_pagingScrollView 里面的 scrollview 的 contentOffset.x 会变成和释放刷新时 contentOffset.x 的绝对值差不多，导致第一个 item 看起来像是左移了，论脑洞的重要性
    [_pagingScrollView setCurrentPageIndex:0 reloadData:NO];
}

- (void)loadMoreReadingIndex {
    // 原因同上
    [_pagingScrollView setCurrentPageIndex:([self numberOfMaxIndex] - 1) reloadData:NO];
}

#pragma mark - Network Request

- (void)requestCarousel {
    [MLBHTTPRequester requestReadingCarouselWithSuccess:^(id responseObject) {
        if ([responseObject[@"res"] integerValue] == 0) {
            NSError *error;
            NSArray *carouselArray = [MTLJSONAdapter modelsOfClass:[MLBReadingCarouselItem class] fromJSONArray:responseObject[@"data"] error:&error];
            if (!error) {
                carousels = carouselArray.copy;
                [self setupCarouselViewDataSource];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [NSKeyedArchiver archiveRootObject:carousels toFile:MLBCacheReadingCarouselFilePath];
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
    [MLBHTTPRequester requestReadingIndexWithSuccess:^(id responseObject) {
        if ([responseObject[@"res"] integerValue] == 0) {
            NSError *error;
            readingIndex = [MTLJSONAdapter modelOfClass:[MLBReadingIndex class] fromJSONDictionary:responseObject[@"data"] error:&error];
            if (!error) {
                _pagingScrollView.hidden = NO;
                [_pagingScrollView reloadData];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [NSKeyedArchiver archiveRootObject:readingIndex toFile:MLBCacheReadingIndexFilePath];
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
    MLBReadingBaseView *view = [pagingScrollView dequeueReusablePageWithIdentifier:kMLBReadingBaseViewID];
    [view configureViewWithReadingEssay:readingIndex.essay[index] readingSerial:readingIndex.serial[index] readingQuestion:readingIndex.question[index] atIndex:index];
    
    return view;
}

#pragma mark - GMCPagingScrollViewDelegate

- (void)pagingScrollViewDidScroll:(GMCPagingScrollView *)pagingScrollView {
    if (_pagingScrollView.isDragging) {
        CGPoint contentOffset = pagingScrollView.scrollView.contentOffset;
//        DDLogDebug(@"contentOffset = %@", NSStringFromCGPoint(contentOffset));
        pagingScrollView.scrollView.contentOffset = CGPointMake(contentOffset.x, 0);
    }
}

@end
