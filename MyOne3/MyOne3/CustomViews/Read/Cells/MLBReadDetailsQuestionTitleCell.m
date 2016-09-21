//
//  MLBReadDetailsQuestionTitleCell.m
//  MyOne3
//
//  Created by meilbn on 9/15/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadDetailsQuestionTitleCell.h"
#import "MLBReadQuestionDetails.h"

NSString *const kMLBReadDetailsQuestionTitleCellID = @"MLBReadDetailsQuestionTitleCellID";

@interface MLBReadDetailsQuestionTitleCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation MLBReadDetailsQuestionTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
	if (self) {
		[self setupViews];
	}
	
	return self;
}

- (void)setupViews {
	if (_titleLabel) {
		return;
	}
	
	self.contentView.backgroundColor = [UIColor whiteColor];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	self.titleLabel = ({
		UILabel *label = [MLBUIFactory labelWithTextColor:MLBDarkBlackTextColor font:BoldFontWithSize(20) numberOfLine:0];
		[self.contentView addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.top.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(24, 8, 0, 8));
		}];
		
		label;
	});
	
	self.contentLabel = ({
		UILabel *label = [MLBUIFactory labelWithTextColor:MLBColor515151 font:FontWithSize(16) numberOfLine:0];
		[self.contentView addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(_titleLabel.mas_bottom).offset(32);
			make.left.bottom.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 24, 10));
		}];
		
		label;
	});
	
	UIView *bottomSeparator = [MLBUIFactory separatorLine];
	[self.contentView addSubview:bottomSeparator];
	[bottomSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.equalTo(@0.5);
		make.left.bottom.right.equalTo(self.contentView);
	}];
}

#pragma mark - Public Methods

- (void)configureCellWithQuestionDetails:(MLBReadQuestionDetails *)questionDetails {
	_titleLabel.attributedText = [MLBUtilities mlb_attributedStringWithText:questionDetails.questionTitle lineSpacing:MLBLineSpacing font:_titleLabel.font textColor:_titleLabel.textColor];
	_contentLabel.attributedText = [MLBUtilities mlb_attributedStringWithText:questionDetails.questionContent lineSpacing:MLBLineSpacing font:_contentLabel.font textColor:_contentLabel.textColor];
}

@end
