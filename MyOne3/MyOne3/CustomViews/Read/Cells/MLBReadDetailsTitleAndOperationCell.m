//
//  MLBReadDetailsTitleAndOperationCell.m
//  MyOne3
//
//  Created by meilbn on 9/13/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadDetailsTitleAndOperationCell.h"

NSString *const kMLBReadDetailsTitleAndOperationCellID = @"MLBReadDetailsTitleAndOperationCellID";

@interface MLBReadDetailsTitleAndOperationCell ()

@end

@implementation MLBReadDetailsTitleAndOperationCell

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
			make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(8, 12, 8, 44 + 15 + 8));
		}];
		
		label;
	});
	
	self.serialsButton = ({
		UIButton *button = [MLBUIFactory buttonWithImageName:@"icon_article_list_normal" highlightImageName:@"icon_article_list_highlighted" target:self action:@selector(serialsButtonClicked)];
		button.backgroundColor = [UIColor whiteColor];
		[self.contentView addSubview:button];
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.height.equalTo(@44);
			make.centerY.equalTo(_titleLabel);
			make.right.equalTo(self.contentView).offset(-15);
		}];
		button;
	});
}

#pragma mark - Action

- (void)serialsButtonClicked {
	if (_serialsClicked) {
		_serialsClicked();
	}
}

#pragma mark - Public Methods



@end
