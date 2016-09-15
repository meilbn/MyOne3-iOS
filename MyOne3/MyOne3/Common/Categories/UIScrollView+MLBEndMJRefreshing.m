//
//  UIScrollView+MLBEndMJRefreshing.m
//  MyOne3
//
//  Created by meilbn on 9/9/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "UIScrollView+MLBEndMJRefreshing.h"
#import <MJRefresh/MJRefresh.h>

@implementation UIScrollView (MLBEndMJRefreshing)

/**
 *  添加下拉和上拉刷新
 *
 *  @param target              target
 *  @param refreshingAction    下拉刷新方法
 *  @param loadMoreDatasAction 上拉刷新方法
 */
- (void)mlb_addRefreshingWithTarget:(id)target refreshingAction:(SEL)refreshingAction loadMoreDatasAction:(SEL)loadMoreDatasAction {
	if (!target) {
		return;
	}
	
	if (refreshingAction) {
		MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:refreshingAction];
		self.mj_header = header;
	}
	
	if (loadMoreDatasAction) {
		MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:loadMoreDatasAction];
		self.mj_footer = footer;
	}
}

/**
 *  结束刷新
 *
 *  @param hasMoreData 是否有更多数据
 */
- (void)mlb_endRefreshingHasMoreData:(BOOL)hasMoreData {
	if (self.mj_header && self.mj_header.isRefreshing) {
		[self.mj_header endRefreshing];
		[self.mj_footer resetNoMoreData];
	}
	
	if (hasMoreData) {
		[self.mj_footer endRefreshing];
	} else {
		[self.mj_footer endRefreshingWithNoMoreData];
	}
}

@end
