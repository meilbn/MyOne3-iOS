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
    return 44;
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
    
    self.backgroundColor = MLBViewControllerBGColor;
    self.clipsToBounds = YES;
    
    NSString *leftText;
    NSString *rightButtonImageNamePrefix;
    switch (viewType) {
        case MLBHeaderViewTypeNone:
            break;
        case MLBHeaderViewTypeComment: {
            leftText = @"评论列表";
            rightButtonImageNamePrefix = @"review";
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
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor colorWithRed:252 / 255.0 green:253 / 255.0 blue:254 / 255.0 alpha:1];// #FCFDFE
    bgView.layer.shadowColor = MLBShadowColor.CGColor;
    bgView.layer.shadowOffset = CGSizeZero;
    bgView.layer.shadowRadius = 2;
    bgView.layer.shadowOpacity = 0.1;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(3, 0, -3, 0));
    }];
    
    UIView *lineView = [MLBUIFactory separatorLine];
    lineView.backgroundColor = [UIColor colorWithWhite:198 / 255.0 alpha:0.5];// #80C6C6C6
    [bgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.top.right.equalTo(bgView);
    }];
    
    _commentsCountLabel = [UILabel new];
    _commentsCountLabel.text = leftText;
    _commentsCountLabel.textColor = [UIColor colorWithWhite:127 / 255.0 alpha:1];// #F7F7F7
    _commentsCountLabel.font = FontWithSize(12);
    [self addSubview:_commentsCountLabel];
    [_commentsCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 12, 0, 0));
    }];
    
    _rightButton = [MLBUIFactory buttonWithImageName:rightButtonImageNamePrefix ? [NSString stringWithFormat:@"%@_normal", rightButtonImageNamePrefix] : nil
                                  highlightImageName:rightButtonImageNamePrefix ? [NSString stringWithFormat:@"%@_highlighted", rightButtonImageNamePrefix] : nil
                                              target:self
                                              action:@selector(rightButtonClicked)];
    _rightButton.userInteractionEnabled = rightButtonImageNamePrefix;
    [self addSubview:_rightButton];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.right.equalTo(self).offset(-8);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - Action

- (void)rightButtonClicked {
    DDLogDebug(@"common header view %@", NSStringFromSelector(_cmd));
}

@end
