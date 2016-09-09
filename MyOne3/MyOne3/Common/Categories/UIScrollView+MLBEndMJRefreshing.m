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
