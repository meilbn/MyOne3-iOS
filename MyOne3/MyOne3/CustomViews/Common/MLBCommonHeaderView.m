//
//  MLBCommonHeaderView.m
//  MyOne3
//
//  Created by meilbn on 2/26/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBCommonHeaderView.h"

@interface MLBCommonHeaderView ()

@property (strong, nonatomic) UILabel *commentsCountLabel;
@property (strong, nonatomic) UIButton *rightButton;

@end

@implementation MLBCommonHeaderView {
    MLBHeaderViewType viewType;
}

+ (CGFloat)headerViewHeight {
    return 40;
}

#pragma mark - LifeCycle

- (instancetype)initWithHeaderViewType:(MLBHeaderViewType)type {
    self = [super init];
    
    if (self) {
        viewType = type;
        [self setupViews];
    }
    
    return self;
}

#pragma mark - Private Method

- (void)setupViews {
    if (viewType == MLBHeaderViewTypeNone || _commentsCountLabel) {
        return;
    }
    
    self.backgroundColor = MLBColorF5F5F5;
    self.clipsToBounds = YES;
    
    NSString *leftText;
    NSString *rightButtonImageNamePrefix;
    switch (viewType) {
        case MLBHeaderViewTypeNone:
            break;
        case MLBHeaderViewTypeComment: {
            leftText = @"评论列表";
//            rightButtonImageNamePrefix = @"review";
            break;
        }
        case MLBHeaderViewTypeRelatedRec: {
            leftText = @"相关推荐";
            break;
        }
        case MLBHeaderViewTypeRelatedMusic: {
            leftText = @"相似歌曲";
            rightButtonImageNamePrefix = @"music_list_play";
            break;
        }
        case MLBHeaderViewTypeMovieStory: {
            leftText = @"电影故事";
            rightButtonImageNamePrefix = @"unofficial_plot";
            break;
        }
        case MLBHeaderViewTypeMovieReview: {
            leftText = @"评审团短评";
            break;
        }
        case MLBHeaderViewTypeMovieComment: {
            leftText = @"评论列表";
            rightButtonImageNamePrefix = @"moviereview";
            break;
        }
        case MLBHeaderViewTypeScoreRatio: {
            leftText = @"分数比例";
            break;
        }
    }
    
    _commentsCountLabel = [MLBUIFactory labelWithTextColor:MLBColor7F7F7F font:FontWithSize(12)];
    _commentsCountLabel.backgroundColor = MLBColorF5F5F5;
	_commentsCountLabel.text = leftText;
    [self addSubview:_commentsCountLabel];
    [_commentsCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self);
		make.left.equalTo(self).offset(12);
    }];
	
	if (IsStringNotEmpty(rightButtonImageNamePrefix)) {
		_rightButton = [MLBUIFactory buttonWithImageName:rightButtonImageNamePrefix ? [NSString stringWithFormat:@"%@_normal", rightButtonImageNamePrefix] : nil
									  highlightImageName:rightButtonImageNamePrefix ? [NSString stringWithFormat:@"%@_highlighted", rightButtonImageNamePrefix] : nil
												  target:self
												  action:@selector(rightButtonClicked)];
		[self addSubview:_rightButton];
		[_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.height.equalTo(@40);
			make.centerY.equalTo(self);
			make.right.equalTo(self).offset(-8);
		}];
	}
}

#pragma mark - Action

- (void)rightButtonClicked {
    DDLogDebug(@"common header view %@", NSStringFromSelector(_cmd));
}

@end
