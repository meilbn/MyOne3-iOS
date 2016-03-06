//
//  MLBCommonFooterView.m
//  MyOne3
//
//  Created by meilbn on 2/26/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBCommonFooterView.h"

@interface MLBCommonFooterView ()

@property (strong, nonatomic) UIView *shadowView;
@property (strong, nonatomic) UILabel *countLabel;
@property (strong, nonatomic) UIButton *allButton;

@end

@implementation MLBCommonFooterView {
    MLBFooterViewType viewType;
    NSString *leftFormatText;
    NSString *allButtonTitle;
}

+ (CGFloat)footerViewHeight {
    return 44;
}

+ (CGFloat)footerViewHeightForShadow {
    return 5;
}

#pragma mark - LifeCycle

- (instancetype)initWithFooterViewType:(MLBFooterViewType)type {
    self = [super init];
    
    if (self) {
        viewType = type;
        [self setupViews];
    }
    
    return self;
}

#pragma mark - Private Method

- (void)setupViews {
    if (viewType == MLBFooterViewTypeNone || _shadowView) {
        return;
    }
    
    self.backgroundColor = MLBViewControllerBGColor;
    self.clipsToBounds = YES;
    
    _shadowView = [UIView new];
    _shadowView.backgroundColor = [UIColor colorWithRed:252 / 255.0 green:253 / 255.0 blue:254 / 255.0 alpha:1];// #FCFDFE
    _shadowView.layer.shadowColor = MLBShadowColor.CGColor;
    _shadowView.layer.shadowOpacity = 0.3;
    _shadowView.layer.shadowRadius = 2;
    _shadowView.layer.shadowOffset = CGSizeZero;
    [self addSubview:_shadowView];
    
    UIView *lineView = [MLBUIFactory separatorLine];
    lineView.backgroundColor = [UIColor colorWithWhite:198 / 255.0 alpha:0.5];// #80C6C6C6
    [_shadowView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.bottom.right.equalTo(_shadowView);
    }];
    
    if (viewType == MLBFooterViewTypeShadow) {
        [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@2);
            make.left.top.right.equalTo(self).insets(UIEdgeInsetsMake(-1, 0, 0, 0));
        }];
        
        return;
    } else {
        [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(-3, 0, 3, 0));
        }];
    }
    
    switch (viewType) {
        case MLBFooterViewTypeNone:
            break;
        case MLBFooterViewTypeComment: {
            leftFormatText = @"共%ld条评论";
            allButtonTitle = @"全部评论";
            break;
        }
        case MLBFooterViewTypeMovieStory: {
            leftFormatText = @"共%ld个电影故事";
            allButtonTitle = @"全部电影故事";
            break;
        }
        case MLBFooterViewTypeMovieReview: {
            leftFormatText = @"共%ld条短评";
            allButtonTitle = @"全部短评";
            break;
        }
        case MLBFooterViewTypeShadow: {
            break;
        }
    }
    
    _countLabel = [UILabel new];
    _countLabel.textColor = MLBDarkGrayTextColor;
    _countLabel.font = FontWithSize(11);
    [self addSubview:_countLabel];
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self).insets(UIEdgeInsetsMake(0, 12, 0, 0));
    }];
    
    [self configureViewWithCount:0];
    
    _allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_allButton setTitle:allButtonTitle forState: UIControlStateNormal];
    [_allButton setTitleColor:MLBAppThemeColor forState:UIControlStateNormal];
    _allButton.titleLabel.font = FontWithSize(12);
    [_allButton addTarget:self action:@selector(allButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_allButton];
    [_allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(80, 40));
        make.centerY.equalTo(self);
        make.right.equalTo(self);
        make.left.greaterThanOrEqualTo(_countLabel.mas_right).offset(8);
    }];
}

#pragma mark - Action

- (void)allButtonClicked {
    if (_showAllItems) {
        _showAllItems();
    }
}

#pragma mark - Public Method

- (void)configureViewWithCount:(NSInteger)count {
    if (viewType > MLBFooterViewTypeNone && viewType < MLBFooterViewTypeShadow) {
        _countLabel.text = [NSString stringWithFormat:leftFormatText, count];
    }
}

@end
