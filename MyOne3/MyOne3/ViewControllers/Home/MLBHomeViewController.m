//
//  MLBHomeViewController.m
//  MyOne3
//
//  Created by meilbn on 2/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBHomeViewController.h"
#import "MLBHomeItem.h"
#import "MLBHomeView.h"
#import <CoreLocation/CoreLocation.h>
#import "MLBPreviousViewController.h"

@interface MLBHomeViewController () <GMCPagingScrollViewDataSource, GMCPagingScrollViewDelegate, CLLocationManagerDelegate> {
    AAPullToRefresh *pullToRefreshLeft;
    AAPullToRefresh *pullToRefreshRight;
}

@property (strong, nonatomic) GMCPagingScrollView *pagingScrollView;
@property (strong, nonatomic) UIButton *diaryButton;
@property (strong, nonatomic) UIButton *likeButton;
@property (strong, nonatomic) UILabel *likeNumLabel;
@property (strong, nonatomic) UIButton *moreButton;

@property (strong, nonatomic) NSArray *dataSource;

//@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation MLBHomeViewController

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
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_home_title"]];
    self.navigationItem.titleView = titleView;
    
    [self addNavigationBarLeftSearchItem];
    [self addNavigationBarRightMeItem];
    
    [self initDatas];
    [self setupViews];
    [self loadCache];
    [self requestHomeMore];
//    [_locationManager startUpdatingLocation];
}

#pragma mark - Private Method

- (void)initDatas {
//    _locationManager = [[CLLocationManager alloc] init];
//    _locationManager.delegate = self;
//    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    _locationManager.distanceFilter = 500;
//    if (IS_IOS8_LATER) {
//        [_locationManager requestWhenInUseAuthorization];
//    }
}

- (void)setupViews {
    __weak typeof(self) weakSelf = self;
    
    _pagingScrollView = ({
        GMCPagingScrollView *pagingScrollView = [GMCPagingScrollView new];
        pagingScrollView.backgroundColor = MLBViewControllerBGColor;
        [pagingScrollView registerClass:[MLBHomeView class] forReuseIdentifier:kMLBHomeViewID];
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
    
    _diaryButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"diary_normal" highlightImageName:nil target:self action:@selector(diaryButtonClicked)];
        [_pagingScrollView insertSubview:button atIndex:0];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(66, 44));
            make.left.equalTo(_pagingScrollView).offset(8);
            make.bottom.equalTo(_pagingScrollView).offset(-73);
        }];
        
        button;
    });
    
    _moreButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"share_image" highlightImageName:nil target:self action:@selector(moreButtonClicked)];
        [_pagingScrollView insertSubview:button atIndex:1];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.right.equalTo(_pagingScrollView).offset(-8);
            make.bottom.equalTo(_diaryButton);
        }];
        
        button;
    });
    
    _likeNumLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = MLBDarkGrayTextColor;
        label.font = FontWithSize(11);
        [_pagingScrollView insertSubview:label atIndex:2];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.right.equalTo(_moreButton.mas_left);
            make.bottom.equalTo(_diaryButton);
        }];
        
        label;
    });
    
    _likeButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"like_normal" selectedImageName:@"like_selected" target:self action:@selector(likeButtonClicked)];
        [_pagingScrollView insertSubview:button atIndex:3];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.right.equalTo(_likeNumLabel.mas_left);
            make.bottom.equalTo(_diaryButton);
        }];
        
        button;
    });
}

- (void)loadCache {
    id cacheItems = [NSKeyedUnarchiver unarchiveObjectWithFile:MLBCacheHomeItemFilePath];
    if (cacheItems) {
        self.dataSource = cacheItems;
    }
}

#pragma mark - Private Method

- (MLBHomeItem *)homeItemAtIndex:(NSInteger)index {
    return _dataSource[index];
}

- (void)updateLikeNumLabelTextWithItemIndex:(NSInteger)index {
    _likeNumLabel.text = [@([self homeItemAtIndex:index].praiseNum) stringValue];
}

#pragma mark - Setter

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    _pagingScrollView.hidden = NO;
    [_pagingScrollView reloadData];
    // 防止加载出来前用户滑动而跳转到了最后一个
    [_pagingScrollView setCurrentPageIndex:0];
    if (dataSource.count > 0) {
        [self updateLikeNumLabelTextWithItemIndex:0];
    }
}

#pragma mark - Action

- (void)refreshHomeMore {
    // 很奇怪，不写这行代码的话，_pagingScrollView 里面的 scrollview 的 contentOffset.x 会变成和释放刷新时 contentOffset.x 的绝对值差不多，导致第一个 item 看起来像是左移了，论脑洞的重要性
    [_pagingScrollView setCurrentPageIndex:0 reloadData:NO];
    // 刷新
    [self requestHomeMore];
}

- (void)showPreviousList {
    // 原因同上
    [_pagingScrollView setCurrentPageIndex:(_dataSource.count - 1) reloadData:NO];
    // 显示往期列表
    MLBPreviousViewController *previousViewController = [[MLBPreviousViewController alloc] init];
    previousViewController.previousType = MLBPreviousTypeHome;
    [self.navigationController pushViewController:previousViewController animated:YES];
}

- (void)diaryButtonClicked {
    [self presentLoginOptsViewController];
}

- (void)likeButtonClicked {
    
}

- (void)moreButtonClicked {
    [self showPopMenuViewWithMenuSelectedBlock:^(MLBPopMenuType menuType) {
        DDLogDebug(@"menuType = %ld", menuType);
    }];
}

#pragma mark - Network Request

- (void)requestHomeMore {
    [MLBHTTPRequester requestHomeMoreWithSuccess:^(id responseObject) {
        if ([responseObject[@"res"] integerValue] == 0) {
            NSError *error;
            NSArray *items = [MTLJSONAdapter modelsOfClass:[MLBHomeItem class] fromJSONArray:responseObject[@"data"] error:&error];
            if (!error) {
                self.dataSource = items;
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [NSKeyedArchiver archiveRootObject:_dataSource toFile:MLBCacheHomeItemFilePath];
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
    return _dataSource.count;
}

- (UIView *)pagingScrollView:(GMCPagingScrollView *)pagingScrollView pageForIndex:(NSUInteger)index {
    MLBHomeView *view = [pagingScrollView dequeueReusablePageWithIdentifier:kMLBHomeViewID];
    [view configureViewWithHomeItem:[self homeItemAtIndex:index] atIndex:index inViewController:self];
    
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
    [self updateLikeNumLabelTextWithItemIndex:index];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    DDLogDebug(@"locations = %@", locations);
//    [_locationManager stopUpdatingLocation];
}

@end
