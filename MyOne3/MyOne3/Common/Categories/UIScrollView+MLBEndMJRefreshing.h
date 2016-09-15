//
//  UIScrollView+MLBEndMJRefreshing.h
//  MyOne3
//
//  Created by meilbn on 9/9/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (MLBEndMJRefreshing)

/**
 *  添加下拉和上拉刷新
 *
 *  @param target              target
 *  @param refreshingAction    下拉刷新方法
 *  @param loadMoreDatasAction 上拉刷新方法
 */
- (void)mlb_addRefreshingWithTarget:(id)target refreshingAction:(SEL)refreshingAction loadMoreDatasAction:(SEL)loadMoreDatasAction;

/**
 *  结束刷新
 *
 *  @param hasMoreData 是否有更多数据
 */
- (void)mlb_endRefreshingHasMoreData:(BOOL)hasMoreData;

@end
