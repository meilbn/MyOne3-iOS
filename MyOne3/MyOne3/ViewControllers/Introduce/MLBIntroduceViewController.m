//
//  MLBIntroduceViewController.m
//  MyOne3
//
//  Created by meilbn on 2/24/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBIntroduceViewController.h"
#import <YYImage/YYImage.h>
#import "AppDelegate.h"

@interface MLBIntroduceViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIButton *entryButton;
@property (strong, nonatomic) YYAnimatedImageView *yyImageView0;
@property (strong, nonatomic) YYAnimatedImageView *yyImageView1;
@property (strong, nonatomic) YYAnimatedImageView *yyImageView2;
@property (strong, nonatomic) YYAnimatedImageView *yyImageView3;

@end

@implementation MLBIntroduceViewController {
    NSArray *gifNames;
    NSInteger currentIndex;
    NSInteger lastIndex;
    NSArray *yyImageViews;
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
    
    [self initDatas];
    [self setupViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self playCurrentAnimation];
}

#pragma mark - Private Method

- (void)initDatas {
    gifNames = @[@"1.gif", @"2.gif", @"3.gif", @"4.gif"];
    currentIndex = 0;
    lastIndex = 0;
}

- (void)setupViews {
    _scrollView = ({
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.backgroundColor = MLBViewControllerBGColor;
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * gifNames.count, 0);
        scrollView.delegate = self;
        [self.view addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        scrollView;
    });
    
    _yyImageView0 = [YYAnimatedImageView new];
    _yyImageView1 = [YYAnimatedImageView new];
    _yyImageView2 = [YYAnimatedImageView new];
    _yyImageView3 = [YYAnimatedImageView new];
    yyImageViews = @[_yyImageView0, _yyImageView1, _yyImageView2, _yyImageView3];
    
    for (NSInteger i = 0; i < gifNames.count; i++) {
        YYAnimatedImageView *imageView = yyImageViews[i];
        imageView.autoPlayAnimatedImage = NO;
        imageView.frame = CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:imageView];
    }
    
    _pageControl = ({
        UIPageControl *pageControl = [UIPageControl new];
        pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"6D7B90" andAlpha:0.78];
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithRGBHex:0x6D7B90];
        pageControl.numberOfPages = gifNames.count;
        [pageControl addTarget:self action:@selector(pageControlDidChanged) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:pageControl];
        [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-100);
        }];
        
        pageControl;
    });
    
    _entryButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"skip"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(entry) forControlEvents:UIControlEventTouchUpInside];
        button.alpha = 0;
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(134, 46));
            make.center.equalTo(_pageControl);
        }];
        
        button;
    });
}

- (void)playCurrentAnimation {
    if (lastIndex != currentIndex) {
        YYAnimatedImageView *lastImageView = yyImageViews[lastIndex];
        if (lastImageView.currentIsPlayingAnimation) {
            [lastImageView stopAnimating];
            lastImageView.image = nil;
        }
    }
    
    YYAnimatedImageView *currentImageView = yyImageViews[currentIndex];
    if (!currentImageView.currentIsPlayingAnimation) {
        currentImageView.image = [YYImage imageNamed:gifNames[currentIndex]];
        [currentImageView startAnimating];
    }
}

- (void)scrollViewCurrentPageDidChangedTo:(NSInteger)pageIndex {
    currentIndex = pageIndex;
    if (currentIndex == gifNames.count - 1) {
        _pageControl.alpha = 0;
        _entryButton.alpha = 1;
    } else {
        _pageControl.alpha = 1;
        _entryButton.alpha = 0;
    }
    
    [self playCurrentAnimation];
    lastIndex = currentIndex;
}

#pragma mark - Action

- (void)pageControlDidChanged {
    [_scrollView setContentOffset:CGPointMake(_pageControl.currentPage * SCREEN_WIDTH, 0) animated:YES];
}

- (void)entry {
    NSString *version = [MLBUtilities appCurrentVersion];
    NSString *build = [MLBUtilities appCurrentBuild];
    NSString *versionAndBuild = [NSString stringWithFormat:@"%@_%@", version, build];
    [UserDefaults setObject:versionAndBuild forKey:MLBLastShowIntroduceVersionAndBuild];
    [(AppDelegate *)[UIApplication sharedApplication].delegate showMainTabBarControllers];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint contentOffset = scrollView.contentOffset;
    NSInteger currentPage = contentOffset.x / SCREEN_WIDTH;
    BOOL hasGreatThanHalfScreen = contentOffset.x > (currentPage + 0.5) * SCREEN_WIDTH;
    _pageControl.currentPage = currentPage + (hasGreatThanHalfScreen ? 1 : 0);
    
    NSInteger leftLimit = (gifNames.count - 2 + 0.5) * SCREEN_WIDTH;
    NSInteger rightLimit = (gifNames.count - 1) * SCREEN_WIDTH;
    if (contentOffset.x >= leftLimit && contentOffset.x <= rightLimit) {
        CGFloat buttonAlpha = (contentOffset.x - leftLimit) / (SCREEN_WIDTH / 2);
        _entryButton.alpha = buttonAlpha;
        _pageControl.alpha = 1 - buttonAlpha;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewCurrentPageDidChangedTo:scrollView.contentOffset.x / SCREEN_WIDTH];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewCurrentPageDidChangedTo:scrollView.contentOffset.x / SCREEN_WIDTH];
}

@end
