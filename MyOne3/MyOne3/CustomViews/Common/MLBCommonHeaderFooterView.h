//
//  MLBCommonHeaderFooterView.h
//  MyOne3
//
//  Created by meilbn on 9/14/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MLBCommonHeaderFooterViewType) {
	MLBCommonHeaderFooterViewTypeNone, // 无
	
	// header
	MLBCommonHeaderFooterViewTypeComment, // 评论列表
	MLBCommonHeaderFooterViewTypeRelatedRec, // 相关推荐
	MLBCommonHeaderFooterViewTypeRelatedMusic, // 相似歌曲
	MLBCommonHeaderFooterViewTypeMovieStory, // 电影故事
	MLBCommonHeaderFooterViewTypeMovieReview, // 评审团短评
	MLBCommonHeaderFooterViewTypeMovieComment, // 电影评论
	MLBCommonHeaderFooterViewTypeScoreRatio, // 分数比例
	
	// footer
	MLBCommonHeaderFooterViewTypeAboveIsHotComments, // 以上是热门评论
};

FOUNDATION_EXTERN NSString *const kMLBCommonHeaderFooterViewIDForTypeHeader;

@interface MLBCommonHeaderFooterView : UITableViewHeaderFooterView

+ (CGFloat)viewHeight;

@property (nonatomic, assign) MLBCommonHeaderFooterViewType viewType;

@end
