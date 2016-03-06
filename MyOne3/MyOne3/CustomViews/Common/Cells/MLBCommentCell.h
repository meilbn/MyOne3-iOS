//
//  MLBCommentCell.h
//  MyOne3
//
//  Created by meilbn on 2/23/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

FOUNDATION_EXPORT NSString *const kMLBCommentCellID;

@class MLBMovieStory;
@class MLBMovieReview;
@class MLBComment;

@interface MLBCommentCell : MLBBaseCell

- (void)configureCellForMovieWithStory:(MLBMovieStory *)story atIndexPath:(NSIndexPath *)indexPath;

- (void)configureCellForMovieWithReview:(MLBMovieReview *)review atIndexPath:(NSIndexPath *)indexPath;

- (void)configureCellForCommonWithComment:(MLBComment *)comment atIndexPath:(NSIndexPath *)indexPath;

@end
