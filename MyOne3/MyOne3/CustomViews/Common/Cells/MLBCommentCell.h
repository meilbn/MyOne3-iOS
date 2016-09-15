//
//  MLBCommentCell.h
//  MyOne3
//
//  Created by meilbn on 2/23/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

typedef NS_ENUM(NSUInteger, MLBCommentCellButtonType) {
	MLBCommentCellButtonTypeUserAvatar, // 点击头像
	MLBCommentCellButtonTypePraise,		// 点赞
	MLBCommentCellButtonTypeUnfold,		// 展开
};

FOUNDATION_EXPORT NSString *const kMLBCommentCellID;

@class MLBMovieStory;
@class MLBMovieReview;
@class MLBComment;

@interface MLBCommentCell : MLBBaseCell

@property (nonatomic, assign, getter=isLastHotComment) BOOL lastHotComment;

@property (nonatomic, copy) void (^cellButtonClicked)(MLBCommentCellButtonType type, NSIndexPath *indexPath);

- (void)configureCellForMovieWithStory:(MLBMovieStory *)story atIndexPath:(NSIndexPath *)indexPath;

- (void)configureCellForMovieWithReview:(MLBMovieReview *)review atIndexPath:(NSIndexPath *)indexPath;

- (void)configureCellForCommonWithComment:(MLBComment *)comment atIndexPath:(NSIndexPath *)indexPath;

@end
