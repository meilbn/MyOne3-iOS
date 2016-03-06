//
//  MLBCommentListViewController.h
//  MyOne3
//
//  Created by meilbn on 3/6/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLBCommonHeaderView.h"
#import "MLBCommonFooterView.h"

typedef NS_ENUM(NSUInteger, MLBCommentListType) {
    MLBCommentListTypeNone,
    MLBCommentListTypeReadComments,
    MLBCommentListTypeMusicComments,
    MLBCommentListTypeMovieStories,
    MLBCommentListTypeMovieReviews,
    MLBCommentListTypeMovieComments,
};

@interface MLBCommentListViewController : UITableViewController

@property (nonatomic, copy) void (^finishedCalculateHeight)(CGFloat height);

- (instancetype)initWithCommentListType:(MLBCommentListType)commentListType;

- (instancetype)initWithCommentListType:(MLBCommentListType)commentListType headerViewType:(MLBHeaderViewType)headerViewType footerViewType:(MLBFooterViewType)footerViewType;

- (void)configureViewForReadDetailsWithReadType:(MLBReadType)readType itemId:(NSString *)itemId;

- (void)configureViewForMusicDetailsWithItemId:(NSString *)itemId;

- (void)configureViewForMovieDetailsWithItemId:(NSString *)itemId;

- (void)requestDatas;

//- (CGFloat)viewHeightWithDataSource:(NSArray *)dataSource;

@end
