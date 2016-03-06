//
//  MLBUIFactory.m
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBUIFactory.h"
#import <MJRefresh/MJRefresh.h>

@implementation MLBUIFactory

#pragma mark - UIView

+ (UIView *)separatorLine {
    UIView *view = [UIView new];
    view.backgroundColor = MLBSeparatorColor;
    
    return view;
}

#pragma mark - UIBUtton

+ (UIButton *)buttonWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (IsStringNotEmpty(imageName)) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (IsStringNotEmpty(highlightImageName)) {
        [button setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    }
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UIButton *)buttonWithImageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName target:(id)target action:(SEL)action {
    UIButton *button = [MLBUIFactory buttonWithImageName:imageName highlightImageName:nil target:target action:action];
    if (IsStringNotEmpty(selectedImageName)) {
        [button setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    }
    
    return button;
}

+ (UIButton *)buttonWithBackgroundImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (IsStringNotEmpty(imageName)) {
        [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (IsStringNotEmpty(highlightImageName)) {
        [button setBackgroundImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    }
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(NSInteger)fontSize target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    
    button.titleLabel.font = FontWithSize(fontSize);
    
    return button;
}

#pragma mark - MJRefresh

+ (void)addMJRefreshTo:(UIScrollView *)scrollView target:(id)target refreshAction:(SEL)refreshAction loadMoreAction:(SEL)loadMoreAction {
    if (refreshAction != nil) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:refreshAction];
        [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
        [header setTitle:@"松开立即刷新数据" forState:MJRefreshStatePulling];
        [header setTitle:@"正在刷新中..." forState:MJRefreshStateRefreshing];
        header.lastUpdatedTimeLabel.hidden = YES;
        scrollView.mj_header = header;
    }
    
    if (loadMoreAction != nil) {
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:loadMoreAction];
        [footer setTitle:@"上拉可以加载更多" forState:MJRefreshStateIdle];
        [footer setTitle:@"松开立即加载更多" forState:MJRefreshStatePulling];
        [footer setTitle:@"正在加载更多的数据..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"没有更多啦" forState:MJRefreshStateNoMoreData];
        scrollView.mj_footer = footer;
    }
}

+ (void)myOne_addMJRefreshTo:(UIScrollView *)scrollView target:(id)target refreshAction:(SEL)refreshAction loadMoreAction:(SEL)loadMoreAction {
    if (refreshAction != nil) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:refreshAction];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        scrollView.mj_header = header;
    }
    
    if (loadMoreAction != nil) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:loadMoreAction];
        [footer setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
//        [footer setTitle:@"松开立即加载更多" forState:MJRefreshStatePulling];
        [footer setTitle:@"正在加载更多的数据..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"没有更多啦" forState:MJRefreshStateNoMoreData];
        scrollView.mj_footer = footer;
    }
}

@end
