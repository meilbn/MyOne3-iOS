//
//  MLBCommonHeaderFooterView.m
//  MyOne3
//
//  Created by meilbn on 9/14/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBCommonHeaderFooterView.h"

NSString *const kMLBCommonHeaderFooterViewIDForTypeHeader = @"kMLBCommonTypeHeaderID";

@interface MLBCommonHeaderFooterView ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *rightButton;

@property (strong, nonatomic) UIView *bottomSeparator;

@end

@implementation MLBCommonHeaderFooterView

#pragma mark - Class Methods

+ (CGFloat)viewHeight {
	return 40;
}

#pragma mark - LifeCycle

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
		[self setupViews];
	}
	
	return self;
}

#pragma mark - Private Methods

- (void)setupViews {
	if (_titleLabel) {
		return;
	}
	
	self.backgroundColor = MLBColorF5F5F5;
	self.contentView.backgroundColor = MLBColorF5F5F5;
	self.clipsToBounds = YES;
	
	_titleLabel = [MLBUIFactory labelWithTextColor:MLBColor7F7F7F font:FontWithSize(12)];
	_titleLabel.backgroundColor = MLBColorF5F5F5;
	[self.contentView addSubview:_titleLabel];
	[_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 12, 0, 0)).priority(999);
	}];
	
	_rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_rightButton.backgroundColor = MLBColorF5F5F5;
	[_rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_rightButton];
	[_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.equalTo(@40);
		make.centerY.equalTo(self);
		make.right.equalTo(self).offset(-8);
	}];
	
	_bottomSeparator = [MLBUIFactory separatorLine];
	_bottomSeparator.hidden = YES;
	[self.contentView addSubview:_bottomSeparator];
	[_bottomSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.equalTo(@0.5);
		make.left.bottom.right.equalTo(self.contentView);
	}];
}

#pragma mark - Setter

- (void)setViewType:(MLBCommonHeaderFooterViewType)viewType {
	if (_viewType == viewType) {
		return;
	}
	
	_viewType = viewType;
	
	NSString *title = @"";
	NSString *rightButtonImageNamePrefix = @"";
	
	NSTextAlignment textAlignment = NSTextAlignmentLeft;
	
	_bottomSeparator.hidden = YES;
	
	switch (_viewType) {
		case MLBCommonHeaderFooterViewTypeNone: {
			break;
		}
		case MLBCommonHeaderFooterViewTypeComment: {
			title = @"评论列表";
			break;
		}
		case MLBCommonHeaderFooterViewTypeRelatedRec: {
			title = @"相关推荐";
			break;
		}
		case MLBCommonHeaderFooterViewTypeRelatedMusic: {
			title = @"相似歌曲";
			rightButtonImageNamePrefix = @"music_list_play";
			break;
		}
		case MLBCommonHeaderFooterViewTypeMovieStory: {
			title = @"";
			rightButtonImageNamePrefix = @"";
			break;
		}
		case MLBCommonHeaderFooterViewTypeMovieReview: {
			title = @"";
			rightButtonImageNamePrefix = @"";
			break;
		}
		case MLBCommonHeaderFooterViewTypeMovieComment: {
			title = @"";
			rightButtonImageNamePrefix = @"";
			break;
		}
		case MLBCommonHeaderFooterViewTypeScoreRatio: {
			title = @"";
			rightButtonImageNamePrefix = @"";
			break;
		}
		case MLBCommonHeaderFooterViewTypeAboveIsHotComments: {
			title = @"以上是热门评论";
			textAlignment = NSTextAlignmentCenter;
			_bottomSeparator.hidden = NO;
			break;
		}
	}
	
	_titleLabel.text = title;
	_titleLabel.textAlignment = textAlignment;
	
	if (IsStringNotEmpty(rightButtonImageNamePrefix)) {
		_rightButton.hidden = NO;
		[_rightButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal", rightButtonImageNamePrefix]] forState:UIControlStateNormal];
		[_rightButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted", rightButtonImageNamePrefix]] forState:UIControlStateHighlighted];
		[_rightButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected", rightButtonImageNamePrefix]] forState:UIControlStateSelected];
	} else {
		_rightButton.hidden = YES;
		[_rightButton setImage:nil forState:UIControlStateNormal];
		[_rightButton setImage:nil forState:UIControlStateHighlighted];
		[_rightButton setImage:nil forState:UIControlStateSelected];
	}
	
	
}

#pragma mark - Action

- (void)rightButtonClicked {
	if ([_rightButton imageForState:UIControlStateNormal]) {
		DDLogDebug(@"common header view %@", NSStringFromSelector(_cmd));
	}
}

@end
