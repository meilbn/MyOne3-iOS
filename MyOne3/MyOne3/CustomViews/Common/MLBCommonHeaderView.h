//
//  MLBCommonHeaderView.h
//  MyOne3
//
//  Created by meilbn on 2/26/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MLBHeaderViewType) {
    MLBHeaderViewTypeNone,// 无
    MLBHeaderViewTypeComment,// 评论列表
    MLBHeaderViewTypeRelatedRec,// 相关推荐
    MLBHeaderViewTypeRelatedMusic,// 相似歌曲
    MLBHeaderViewTypeMovieStory,// 电影故事
    MLBHeaderViewTypeMovieReview,// 评审团短评
    MLBHeaderViewTypeMovieComment,// 电影评论
    MLBHeaderViewTypeScoreRatio,// 分数比例
};

@interface MLBCommonHeaderView : UIView

+ (CGFloat)headerViewHeight;

- (instancetype)initWithHeaderViewType:(MLBHeaderViewType)type;

@end
