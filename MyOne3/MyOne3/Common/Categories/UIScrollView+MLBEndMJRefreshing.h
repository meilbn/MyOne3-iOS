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
 *  结束刷新
 *
 *  @param hasMoreData 是否有更多数据
 */
- (void)mlb_endRefreshingHasMoreData:(BOOL)hasMoreData;

@end
