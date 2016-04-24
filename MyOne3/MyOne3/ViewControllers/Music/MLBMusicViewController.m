//
//  MLBMusicViewController.m
//  MyOne3
//
//  Created by meilbn on 2/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBMusicViewController.h"
#import "MLBMusicView.h"
#import "MLBPreviousViewController.h"

@interface MLBMusicViewController () <GMCPagingScrollViewDataSource, GMCPagingScrollViewDelegate> {
    AAPullToRefresh *pullToRefreshLeft;
    AAPullToRefresh *pullToRefreshRight;
}

@property (strong, nonatomic) GMCPagingScrollView *pagingScrollView;

@end

@implementation MLBMusicViewController {
    NSArray *dataSource;
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
    self.title = MLBMusicTitle;
    [self addNavigationBarLeftSearchItem];
    [self addNavigationBarRightMeItem];
    
    [self initDatas];
    [self setupViews];
    [self requestMusicIdList];
}

#pragma mark - Private Method

- (void)initDatas {
    
}

- (void)setupViews {
    __weak typeof(self) weakSelf = self;
    
    _pagingScrollView = ({
        GMCPagingScrollView *pagingScrollView = [GMCPagingScrollView new];
        pagingScrollView.backgroundColor = MLBViewControllerBGColor;
        [pagingScrollView registerClass:[MLBMusicView class] forReuseIdentifier:kMLBMusicViewID];
        pagingScrollView.dataSource = self;
        pagingScrollView.delegate = self;
        pagingScrollView.pageInsets = UIEdgeInsetsZero;
        pagingScrollView.interpageSpacing = 0;
        pullToRefreshLeft = [pagingScrollView.scrollView addPullToRefreshPosition:AAPullToRefreshPositionLeft actionHandler:^(AAPullToRefresh *v) {
            [weakSelf refreshHomeMore];
            [v performSelector:@selector(stopIndicatorAnimation) withObject:nil afterDelay:1];
        }];
        pullToRefreshLeft.threshold = 100;
        pullToRefreshLeft.borderColor = MLBAppThemeColor;
        pullToRefreshLeft.borderWidth = MLBPullToRefreshBorderWidth;
        pullToRefreshLeft.imageIcon = [UIImage new];
        
        pullToRefreshRight = [pagingScrollView.scrollView addPullToRefreshPosition:AAPullToRefreshPositionRight actionHandler:^(AAPullToRefresh *v) {
            [weakSelf showPreviousList];
            [v performSelector:@selector(stopIndicatorAnimation) withObject:nil afterDelay:1];
        }];
        pullToRefreshRight.borderColor = MLBAppThemeColor;
        pullToRefreshRight.borderWidth = MLBPullToRefreshBorderWidth;
        pullToRefreshRight.imageIcon = [UIImage new];
        
        [self.view addSubview:pagingScrollView];
        [pagingScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        pagingScrollView.hidden = YES;
        
        pagingScrollView;
    });
}

#pragma mark - Action

- (void)refreshHomeMore {
    // 很奇怪，不写这行代码的话，_pagingScrollView 里面的 scrollview 的 contentOffset.x 会变成和释放刷新时 contentOffset.x 的绝对值差不多，导致第一个 item 看起来像是左移了，论脑洞的重要性
    [_pagingScrollView setCurrentPageIndex:0 reloadData:NO];
}

- (void)showPreviousList {
    // 原因同上
    [_pagingScrollView setCurrentPageIndex:(dataSource.count - 1) reloadData:NO];
    // 显示往期列表
    MLBPreviousViewController *previousViewController = [[MLBPreviousViewController alloc] init];
    previousViewController.previousType = MLBPreviousTypeMusic;
    [self.navigationController pushViewController:previousViewController animated:YES];
}

#pragma mark - Network Request

- (void)requestMusicIdList {
    [MLBHTTPRequester requestMusicIdListWithSuccess:^(id responseObject) {
        if ([responseObject[@"res"] integerValue] == 0) {
            dataSource = responseObject[@"data"];
            if (dataSource) {
                if (dataSource.count > 0) {
                    _pagingScrollView.hidden = NO;
                    [_pagingScrollView reloadData];
                    // 防止加载出来前用户滑动而跳转到了最后一个
                    [_pagingScrollView setCurrentPageIndex:0];
                }
            } else {
                [self showHUDErrorWithText:@"获取数据失败"];
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
    return dataSource.count;
}

- (UIView *)pagingScrollView:(GMCPagingScrollView *)pagingScrollView pageForIndex:(NSUInteger)index {
    MLBMusicView *view = [pagingScrollView dequeueReusablePageWithIdentifier:kMLBMusicViewID];
    [view prepareForReuse];
    if (index == 0) {
        [view configureViewWithMusicId:dataSource[index] atIndex:index inViewController:self];
    }
    
    return view;
}

#pragma mark - GMCPagingScrollViewDelegate

- (void)pagingScrollViewDidScroll:(GMCPagingScrollView *)pagingScrollView {
    if (_pagingScrollView.isDragging) {
        CGPoint contentOffset = pagingScrollView.scrollView.contentOffset;
        pagingScrollView.scrollView.contentOffset = CGPointMake(contentOffset.x, 0);
    }
}

- (void)pagingScrollView:(GMCPagingScrollView *)pagingScrollView didScrollToPageAtIndex:(NSUInteger)index {
    if (index != 0 && (!pagingScrollView.scrollView.isTracking || !pagingScrollView.scrollView.isDecelerating)) {
        MLBMusicView *view = [pagingScrollView pageAtIndex:index];
        [view configureViewWithMusicId:dataSource[index] atIndex:index inViewController:self];
    }
}

@end
