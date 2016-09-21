//
//  MLBCommentCell.m
//  MyOne3
//
//  Created by meilbn on 2/23/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBCommentCell.h"
#import "MLBMovieStory.h"
#import "MLBMovieReview.h"
#import "MLBComment.h"

NSString *const kMLBCommentCellID = @"MLBCommentCellID";

@interface MLBCommentCell ()

@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) MLBTapImageView *userAvatarView;
@property (strong, nonatomic) UILabel *usernameLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UIButton *praiseButton;
@property (strong, nonatomic) UIView *replyContentView;
@property (strong, nonatomic) UILabel *replyContentLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIButton *unfoldButton;

@property (strong, nonatomic) UIView *separator0;
@property (strong, nonatomic) UIView *separator1;

@property (strong, nonatomic) MASConstraint *replyContentHeightConstraint;
@property (strong, nonatomic) MASConstraint *unfoldButtonHeightConstraint;
@property (strong, nonatomic) MASConstraint *mainViewBottomOffsetConstraint;

@end

@implementation MLBCommentCell

- (void)prepareForReuse {
    [super prepareForReuse];
    _userAvatarView.image = nil;
	_usernameLabel.text = @"";
	_dateLabel.text = @"";
	_replyContentLabel.attributedText = nil;
	_contentLabel.attributedText = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    if (_mainView) {
        return;
    }
	
	self.contentView.backgroundColor = MLBColorF8F8F8;
    
    _mainView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
			_mainViewBottomOffsetConstraint = make.bottom.equalTo(self.contentView).offset(-8);
        }];
        
        view;
    });
    
    _userAvatarView = ({
        MLBTapImageView *imageView = [[MLBTapImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
		[imageView zy_cornerRadiusRoundingRect];
        [_mainView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@36).priority(999);
            make.top.equalTo(_mainView).offset(26);
			make.left.equalTo(_mainView).offset(18);
        }];
        
        imageView;
    });
	
	__weak typeof(self) weakSelf = self;
	[_userAvatarView addTapBlock:^(id obj) {
		__strong typeof(weakSelf) strongSelf = weakSelf;
		[strongSelf callbackWithButtonType:MLBCommentCellButtonTypeUserAvatar];
	}];
    
    _usernameLabel = ({
        UILabel *label = [MLBUIFactory labelWithTextColor:MLBColor4A90E2 font:FontWithSize(15)];
        [_mainView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_userAvatarView.mas_right).offset(10);
            make.top.equalTo(_userAvatarView).offset(3);
        }];
        
        label;
    });
    
    _dateLabel = ({
        UILabel *label = [MLBUIFactory labelWithTextColor:MLBColorB8B8B8 font:FontWithSize(12)];
        [_mainView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_usernameLabel.mas_bottom).offset(3);
            make.left.equalTo(_usernameLabel);
        }];
        
        label;
    });
    
    _praiseButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"icon_comment_praise_normal" selectedImageName:@"icon_comment_praise_selected" target:self action:@selector(praiseButtonSelected)];
		[button setTitleColor:MLBColor626262 forState:UIControlStateNormal];
		[button setTitleColor:MLBColor626262 forState:UIControlStateSelected];
		button.titleLabel.font = FontWithSize(12);
		[button setContentCompressionResistancePriority:751 forAxis:UILayoutConstraintAxisHorizontal];
        [_mainView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@15);
			make.top.equalTo(_mainView).offset(30);
			make.left.greaterThanOrEqualTo(_usernameLabel.mas_right).offset(8);
            make.right.equalTo(_mainView).offset(-20);
        }];
        
        button;
    });
	
	_replyContentView = ({
		UIView *view = [UIView new];
		view.backgroundColor = [UIColor whiteColor];
		view.layer.borderWidth = 0.5;
		view.layer.borderColor = MLBColorD8D8D8.CGColor;
		[_mainView addSubview:view];
		[view mas_makeConstraints:^(MASConstraintMaker *make) {
			_replyContentHeightConstraint = make.height.equalTo(@0);
			make.top.equalTo(_userAvatarView.mas_bottom).offset(16);
			make.left.equalTo(_mainView).offset(20);
			make.right.equalTo(_mainView).offset(-17);
		}];
		
		view;
	});
	
    _replyContentLabel = ({
        UILabel *label = [MLBUIFactory labelWithTextColor:MLBColor626262 font:FontWithSize(13) numberOfLine:3];
		label.lineBreakMode = NSLineBreakByTruncatingTail;
        [_replyContentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(_replyContentView).insets(UIEdgeInsetsMake(13, 13, 3, 13)).priority(999);
        }];
        
        label;
    });
    
    _contentLabel = ({
        UILabel *label = [MLBUIFactory labelWithTextColor:MLBColor0E0E0E font:FontWithSize(16) numberOfLine:5];
		label.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_replyContentView.mas_bottom).offset(10);
            make.left.right.equalTo(_replyContentView);
        }];
        
        label;
    });
	
	_unfoldButton = ({
		UIButton *button = [MLBUIFactory buttonWithTitle:@"展开" titleColor:MLBColor8FBFF9 fontSize:16 target:self action:@selector(unfoldButtonClicked)];
		button.backgroundColor = [UIColor whiteColor];
		[button setTitleColor:MLBColorCC8FBFF9 forState:UIControlStateHighlighted];
		button.clipsToBounds = YES;
		button.enabled = NO;
		[_mainView addSubview:button];
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.equalTo(@32);
			_unfoldButtonHeightConstraint = make.height.equalTo(@32);
			make.top.equalTo(_contentLabel.mas_bottom);
			make.left.equalTo(_contentLabel);
			make.bottom.equalTo(_mainView).offset(-15);
		}];
		
		button;
	});
	
	_separator0 = [MLBUIFactory separatorLine];
	[self.contentView addSubview:_separator0];
	[_separator0 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.equalTo(@0.5);
		make.top.equalTo(_mainView.mas_bottom);
		make.left.right.equalTo(self.contentView);
	}];
	
	_separator1 = [MLBUIFactory separatorLine];
	[self.contentView addSubview:_separator1];
	[_separator1 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.equalTo(@0.5);
		make.left.bottom.right.equalTo(self.contentView);
	}];
	
	MASAttachKeys(_mainView, _userAvatarView, _usernameLabel, _dateLabel, _praiseButton, _replyContentView, _replyContentLabel, _contentLabel, _unfoldButton, _separator0, _separator1);
}

- (void)updatePraiseNumberButtonWithNumber:(NSInteger)number {
	NSString *title = [@(number) stringValue];
	[_praiseButton setTitle:title forState:UIControlStateNormal];
	[_praiseButton setTitle:title forState:UIControlStateSelected];
}

#pragma mark - Setter

- (void)setLastHotComment:(BOOL)lastHotComment {
	if (_lastHotComment != lastHotComment) {
		_lastHotComment = lastHotComment;
		
		_mainViewBottomOffsetConstraint.offset(_lastHotComment ? 0 : -8);
		_separator0.hidden = _lastHotComment;
	}
}

#pragma mark - Action

- (void)callbackWithButtonType:(MLBCommentCellButtonType)buttonType {
	if (_cellButtonClicked) {
		_cellButtonClicked(buttonType, self.indexPath);
	}
}

- (void)praiseButtonSelected {
	[self callbackWithButtonType:MLBCommentCellButtonTypePraise];
}

- (void)unfoldButtonClicked {
	[self callbackWithButtonType:MLBCommentCellButtonTypeUnfold];
}

#pragma mark - Public Method

- (void)configureCellForMovieWithStory:(MLBMovieStory *)story atIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    [_userAvatarView mlb_sd_setImageWithURL:story.user.webURL placeholderImageName:@"personal"];
    _usernameLabel.text = story.user.username;
    _dateLabel.text = [MLBUtilities stringDateForMusicDetailsDateString:story.inputDate];
    _replyContentLabel.text = story.title;
    _replyContentLabel.textColor = MLBColor303030;
    _replyContentLabel.font = [UIFont boldSystemFontOfSize:14];
    _replyContentLabel.backgroundColor = [UIColor whiteColor];
    _contentLabel.text = story.content;
}

- (void)configureCellForMovieWithReview:(MLBMovieReview *)review atIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    [_userAvatarView mlb_sd_setImageWithURL:review.author.webURL placeholderImageName:@"personal"];
    _usernameLabel.text = review.author.username;
    _dateLabel.text = [MLBUtilities stringDateForMusicDetailsDateString:review.inputDate];
    _contentLabel.text = review.content;
}

- (void)configureCellForCommonWithComment:(MLBComment *)comment atIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    [_userAvatarView mlb_sd_setImageWithURL:comment.user.webURL placeholderImageName:@"personal"];
    _usernameLabel.text = [comment.user.username mlb_trimming];
    _dateLabel.text = [MLBUtilities stringDateForCommentDateString:comment.inputDate];
	[self updatePraiseNumberButtonWithNumber:comment.praiseNum];
	
	if (IsStringNotEmpty(comment.quote)) {
		[_replyContentHeightConstraint deactivate];
		
		NSString *name = [NSString stringWithFormat:@"%@:", [comment.toUser.username mlb_trimming]];
		NSString *string = [NSString stringWithFormat:@"%@\n%@", name, comment.quote];
		NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[MLBUtilities mlb_attributedStringWithText:string lineSpacing:MLBLineSpacing font:FontWithSize(13) textColor:MLBColor626262 lineBreakMode:NSLineBreakByTruncatingTail]];
		[attributedString addAttributes:@{ NSFontAttributeName : BoldFontWithSize(13),
										   NSForegroundColorAttributeName : MLBColor484848 } range:[attributedString.string rangeOfString:name]];
		
		_replyContentLabel.attributedText = attributedString;
	} else {
		[_replyContentHeightConstraint activate];
		_replyContentLabel.attributedText = nil;
	}
	
    _contentLabel.attributedText = [MLBUtilities mlb_attributedStringWithText:comment.content lineSpacing:MLBLineSpacing font:_contentLabel.font textColor:_contentLabel.textColor lineBreakMode:NSLineBreakByTruncatingTail];
	
	if (comment.numberOflines <= 0) {
		_contentLabel.numberOfLines = 0;
		CGSize fitSize = [_contentLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 20 - 17, CGFLOAT_MAX)];
		NSInteger numberOfLines = ceil(ceil(fitSize.height) / (_contentLabel.font.lineHeight + 10.0));
//		NSLog(@"number of lines = %ld", numberOfLines);
		comment.numberOflines = numberOfLines;
	}
	
	if (comment.isUnfolded || comment.numberOflines <= 5) {
		_contentLabel.numberOfLines = comment.isUnfolded ? 0 : 5;
		_unfoldButtonHeightConstraint.equalTo(@0);
		_unfoldButton.enabled = NO;
	} else {
		_contentLabel.numberOfLines = 5;
		_unfoldButtonHeightConstraint.equalTo(@32);
		_unfoldButton.enabled = YES;
	}
	
	self.lastHotComment = comment.isLastHotComment;
}

@end
