//
//  MLBReadDetailsViewController.m
//  MyOne3
//
//  Created by meilbn on 2/26/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadDetailsViewController.h"
#import "MLBReadEssay.h"
#import "MLBReadSerial.h"
#import "MLBReadQuestion.h"
#import "MLBReadDetailsView.h"

@interface MLBReadDetailsViewController () <GMCPagingScrollViewDataSource, GMCPagingScrollViewDelegate> {
    AAPullToRefresh *pullToRefreshLeft;
    AAPullToRefresh *pullToRefreshRight;
}

@property (strong, nonatomic) GMCPagingScrollView *pagingScrollView;

@end

@implementation MLBReadDetailsViewController {
    MLBReadType readType;
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
    
    MLBBaseModel *model = [_dataSource firstObject];
    if (model) {
        if ([model isKindOfClass:[MLBReadEssay class]]) {
            self.title = @"短篇";
            readType = MLBReadTypeEssay;
        } else if ([model isKindOfClass:[MLBReadSerial class]]) {
            self.title = @"连载";
            readType = MLBReadTypeSerial;
        } else if ([model isKindOfClass:[MLBReadQuestion class]]) {
            self.title = @"问题";
            readType = MLBReadTypeQuestion;
        } else {
            return;
        }
        
        [self initDatas];
        [self setupViews];
        [_pagingScrollView setCurrentPageIndex:0 reloadData:YES];
    }
}

#pragma mark - Private Method

- (void)initDatas {
    
}

- (void)setupViews {
    __weak typeof(self) weakSelf = self;
    
    _pagingScrollView = ({
        GMCPagingScrollView *pagingScrollView = [GMCPagingScrollView new];
        pagingScrollView.backgroundColor = MLBViewControllerBGColor;
        [pagingScrollView registerClass:[MLBReadDetailsView class] forReuseIdentifier:kMLBReadDetailsViewID];
        pagingScrollView.dataSource = self;
        pagingScrollView.delegate = self;
        pagingScrollView.pageInsets = UIEdgeInsetsZero;
        pagingScrollView.interpageSpacing = 0;
        pullToRefreshLeft = [pagingScrollView.scrollView addPullToRefreshPosition:AAPullToRefreshPositionLeft actionHandler:^(AAPullToRefresh *v) {
            [weakSelf refresh];
            [v performSelector:@selector(stopIndicatorAnimation) withObject:nil afterDelay:1];
        }];
        pullToRefreshLeft.threshold = 100;
        pullToRefreshLeft.borderColor = MLBAppThemeColor;
        pullToRefreshLeft.borderWidth = MLBPullToRefreshBorderWidth;
        pullToRefreshLeft.imageIcon = [UIImage new];
        
        pullToRefreshRight = [pagingScrollView.scrollView addPullToRefreshPosition:AAPullToRefreshPositionRight actionHandler:^(AAPullToRefresh *v) {
            [weakSelf loadMore];
            [v performSelector:@selector(stopIndicatorAnimation) withObject:nil afterDelay:1];
        }];
        pullToRefreshRight.borderColor = MLBAppThemeColor;
        pullToRefreshRight.borderWidth = MLBPullToRefreshBorderWidth;
        pullToRefreshRight.imageIcon = [UIImage new];
        
        [self.view addSubview:pagingScrollView];
        [pagingScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        pagingScrollView;
    });
}

#pragma mark - Action

- (void)refresh {
    // 很奇怪，不写这行代码的话，_pagingScrollView 里面的 scrollview 的 contentOffset.x 会变成和释放刷新时 contentOffset.x 的绝对值差不多，导致第一个 item 看起来像是左移了，论脑洞的重要性
    [_pagingScrollView setCurrentPageIndex:0 reloadData:NO];
}

- (void)loadMore {
    // 原因同上
    [_pagingScrollView setCurrentPageIndex:(_dataSource.count - 1) reloadData:NO];
}

#pragma mark - Network Request



#pragma mark - GMCPagingScrollViewDataSource

- (NSUInteger)numberOfPagesInPagingScrollView:(GMCPagingScrollView *)pagingScrollView {
    return _dataSource.count;
}

- (UIView *)pagingScrollView:(GMCPagingScrollView *)pagingScrollView pageForIndex:(NSUInteger)index {
    MLBReadDetailsView *view = [pagingScrollView dequeueReusablePageWithIdentifier:kMLBReadDetailsViewID];
    [view prepareForReuseWithViewType:readType];
    if (index == 0) {
        [view configureViewWithReadModel:_dataSource[index] type:readType atIndex:index inViewController:self];
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
        MLBReadDetailsView *view = [pagingScrollView pageAtIndex:index];
        [view configureViewWithReadModel:_dataSource[index] type:readType atIndex:index inViewController:self];
    }
}

@end
