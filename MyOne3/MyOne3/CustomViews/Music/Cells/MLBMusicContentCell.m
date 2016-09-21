//
//  MLBMusicContentCell.m
//  MyOne3
//
//  Created by meilbn on 9/16/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBMusicContentCell.h"
#import "MLBMusicDetails.h"

NSString *const kMLBMusicContentCellID = @"MLBMusicContentCellID";

@interface MLBMusicContentCell ()

@property (strong, nonatomic) UIImageView *coverView;
@property (strong, nonatomic) UIView *authorView;
@property (strong, nonatomic) UIImageView *authorAvatarView;
@property (strong, nonatomic) UILabel *authorNameLabel;
@property (strong, nonatomic) UIImageView *firstPublishView;
@property (strong, nonatomic) UILabel *authorDescLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UIButton *musicControlButton;
@property (strong, nonatomic) UILabel *contentTypeLabel;
@property (strong, nonatomic) UIButton *storyButton;
@property (strong, nonatomic) UIButton *lyricButton;
@property (strong, nonatomic) UIButton *aboutButton;
@property (strong, nonatomic) UITextView *contentTextView;
@property (strong, nonatomic) UIButton *praiseButton;
@property (strong, nonatomic) UIButton *commentButton;
@property (strong, nonatomic) UIButton *shareButton;

@end

@implementation MLBMusicContentCell {
	NSArray *typeButtons;
	MLBMusicDetails *_musicDetails;
}

- (void)prepareForReuse {
	[super prepareForReuse];
	_coverView.image = nil;
	[_coverView sd_cancelCurrentImageLoad];
	_authorAvatarView.image = nil;
	[_authorAvatarView sd_cancelCurrentImageLoad];
	_musicDetails = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
	if (self) {
		[self setupViews];
	}
	
	return self;
}

- (void)setupViews {
	if (_coverView) {
		return;
	}
	
	self.contentView.backgroundColor = [UIColor whiteColor];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	_coverView = ({
		UIImageView *imageView = [UIImageView new];
		imageView.backgroundColor = [UIColor whiteColor];
		imageView.contentMode = UIViewContentModeScaleAspectFill;
		imageView.clipsToBounds = YES;
		[self.contentView addSubview:imageView];
		[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.height.equalTo(imageView.mas_width).multipliedBy(1);
			make.left.top.right.equalTo(self.contentView);
		}];
		
		imageView;
	});
	
	_authorView = ({
		UIView *view = [UIView new];
		view.backgroundColor = [UIColor whiteColor];
		view.layer.shadowColor = MLBShadowColor.CGColor;
		view.layer.shadowOffset = CGSizeZero;
		view.layer.shadowRadius = 2;
		view.layer.shadowOpacity = 0.5;
		view.layer.cornerRadius = 2;
		[self.contentView addSubview:view];
		[view mas_makeConstraints:^(MASConstraintMaker *make) {
			make.height.greaterThanOrEqualTo(@120);
			make.top.equalTo(_coverView.mas_bottom).offset(-24);
			make.left.equalTo(self.contentView).offset(15);
			make.right.equalTo(self.contentView).offset(-15);
		}];
		
		view;
	});
	
	_authorAvatarView = ({
		UIImageView *imageView = [UIImageView new];
		imageView.backgroundColor = [UIColor whiteColor];
		imageView.layer.cornerRadius = 24;
		imageView.layer.borderColor = [UIColor whiteColor].CGColor;
		imageView.layer.borderWidth = 1;
		imageView.clipsToBounds = YES;
		[_authorView addSubview:imageView];
		[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.height.equalTo(@48);
			make.top.equalTo(_authorView).offset(20);
			make.left.equalTo(_authorView).offset(16);
		}];
		
		imageView;
	});
	
	_firstPublishView = ({
		UIImageView *imageView = [UIImageView new];
		imageView.backgroundColor = [UIColor whiteColor];
		[_authorView addSubview:imageView];
		[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(_authorAvatarView);
			make.right.equalTo(_authorView).offset(-10);
		}];
		
		imageView;
	});
	
	_authorNameLabel = ({
		UILabel *label = [MLBUIFactory labelWithTextColor:MLBAppThemeColor font:FontWithSize(12)];
		[_authorView addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(_authorAvatarView).offset(7);
			make.left.equalTo(_authorAvatarView.mas_right).offset(12);
			
		}];
		
		label;
	});
	
	_authorDescLabel = ({
		UILabel *label = [MLBUIFactory labelWithTextColor:MLBLightGrayTextColor font:FontWithSize(12) numberOfLine:0];
		[_authorView addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(_authorNameLabel.mas_bottom).offset(4);
			make.left.equalTo(_authorNameLabel);
		}];
		
		label;
	});
	
	_titleLabel = ({
		UILabel *label = [MLBUIFactory labelWithTextColor:MLBLightBlackTextColor font:FontWithSize(18)];
		[_authorView addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.greaterThanOrEqualTo(@[_authorAvatarView.mas_bottom, _authorDescLabel.mas_bottom]).offset(10);
			make.left.equalTo(_authorAvatarView);
			make.bottom.equalTo(_authorView).offset(-16);
		}];
		
		label;
	});
	
	_dateLabel = ({
		UILabel *label = [UILabel new];
		label.backgroundColor = [UIColor whiteColor];
		label.textColor = MLBLightGrayTextColor;
		label.font = FontWithSize(12);
		[label setContentCompressionResistancePriority:251 forAxis:UILayoutConstraintAxisHorizontal];
		[_authorView addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.greaterThanOrEqualTo(_titleLabel.mas_right).offset(5);
			make.right.bottom.equalTo(_authorView).offset(-8);
		}];
		
		label;
	});
	
	_musicControlButton = ({
		UIButton *button = [MLBUIFactory buttonWithImageName:@"play_normal" highlightImageName:@"play_highlighted" target:self action:@selector(controlStoryMusicPlay)];
		[_authorView addSubview:button];
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.height.equalTo(@50);
			make.left.greaterThanOrEqualTo(@[_authorNameLabel.mas_right, _authorDescLabel.mas_right]).offset(5);
			make.right.equalTo(_authorView).offset(-10);
			make.bottom.equalTo(_dateLabel.mas_top).offset(-8);
		}];
		
		button;
	});
	
	_aboutButton = ({
		UIButton *button = [MLBUIFactory buttonWithImageName:@"music_about_normal" selectedImageName:@"music_about_selected" target:self action:@selector(typeButtonClicked:)];
		button.backgroundColor = [UIColor whiteColor];
		button.tag = MLBMusicDetailsTypeInfo;
		[self.contentView addSubview:button];
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.size.sizeOffset(CGSizeMake(44, 44));
			make.top.equalTo(_authorView.mas_bottom);
			make.right.equalTo(self.contentView);
		}];
		
		button;
	});
	
	_lyricButton = ({
		UIButton *button = [MLBUIFactory buttonWithImageName:@"music_lyric_normal" selectedImageName:@"music_lyric_selected" target:self action:@selector(typeButtonClicked:)];
		button.backgroundColor = [UIColor whiteColor];
		button.tag = MLBMusicDetailsTypeLyric;
		[self.contentView addSubview:button];
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.size.equalTo(_aboutButton);
			make.top.equalTo(_aboutButton);
			make.right.equalTo(_aboutButton.mas_left).offset(-8);
		}];
		
		button;
	});
	
	_storyButton = ({
		UIButton *button = [MLBUIFactory buttonWithImageName:@"music_story_normal" selectedImageName:@"music_story_selected" target:self action:@selector(typeButtonClicked:)];
		button.backgroundColor = [UIColor whiteColor];
		button.tag = MLBMusicDetailsTypeStory;
		[self.contentView addSubview:button];
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.size.equalTo(_aboutButton);
			make.top.equalTo(_aboutButton);
			make.right.equalTo(_lyricButton.mas_left).offset(-8);
		}];
		
		button;
	});
	
	typeButtons = @[_storyButton, _lyricButton, _aboutButton];
	
	_contentTypeLabel = ({
		UILabel *label = [MLBUIFactory labelWithTextColor:MLBColor7F7F7F font:FontWithSize(12)];
		label.text = @"音乐故事";
		[self.contentView addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.contentView).offset(12);
			make.bottom.equalTo(_storyButton).offset(-8);
		}];
		
		label;
	});
	
	UIView *separator = [MLBUIFactory separatorLine];
	[self.contentView addSubview:separator];
	[separator mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.equalTo(@0.5);
		make.top.equalTo(_storyButton.mas_bottom);
		make.left.equalTo(self.contentView).offset(6);
		make.right.equalTo(self.contentView).offset(-6);
	}];
	
	[self.contentView bringSubviewToFront:_authorView];
	
	_contentTextView = ({
		UITextView *textView = [UITextView new];
		textView.backgroundColor = [UIColor whiteColor];
		textView.textColor = MLBDarkBlackTextColor;
		textView.font = FontWithSize(15);
		textView.editable = NO;
		textView.scrollEnabled = NO;
		textView.showsVerticalScrollIndicator = NO;
		textView.showsHorizontalScrollIndicator = NO;
		textView.textContainerInset = UIEdgeInsetsMake(8, 8, 0, 8);
		[self.contentView addSubview:textView];
		[textView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(separator.mas_bottom);
			make.left.right.equalTo(self.contentView);
		}];
		
		textView;
	});
	
	_praiseButton = ({
		UIButton *button = [MLBUIFactory buttonWithImageName:@"like_normal" selectedImageName:@"like_selected" target:self action:@selector(praiseButtonClicked:)];
		button.titleLabel.font = FontWithSize(12);
		[button setTitleColor:MLBDarkGrayTextColor forState:UIControlStateNormal];
		[button setTitleColor:MLBDarkGrayTextColor forState:UIControlStateSelected];
		button.backgroundColor = [UIColor whiteColor];
		[self.contentView addSubview:button];
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.height.equalTo(@44);
			make.top.equalTo(_contentTextView.mas_bottom);
			make.left.bottom.equalTo(self.contentView);
		}];
		
		button;
	});
	
	_commentButton = ({
		UIButton *button = [MLBUIFactory buttonWithImageName:@"icon_toolbar_comment" selectedImageName:nil target:self action:@selector(commentButtonClicked:)];
		button.backgroundColor = [UIColor whiteColor];
		button.titleLabel.font = FontWithSize(12);
		[button setTitleColor:MLBDarkGrayTextColor forState:UIControlStateNormal];
		[self.contentView addSubview:button];
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.height.equalTo(_praiseButton);
			make.top.equalTo(_praiseButton);
			make.left.equalTo(_praiseButton.mas_right);
		}];
		
		button;
	});
	
	_shareButton = ({
		UIButton *button = [MLBUIFactory buttonWithImageName:@"share_image" selectedImageName:nil target:self action:@selector(shareButtonClicked:)];
		button.backgroundColor = [UIColor whiteColor];
		button.titleLabel.font = FontWithSize(12);
		[button setTitleColor:MLBDarkGrayTextColor forState:UIControlStateNormal];
		[self.contentView addSubview:button];
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.equalTo(@[_praiseButton, _commentButton]);
			make.height.equalTo(_praiseButton);
			make.top.equalTo(_praiseButton);
			make.left.equalTo(_commentButton.mas_right);
			make.right.equalTo(self.contentView);
		}];
		
		button;
	});
	
	UIImageView *imageView0 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_toolbar_line"]];
	imageView0.backgroundColor = [UIColor whiteColor];
	imageView0.contentMode = UIViewContentModeCenter;
	[self.contentView addSubview:imageView0];
	[imageView0 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(@1);
		make.left.equalTo(_praiseButton.mas_right);
		make.top.bottom.equalTo(_praiseButton);
	}];
	
	UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_toolbar_line"]];
	imageView1.backgroundColor = [UIColor whiteColor];
	imageView1.contentMode = UIViewContentModeCenter;
	[self.contentView addSubview:imageView1];
	[imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(@1);
		make.left.equalTo(_commentButton.mas_right);
		make.top.bottom.equalTo(_commentButton);
	}];
	
	UIView *separator0 = [MLBUIFactory separatorLine];
	[self.contentView addSubview:separator0];
	[separator0 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.equalTo(@0.5);
		make.top.equalTo(_praiseButton);
		make.left.right.equalTo(self.contentView);
	}];
	
	UIView *separator1 = [MLBUIFactory separatorLine];
	[self.contentView addSubview:separator1];
	[separator1 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.equalTo(@0.5);
		make.left.right.equalTo(self.contentView);
		make.bottom.equalTo(_praiseButton);
	}];
}

- (UIImage *)firstPublishImageWithMusicDetails:(MLBMusicDetails *)musicDetails {
	// isFirst 为0时，platform 为1则为虾米音乐首发，为2则不显示首发平台,
	// isFirst 为1时，platform 为1则为虾米和一个联合首发，为2则为一个独家首发
	NSString *imageName = @"";
	if ([musicDetails.isFirst isEqualToString:@"0"] && [musicDetails.platform isEqualToString:@"1"]) {
		imageName = @"xiami_music_first";
	} else if ([musicDetails.isFirst isEqualToString:@"1"]) {
		imageName = [musicDetails.platform isEqualToString:@"1"] ? @"one_and_xiami_music" : @"one_first";
	}
	
	if (IsStringNotEmpty(imageName)) {
		return [UIImage imageNamed:imageName];
	} else {
		return nil;
	}
}

- (void)updateContentTextViewWithType:(MLBMusicDetailsType)type {
	NSString *text = @"";
	switch (type) {
		case MLBMusicDetailsTypeNone:
			break;
		case MLBMusicDetailsTypeStory:
			text = _musicDetails.story;
			break;
		case MLBMusicDetailsTypeLyric:
			text = _musicDetails.lyric;
			break;
		case MLBMusicDetailsTypeInfo:
			text = _musicDetails.info;
			break;
	}
	
	if (IsStringEmpty(text)) {
		return;
	}
	
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.lineSpacing = 8;
	
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
	if (type == MLBMusicDetailsTypeStory) {
		[attributedString appendAttributedString:[MLBUtilities mlb_attributedStringWithText:_musicDetails.storyTitle lineSpacing:8 font:BoldFontWithSize(20) textColor:[UIColor blackColor]]];
		[attributedString appendAttributedString:[MLBUtilities mlb_attributedStringWithText:[NSString stringWithFormat:@"\n%@\n\n", _musicDetails.storyAuthor.username] lineSpacing:8 font:FontWithSize(12) textColor:MLBLightBlueTextColor]];
		
		NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType } documentAttributes:nil error:nil]];
		[string setAttributes:@{ NSFontAttributeName : FontWithSize(16),
								NSForegroundColorAttributeName : MLBLightBlackTextColor,
								 NSParagraphStyleAttributeName : paragraphStyle } range:NSMakeRange(0, string.string.length)];
		
		[attributedString appendAttributedString:string];
	} else {
		attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[MLBUtilities mlb_attributedStringWithText:text lineSpacing:8 font:FontWithSize(16) textColor:MLBLightBlackTextColor]];
	}
	
	NSString *editorText = [NSString stringWithFormat:@"\n\n%@\n\n", _musicDetails.chargeEditor];
	
	[attributedString appendAttributedString:[MLBUtilities mlb_attributedStringWithText:editorText lineSpacing:8 font:FontWithSize(12) textColor:MLBColor7F7F7F]];
	
	_contentTextView.attributedText = attributedString;
}

#pragma mark - Action

- (void)controlStoryMusicPlay {
	
}

- (void)typeButtonClicked:(UIButton *)sender {
	if (!sender.isSelected) {
		if (_contentTypeButtonSelected) {
			_musicDetails.contentType = (MLBMusicDetailsType)sender.tag;
			_contentTypeButtonSelected((MLBMusicDetailsType)sender.tag);
		}
	}
}

- (void)showContentWithType:(MLBMusicDetailsType)type {
	for (UIButton *button in typeButtons) {
		button.selected = button.tag == type;
	}
	
	switch (type) {
		case MLBMusicDetailsTypeNone: {
			_contentTypeLabel.text = @"音乐故事";
			_contentTextView.text = @"";
			_contentTextView.attributedText = nil;
			break;
		}
		case MLBMusicDetailsTypeStory: {
			_contentTypeLabel.text = @"音乐故事";
			break;
		}
		case MLBMusicDetailsTypeLyric: {
			_contentTypeLabel.text = @"歌词";
			break;
		}
		case MLBMusicDetailsTypeInfo: {
			_contentTypeLabel.text = @"歌曲信息";
			break;
		}
	}
	
	[self updateContentTextViewWithType:type];
}

- (void)praiseButtonClicked:(UIButton *)sender {
	sender.selected = !sender.isSelected;
}

- (void)commentButtonClicked:(UIButton *)sender {
	
}

- (void)shareButtonClicked:(UIButton *)sender {
	
}

#pragma mark - Public Methods

- (void)configureCellWithMusicDetails:(MLBMusicDetails *)musicDetails {
	_musicDetails = musicDetails;
	
	if (_musicDetails) {
		[_coverView mlb_sd_setImageWithURL:musicDetails.cover placeholderImageName:@"music_cover_small" cachePlachoderImage:NO];
		[_authorAvatarView mlb_sd_setImageWithURL:musicDetails.author.webURL placeholderImageName:@"personal"];
		_authorNameLabel.text = musicDetails.author.username;
		_authorDescLabel.text = musicDetails.author.desc;
		_titleLabel.text = musicDetails.title;
		_dateLabel.text = [MLBUtilities stringDateForMusicDetailsDateString:musicDetails.makeTime];
		_firstPublishView.image = [self firstPublishImageWithMusicDetails:musicDetails];
		_storyButton.selected = YES;
		[self showContentWithType:_musicDetails.contentType == MLBMusicDetailsTypeNone ? MLBMusicDetailsTypeStory : _musicDetails.contentType];
		[_praiseButton setTitle:[@(musicDetails.praiseNum) stringValue] forState:UIControlStateNormal];
		[_commentButton setTitle:[@(musicDetails.commentNum) stringValue] forState:UIControlStateNormal];
		[_shareButton setTitle:[@(musicDetails.shareNum) stringValue] forState:UIControlStateNormal];
	} else {
		_coverView.image = [UIImage mlb_imageWithName:@"music_cover_small" cached:NO];
		_authorAvatarView.image = [UIImage imageNamed:@"personal"];
		_authorNameLabel.text = @"";
		_authorDescLabel.text = @"";
		_titleLabel.text = @"";
		_dateLabel.text = @"";
		_firstPublishView.image = nil;
		_storyButton.selected = NO;
		[self showContentWithType:MLBMusicDetailsTypeNone];
		[_praiseButton setTitle:@"0" forState:UIControlStateNormal];
		[_commentButton setTitle:@"0" forState:UIControlStateNormal];
		[_shareButton setTitle:@"0" forState:UIControlStateNormal];
	}
}

@end
