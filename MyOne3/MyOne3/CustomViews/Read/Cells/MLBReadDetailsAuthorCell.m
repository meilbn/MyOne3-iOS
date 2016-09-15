//
//  MLBReadDetailsAuthorCell.m
//  MyOne3
//
//  Created by meilbn on 9/13/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadDetailsAuthorCell.h"
#import "MLBReadEssayDetails.h"
#import "MLBReadSerialDetails.h"

NSString *const kMLBReadDetailsAuthorCellID = @"MLBReadDetailsAuthorCellID";

@interface MLBReadDetailsAuthorCell ()

@property (strong, nonatomic) MLBTapImageView *userAvatarView;
@property (strong, nonatomic) UILabel *usernameLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UIButton *listenInButton;

@end

@implementation MLBReadDetailsAuthorCell {
	MLBReadType _viewType;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
	if (self) {
		[self setupViews];
	}
	
	return self;
}

- (void)setupViews {
	if (_userAvatarView) {
		return;
	}
	
	self.contentView.backgroundColor = [UIColor whiteColor];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	self.userAvatarView = ({
		MLBTapImageView *imageView = [[MLBTapImageView alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
		[imageView zy_cornerRadiusRoundingRect];
		[imageView zy_attachBorderWidth:1 color:[UIColor whiteColor]];
		[self.contentView addSubview:imageView];
		[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.height.equalTo(@48).priority(999);
			make.top.left.bottom.equalTo(self.contentView).insets(UIEdgeInsetsMake(20, 12, 20, 0));
		}];
		
		imageView;
	});
	
	self.usernameLabel = ({
		UILabel *label = [MLBUIFactory labelWithTextColor:MLBLightBlueTextColor font:FontWithSize(12)];
		[self.contentView addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(_userAvatarView).offset(5);
			make.left.equalTo(_userAvatarView.mas_right).offset(6);
		}];
		
		label;
	});
	
	self.dateLabel = ({
		UILabel *label = [MLBUIFactory labelWithTextColor:MLBColorC6C6C6 font:FontWithSize(12)];
		[self.contentView addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(_usernameLabel.mas_bottom).offset(5);
			make.left.equalTo(_usernameLabel);
		}];
		
		label;
	});
	
	self.listenInButton = ({
		UIButton *button = [MLBUIFactory buttonWithImageName:@"audio_normal" highlightImageName:@"audio_highlighted" target:self action:@selector(listenInButtonSelected:)];
		button.backgroundColor = [UIColor whiteColor];
		[self.contentView addSubview:button];
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.height.equalTo(@44);
			make.centerY.equalTo(self.contentView);
			make.left.greaterThanOrEqualTo(_usernameLabel.mas_right).offset(5).priority(999);
			make.left.greaterThanOrEqualTo(_dateLabel.mas_right).offset(5).priority(999);
			make.right.equalTo(self.contentView).offset(-15);
		}];
		
		button;
	});
}

#pragma mark - Action

- (void)listenInButtonSelected:(UIButton *)sender {
	if (_viewType == MLBReadTypeEssay) {
		
	}
}

#pragma mark - Public Methods

- (void)configureCellWithEssayDetails:(MLBReadEssayDetails *)essayDetails {
	_viewType = MLBReadTypeEssay;
	
	if (essayDetails) {
		[_userAvatarView mlb_sd_setImageWithURL:((MLBAuthor *)[essayDetails.authors firstObject]).webURL placeholderImageName:@"personal"];
		_usernameLabel.text = essayDetails.title;
		_dateLabel.text = [MLBUtilities stringDateForReadDetailsDateString:essayDetails.makeTime];
		_listenInButton.hidden = IsStringEmpty(essayDetails.audioURL);
	} else {
		_userAvatarView.image = [UIImage imageNamed:@"personal"];
		_usernameLabel.text = @"";
		_dateLabel.text = @"";
		_listenInButton.hidden = YES;
	}
}

- (void)configureCellWithSerialDetails:(MLBReadSerialDetails *)serialDetails {
	_viewType = MLBReadTypeSerial;
	
	if (serialDetails) {
		[_userAvatarView mlb_sd_setImageWithURL:serialDetails.author.webURL placeholderImageName:@"personal"];
		_usernameLabel.text = serialDetails.title;
		_dateLabel.text = [MLBUtilities stringDateForReadDetailsDateString:serialDetails.makeTime];
		_listenInButton.hidden = YES;
	} else {
		_userAvatarView.image = [UIImage imageNamed:@"personal"];
		_usernameLabel.text = @"";
		_dateLabel.text = @"";
		_listenInButton.hidden = YES;
	}
}

@end
