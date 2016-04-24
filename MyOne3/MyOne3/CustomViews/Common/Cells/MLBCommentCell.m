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

@property (strong, nonatomic) UIView *userView;
@property (strong, nonatomic) UIImageView *userAvatarView;
@property (strong, nonatomic) UILabel *usernameLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *praiseNumLabel;
@property (strong, nonatomic) UIButton *praiseButton;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UIImageView *officialPlotView;
@property (strong, nonatomic) UILabel *replyContentLabel;
@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation MLBCommentCell

- (void)prepareForReuse {
    [super prepareForReuse];
    _userAvatarView.image = nil;
}

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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    if (_userView) {
        return;
    }
    
    _userView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView);
        }];
        
        view;
    });
    
    _userAvatarView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = 18;
        imageView.clipsToBounds = YES;
        [_userView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@36);
            make.left.top.equalTo(_userView).offset(12);
        }];
        
        imageView;
    });
    
    _usernameLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = MLBAppThemeColor;
        label.font = FontWithSize(12);
        [_userView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_userAvatarView.mas_right).offset(12);
            make.centerY.equalTo(_userAvatarView);
        }];
        
        label;
    });
    
    _dateLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor colorWithWhite:184 / 255.0 alpha:1];// #B8B8B8
        label.font = FontWithSize(12);
        [_userView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_userAvatarView);
            make.right.equalTo(_userView).offset(-12);
        }];
        
        label;
    });
    
    _praiseNumLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = _dateLabel.textColor;
        label.font = FontWithSize(12);
        [_userView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_dateLabel.mas_bottom);
            make.right.equalTo(_dateLabel);
        }];
        
        label;
    });
    
    _praiseButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"like_normal" selectedImageName:@"like_selected" target:self action:@selector(likeButtonClicked)];
        [_userView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.right.equalTo(_praiseNumLabel.mas_left);
            make.top.equalTo(_dateLabel.mas_bottom).offset(-12);
            make.bottom.equalTo(_userView);
        }];
        
        button;
    });
    
    _scoreLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = MLBScoreTextColor;
        label.font = ScoreFontWithSize(20);
        [_userView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_praiseButton);
            make.right.equalTo(_praiseButton.mas_left).offset(-20);
        }];
        
        label;
    });
    
    _officialPlotView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"officalPlot"];
        [_userView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(55, 49));
            make.centerY.equalTo(_usernameLabel);
            make.left.equalTo(_usernameLabel.mas_right).offset(8);
        }];
        imageView.hidden = YES;
        
        imageView;
    });
    
    _replyContentLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor colorWithWhite:242 / 255.0 alpha:1];// #F2F2F2
        label.textColor = [UIColor colorWithWhite:72 / 255.0 alpha:1];// #484848
        label.font = FontWithSize(11);
        label.numberOfLines = 0;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_userView.mas_bottom);
            make.left.equalTo(self.contentView).offset(60);
            make.right.equalTo(self.contentView).offset(-12);
        }];
        
        label;
    });
    
    _contentLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor blackColor];
        label.font = FontWithSize(13);
        label.numberOfLines = 0;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_replyContentLabel.mas_bottom);
            make.left.right.equalTo(_replyContentLabel);
            make.bottom.equalTo(self.contentView).offset(-8);
        }];
        
        label;
    });
}

#pragma mark - Action

- (void)likeButtonClicked {
    
}

#pragma mark - Public Method

- (void)configureCellForMovieWithStory:(MLBMovieStory *)story atIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    [_userAvatarView mlb_sd_setImageWithURL:story.user.webURL placeholderImageName:@"personal"];
    _usernameLabel.text = story.user.username;
    _dateLabel.text = [MLBUtilities stringDateForMusicDetailsDateString:story.inputDate];
    _praiseNumLabel.text = [@(story.praiseNum) stringValue];
    _replyContentLabel.text = story.title;
    _replyContentLabel.textColor = [UIColor colorWithWhite:48 / 255.0 alpha:1];
    _replyContentLabel.font = [UIFont boldSystemFontOfSize:14];
    _replyContentLabel.backgroundColor = [UIColor whiteColor];
    _contentLabel.text = story.content;
}

- (void)configureCellForMovieWithReview:(MLBMovieReview *)review atIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    [_userAvatarView mlb_sd_setImageWithURL:review.author.webURL placeholderImageName:@"personal"];
    _usernameLabel.text = review.author.username;
    _dateLabel.text = [MLBUtilities stringDateForMusicDetailsDateString:review.inputDate];
    _praiseNumLabel.text = [@(review.praiseNum) stringValue];
    _scoreLabel.text = review.score;
    _contentLabel.text = review.content;
}

- (void)configureCellForCommonWithComment:(MLBComment *)comment atIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    [_userAvatarView mlb_sd_setImageWithURL:comment.user.webURL placeholderImageName:@"personal"];
    _usernameLabel.text = comment.user.username;
    _dateLabel.text = [MLBUtilities stringDateForMusicDetailsDateString:comment.inputDate];
    _praiseNumLabel.text = [@(comment.praiseNum) stringValue];
    _scoreLabel.text = comment.score;
    _replyContentLabel.text = comment.quote;
    _contentLabel.text = comment.content;
}

@end
