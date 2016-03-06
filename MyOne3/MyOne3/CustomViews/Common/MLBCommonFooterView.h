//
//  MLBCommonFooterView.h
//  MyOne3
//
//  Created by meilbn on 2/26/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MLBFooterViewType) {
    MLBFooterViewTypeNone,// 无
    MLBFooterViewTypeComment,// 评论
    MLBFooterViewTypeMovieStory,// 电影故事
    MLBFooterViewTypeMovieReview,// 评审团短评
    MLBFooterViewTypeShadow,// 纯阴影
};

@interface MLBCommonFooterView : UIView

@property (nonatomic, copy) void (^showAllItems)();

+ (CGFloat)footerViewHeight;

+ (CGFloat)footerViewHeightForShadow;

- (instancetype)initWithFooterViewType:(MLBFooterViewType)type;

- (void)configureViewWithCount:(NSInteger)count;

@end
