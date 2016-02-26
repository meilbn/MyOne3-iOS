//
//  MLBCommentsHeaderView.m
//  MyOne3
//
//  Created by meilbn on 2/26/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBCommentsHeaderView.h"

@interface MLBCommentsHeaderView ()

@property (strong, nonatomic) UILabel *commentsCountLabel;
@property (strong, nonatomic) UIButton *rightButton;

@end

@implementation MLBCommentsHeaderView

#pragma mark - LifeCycle

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

#pragma mark - Private Method

- (void)setupViews {
    if (_commentsCountLabel) {
        return;
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
    _commentsCountLabel.text = @"评论列表";
    _commentsCountLabel.textColor = [UIColor colorWithWhite:127 / 255.0 alpha:1];// #F7F7F7
    _commentsCountLabel.font = FontWithSize(12);
    [self addSubview:_commentsCountLabel];
    [_commentsCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 12, 0, 0));
    }];
    
    _rightButton = [MLBUIFactory buttonWithImageName:@"review_normal" highlightImageName:@"review_highlighted" target:self action:@selector(rightButtonClicked)];
    [self addSubview:_rightButton];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.right.equalTo(self).offset(-8);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - Action

- (void)rightButtonClicked {
    
}

@end
