//
//  MLBMusicView.m
//  MyOne3
//
//  Created by meilbn on 2/22/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBMusicView.h"
#import "MLBMusicDetails.h"
#import "MLBCommentList.h"
#import "MLBRelatedMusic.h"
#import <YYText/YYText.h>
#import "MLBCommentCell.h"
#import "MLBNoneMessageCell.h"
#import "MLBRelatedMusicCell.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "MLBBaseViewController.h"
#import "MLBCommentListViewController.h"
#import "MLBMusicRelatedViewController.h"

NSString *const kMLBMusicViewID = @"MLBMusicViewID";

typedef NS_ENUM(NSUInteger, MLBMusicDetailsType) {
    MLBMusicDetailsTypeNone,
    MLBMusicDetailsTypeStory,
    MLBMusicDetailsTypeLyric,
    MLBMusicDetailsTypeInfo,
};

@interface MLBMusicView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *coverView;
@property (strong, nonatomic) UIView *storyTitleView;
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
@property (strong, nonatomic) UIView *bottomLineView;
@property (strong, nonatomic) UILabel *storyTitleLabel;
@property (strong, nonatomic) UILabel *storyAuthorNameLabel;
@property (strong, nonatomic) YYTextView *contentTextView;
@property (strong, nonatomic) UIView *chargeEditorView;
@property (strong, nonatomic) UILabel *editorLabel;
@property (strong, nonatomic) UIButton *likeButton;
@property (strong, nonatomic) UILabel *likeNumLabel;
@property (strong, nonatomic) UIButton *moreButton;
@property (strong, nonatomic) MLBCommentListViewController *commentListViewController;
@property (strong, nonatomic) UITableView *relatedMusicTableView;
@property (strong, nonatomic) MLBCommonHeaderView *relatedMusicHeaderView;
@property (strong, nonatomic) MLBCommonFooterView *relatedMusicFooterView;

@property (strong, nonatomic) MASConstraint *authorViewTopConstraint;
@property (strong, nonatomic) MASConstraint *contentTextViewHeightConstraint;
@property (strong, nonatomic) MASConstraint *contentTextViewTopToAuthorNameLabelBottomConstraint;
@property (strong, nonatomic) MASConstraint *contentTextViewTopToStoryTitleViewBottomConstraint;
@property (strong, nonatomic) MASConstraint *chargeEditorHeightConstraint;
@property (strong, nonatomic) MASConstraint *commentsTableViewHeightConstraint;
@property (strong, nonatomic) MASConstraint *relatedMusicTableViewHeightConstraint;

@property (copy, nonatomic) NSString *musicId;

@end

@implementation MLBMusicView {
    NSArray *typeButtons;
    MLBMusicDetails *musicDetails;
    NSInteger initStatusContentOffsetY;
    MLBCommentList *commentList;
    NSArray *relatedMusics;
    NSMutableArray *commentRowsHeight;
    BOOL preparedForReuse;
}

#pragma mark - LifeCycle

- (void)dealloc {
    [_commentListViewController removeFromParentViewController];
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configure];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self configure];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self configure];
    }
    
    return self;
}

#pragma mark - Private Method

- (void)configure {
    [self initDatas];
    [self setupViews];
}

- (void)initDatas {
    initStatusContentOffsetY = [@(ceil(SCREEN_WIDTH * 0.6)) integerValue];
    commentRowsHeight = @[].mutableCopy;
    preparedForReuse = NO;
}

- (void)setupViews {
    if (_scrollView) {
        return;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    
    _scrollView = ({
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.backgroundColor = MLBViewControllerBGColor;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        scrollView;
    });
    
    _contentView = ({
        UIView *view = [UIView new];
        view.backgroundColor = _scrollView.backgroundColor;
        [_scrollView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_scrollView);
            make.width.equalTo(@(SCREEN_WIDTH));
        }];
        
        view;
    });
    
    _coverView = ({
        UIImageView *imageView = [UIImageView new];
        [_contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(_contentView);
            make.height.equalTo(imageView.mas_width).multipliedBy(1);
        }];
        
        imageView;
    });
    
    _storyTitleView = ({
        UIView *view = [UIView new];
        view.backgroundColor = MLBViewControllerBGColor;
        [_contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_coverView.mas_bottom);
            make.left.right.equalTo(_contentView);
        }];
        
        view;
    });
    
    _aboutButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"music_about_normal" selectedImageName:@"music_about_selected" target:self action:@selector(typeButtonClicked:)];
        button.tag = MLBMusicDetailsTypeInfo;
        [_storyTitleView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(44, 44));
            make.right.equalTo(_storyTitleView);
            make.bottom.equalTo(_storyTitleView).offset(4);
        }];
        
        button;
    });
    
    _lyricButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"music_lyric_normal" selectedImageName:@"music_lyric_selected" target:self action:@selector(typeButtonClicked:)];
        button.tag = MLBMusicDetailsTypeLyric;
        [_storyTitleView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(_aboutButton);
            make.right.equalTo(_aboutButton.mas_left).offset(-20);
            make.bottom.equalTo(_aboutButton);
        }];
        
        button;
    });
    
    _storyButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"music_story_normal" selectedImageName:@"music_story_selected" target:self action:@selector(typeButtonClicked:)];
        button.tag = MLBMusicDetailsTypeStory;
        [_storyTitleView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(_aboutButton);
            make.right.equalTo(_lyricButton.mas_left).offset(-20);
            make.bottom.equalTo(_aboutButton);
        }];
        
        button;
    });
    
    typeButtons = @[_storyButton, _lyricButton, _aboutButton];
    
    _contentTypeLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"音乐故事";
        label.textColor = [UIColor colorWithWhite:127 / 255.0 alpha:1];// #7F7F7F
        label.font = FontWithSize(12);
        [_storyTitleView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_storyTitleView).offset(12);
            make.bottom.equalTo(_storyTitleView).offset(-8);
        }];
        
        label;
    });
    
    _bottomLineView = ({
        UIView *view = [MLBUIFactory separatorLine];
        [_storyTitleView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
            make.left.bottom.right.equalTo(_storyTitleView).insets(UIEdgeInsetsMake(0, 6, 0, 6));
        }];
        
        view;
    });
    
    _authorView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.shadowColor = MLBShadowColor.CGColor;
        view.layer.shadowOffset = CGSizeZero;
        view.layer.shadowRadius = 2;
        view.layer.shadowOpacity = 0.5;
        view.layer.cornerRadius = 2;
        [_storyTitleView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_storyTitleView).offset(12);
            make.right.equalTo(_storyTitleView).offset(-12);
            make.height.equalTo(_storyTitleView).multipliedBy(0.7746);
            _authorViewTopConstraint = make.top.equalTo(_storyTitleView).offset(-12);
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
            make.left.top.equalTo(_authorView).offset(12);
            make.width.height.equalTo(@48);
        }];
        
        imageView;
    });
    
    _firstPublishView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = [UIColor whiteColor];
        [_authorView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_authorAvatarView);
            make.right.equalTo(_authorView).offset(-8);
        }];
        
        imageView;
    });
    
    _authorNameLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = MLBAppThemeColor;
        label.font = FontWithSize(12);
        [_authorView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_authorAvatarView).offset(6);
            make.left.equalTo(_authorAvatarView.mas_right).offset(12);
            
        }];
        
        label;
    });
    
    _authorDescLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = MLBLightGrayTextColor;
        label.font = FontWithSize(12);
        [_authorView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_authorNameLabel.mas_bottom).offset(4);
            make.left.equalTo(_authorNameLabel);
        }];
        
        label;
    });
    
    _titleLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = MLBLightBlackTextColor;
        label.font = FontWithSize(20);
        label.numberOfLines = 0;
        [_authorView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_authorAvatarView);
            make.top.equalTo(_authorAvatarView.mas_bottom).offset(20);
            make.bottom.equalTo(_authorView).offset(-18);
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
            make.right.bottom.equalTo(_authorView).offset(-8);
            make.left.greaterThanOrEqualTo(_titleLabel.mas_right).offset(8);
        }];
        
        label;
    });
    
    _musicControlButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"play_normal" highlightImageName:@"play_highlighted" target:self action:@selector(controlStoryMusicPlay)];
        [_authorView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.right.equalTo(_authorView).offset(-10);
            make.bottom.equalTo(_dateLabel.mas_top).offset(-8);
        }];
        
        button;
    });
    
    _storyTitleLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = MLBLightBlackTextColor;
        label.font = FontWithSize(18);
        label.numberOfLines = 0;
        [_contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentView).offset(12);
            make.right.lessThanOrEqualTo(_contentView).offset(-12);
            make.top.equalTo(_storyTitleView.mas_bottom).offset(20);
        }];
        
        label;
    });
    
    _storyAuthorNameLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = MLBAppThemeColor;
        label.font = FontWithSize(12);
        [_contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_storyTitleLabel.mas_bottom).offset(12);
            make.left.equalTo(_storyTitleLabel);
            make.right.lessThanOrEqualTo(_contentView).offset(-12);
        }];
        
        label;
    });
    
    _contentTextView = ({
        YYTextView *textView = [YYTextView new];
        textView.backgroundColor = MLBViewControllerBGColor;
        textView.textColor = MLBDarkBlackTextColor;
        textView.font = FontWithSize(15);
        textView.editable = NO;
        textView.scrollEnabled = NO;
        textView.showsVerticalScrollIndicator = NO;
        textView.showsHorizontalScrollIndicator = NO;
        [_contentView addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            _contentTextViewTopToAuthorNameLabelBottomConstraint = make.top.equalTo(_storyAuthorNameLabel.mas_bottom).offset(10);
            _contentTextViewTopToStoryTitleViewBottomConstraint = make.top.equalTo(_storyTitleView.mas_bottom).offset(10).priority(999);
            make.left.equalTo(_contentView).offset(6);
            make.right.equalTo(_contentView).offset(-6);
            _contentTextViewHeightConstraint = make.height.equalTo(@0);
        }];
        
        textView;
    });
    
    _chargeEditorView = ({
        UIView *view = [UIView new];
        view.backgroundColor = MLBViewControllerBGColor;
        view.clipsToBounds = YES;
        [_contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            _chargeEditorHeightConstraint = make.height.equalTo(@75);
            make.top.equalTo(_contentTextView.mas_bottom);
            make.left.right.equalTo(_contentView);
        }];
        
        view;
    });
    
    _moreButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"more_normal" highlightImageName:@"more_highlighted" target:self action:@selector(moreButtonClicked)];
        [_chargeEditorView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.right.equalTo(_chargeEditorView).offset(-8);
            make.centerY.equalTo(_chargeEditorView);
        }];
        
        button;
    });
    
    _likeNumLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = MLBDarkGrayTextColor;
        label.font = FontWithSize(12);
        [label setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
        [_chargeEditorView insertSubview:label atIndex:2];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_moreButton.mas_left).offset(-10);
            make.centerY.equalTo(_chargeEditorView);
        }];
        
        label;
    });
    
    _likeButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"like_normal" selectedImageName:@"like_selected" target:self action:@selector(likeButtonClicked)];
        [_chargeEditorView insertSubview:button atIndex:3];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.right.equalTo(_likeNumLabel.mas_left);
            make.centerY.equalTo(_chargeEditorView);
        }];
        
        button;
    });
    
    _editorLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = MLBDarkGrayTextColor;
        label.font = FontWithSize(12);
        label.numberOfLines = 0;
        [_chargeEditorView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_chargeEditorView).offset(12);
            make.right.lessThanOrEqualTo(_likeButton.mas_left).offset(8);
            make.centerY.equalTo(_chargeEditorView);
        }];
        
        label;
    });
    
    __weak typeof(self) weakSelf = self;
    _commentListViewController = [[MLBCommentListViewController alloc] initWithCommentListType:MLBCommentListTypeMusicComments headerViewType:MLBHeaderViewTypeComment footerViewType:MLBFooterViewTypeComment];
    _commentListViewController.finishedCalculateHeight = ^(CGFloat height) {
        weakSelf.commentsTableViewHeightConstraint.equalTo(@(height));
    };
    [_contentView addSubview:_commentListViewController.tableView];
    [_commentListViewController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_chargeEditorView.mas_bottom);
        make.left.right.equalTo(_contentView);
        _commentsTableViewHeightConstraint = make.height.equalTo(@0);
    }];
    
    _relatedMusicTableView = ({
        UITableView *tableView = [UITableView new];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.scrollEnabled = NO;
        [tableView registerClass:[MLBRelatedMusicCell class] forCellReuseIdentifier:kMLBRelatedMusicCellID];
        tableView.tableFooterView = [UIView new];
        tableView.separatorInset = UIEdgeInsetsMake(0, 65, 0, 0);
        tableView.separatorColor = MLBSeparatorColor;
        [_contentView addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_commentListViewController.tableView.mas_bottom).offset(5);
            make.left.right.equalTo(_contentView);
            make.bottom.equalTo(_contentView).offset(-12);
            _relatedMusicTableViewHeightConstraint = make.height.equalTo(@0);
        }];
        
        tableView;
    });
    
//        MASAttachKeys(_scrollView, _contentView, _coverView, _storyTitleView, _authorView, _authorAvatarView, _authorNameLabel, _firstPublishView, _authorDescLabel, _titleLabel, _dateLabel, _musicControlButton, _contentTypeLabel, _storyButton, _lyricButton, _aboutButton, _bottomLineView, _storyAuthorNameLabel, _contentTextView, _chargeEditorView, _editorLabel, _likeButton, _likeNumLabel, _moreButton, _commentsTableView, _relatedMusicTableView);
}

- (void)resetMusicPlay {
    [_musicControlButton setImage:[UIImage imageNamed:@"play_normal"] forState:UIControlStateNormal];
    [_musicControlButton setImage:[UIImage imageNamed:@"play_highlighted"] forState:UIControlStateHighlighted];
}

- (void)resetMusicListControlButtonWithPlaying:(BOOL)playing {
//    [_relatedMusicControlButton setImage:[UIImage imageNamed:playing ? @"music_list_pause_normal" : @"music_list_play_normal"] forState:UIControlStateNormal];
//    [_relatedMusicControlButton setImage:[UIImage imageNamed:playing ? @"music_list_pause_highlighted" : @"music_list_play_highlighted"] forState:UIControlStateHighlighted];
}

- (void)updateViews {
    [_coverView mlb_sd_setImageWithURL:musicDetails.cover placeholderImageName:@"music_cover_small"];
    [_authorAvatarView mlb_sd_setImageWithURL:musicDetails.author.webURL placeholderImageName:@"personal"];
    _authorNameLabel.text = musicDetails.author.username;
    _authorDescLabel.text = musicDetails.author.desc;
    _titleLabel.text = musicDetails.title;
    _dateLabel.text = [MLBUtilities stringDateForMusicDetailsDateString:musicDetails.makeTime];
    _firstPublishView.image = [self firstPublishImage];
    _storyButton.selected = YES;
    _storyTitleLabel.text = musicDetails.storyTitle;
    _storyAuthorNameLabel.text = musicDetails.storyAuthor.username;
    [self showContentWithType:MLBMusicDetailsTypeStory];
    _chargeEditorHeightConstraint.equalTo(@75);
    _editorLabel.text = musicDetails.chargeEditor;
    _likeNumLabel.text = [@(musicDetails.praiseNum) stringValue];
}

- (UIImage *)firstPublishImage {
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

- (void)showContentWithType:(MLBMusicDetailsType)type {
    for (UIButton *button in typeButtons) {
        button.selected = button.tag == type;
    }
    
    switch (type) {
        case MLBMusicDetailsTypeNone: {
            _contentTypeLabel.text = @"音乐故事";
            [self updateContentTextViewTopCpnstraintWithShowStoryTitleAndAuthor:NO];
            break;
        }
        case MLBMusicDetailsTypeStory: {
            _contentTypeLabel.text = @"音乐故事";
            [self updateContentTextViewTopCpnstraintWithShowStoryTitleAndAuthor:YES];
            [self updateContentTextViewWithText:musicDetails.story htmlString:YES];
            break;
        }
        case MLBMusicDetailsTypeLyric: {
            _contentTypeLabel.text = @"歌词";
            [self updateContentTextViewTopCpnstraintWithShowStoryTitleAndAuthor:NO];
            [self updateContentTextViewWithText:musicDetails.lyric htmlString:NO];
            break;
        }
        case MLBMusicDetailsTypeInfo: {
            _contentTypeLabel.text = @"歌曲信息";
            [self updateContentTextViewTopCpnstraintWithShowStoryTitleAndAuthor:NO];
            [self updateContentTextViewWithText:musicDetails.info htmlString:NO];
            break;
        }
    }
}

- (void)updateContentTextViewWithText:(NSString *)text htmlString:(BOOL)isHTML {
    NSMutableAttributedString *attributedString;
    if (isHTML) {
        attributedString = [[NSMutableAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding]
                                                                     options:@{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType }
                                                          documentAttributes:nil
                                                                       error:nil];
    } else {
        attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    }
    
    attributedString.yy_font = _contentTextView.font;
    attributedString.yy_color = _contentTextView.textColor;
    attributedString.yy_lineSpacing = 10;
    
    _contentTextView.attributedText = attributedString;
    _contentTextViewHeightConstraint.equalTo(@(_contentTextView.textLayout.textBoundingSize.height));
}

- (void)updateContentTextViewTopCpnstraintWithShowStoryTitleAndAuthor:(BOOL)show {
    if (show) {
        [_contentTextViewTopToStoryTitleViewBottomConstraint uninstall];
        [_contentTextViewTopToAuthorNameLabelBottomConstraint install];
    } else {
        [_contentTextViewTopToStoryTitleViewBottomConstraint install];
        [_contentTextViewTopToAuthorNameLabelBottomConstraint uninstall];
    }
}

- (void)updateRelatedMusicsTableView {
    NSInteger tableViewHeight = ceil([MLBRelatedMusicCell cellHeight] * relatedMusics.count + [MLBCommonHeaderView headerViewHeight] + [MLBCommonFooterView footerViewHeightForShadow]);
    _relatedMusicTableViewHeightConstraint.equalTo(@(relatedMusics.count > 0 ? tableViewHeight : 0));
    [_relatedMusicTableView reloadData];
}

#pragma mark - Action

- (void)controlStoryMusicPlay {
    
}

- (void)controlRelatedMusicPlay {
    
}

- (void)typeButtonClicked:(UIButton *)sender {
    if (!sender.selected) {
        [self showContentWithType:(MLBMusicDetailsType)sender.tag];
    }
}

- (void)moreButtonClicked {
    if (self.parentViewController) {
        [self.parentViewController showPopMenuViewWithMenuSelectedBlock:^(MLBPopMenuType menuType) {
            DDLogDebug(@"menuType = %ld", menuType);
        }];
    }
}

- (void)likeButtonClicked {
    
}

- (void)addNewComment {
    
}

- (void)allComments {
    
}

#pragma mark - Public Method

- (void)prepareForReuse {
    if (preparedForReuse) {
        return;
    }
    
    _coverView.image = [UIImage imageNamed:@"music_cover"];
    _authorAvatarView.image = [UIImage imageNamed:@"personal"];
    _authorNameLabel.text = @"";
    _authorDescLabel.text = @"";
    _titleLabel.text = @" ";
    _dateLabel.text = @"";
    _firstPublishView.image = nil;
    [self resetMusicPlay];
    [self showContentWithType:MLBMusicDetailsTypeNone];
    _storyTitleLabel.text = @"";
    _storyAuthorNameLabel.text = @"";
    _contentTextView.text = @"";
    _contentTextView.attributedText = nil;
    _contentTextViewHeightConstraint.equalTo(@(SCREEN_HEIGHT * 0.6));
    _chargeEditorHeightConstraint.equalTo(@0);
    if (_scrollView.contentSize.width == 0 && _scrollView.contentSize.height == 0) {
        // MusicView 初始化之后，_scrollView.contentSize 为 CGSizeZero, 设置 contentOffset 无效，所以先设置一个初始状态的 contentSize，使下面设置 contentOffset 生效
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 1.5);
    }
    _scrollView.contentOffset = CGPointMake(0, initStatusContentOffsetY);
    _commentsTableViewHeightConstraint.equalTo(@0);
    _relatedMusicTableViewHeightConstraint.equalTo(@0);
    
    preparedForReuse = YES;
}

- (void)configureViewWithMusicId:(NSString *)musicId atIndex:(NSInteger)index {
    [self configureViewWithMusicId:musicId atIndex:index inViewController:nil];
}

- (void)configureViewWithMusicId:(NSString *)musicId atIndex:(NSInteger)index inViewController:(MLBBaseViewController *)parentViewController {
    self.viewIndex = index;
    _musicId = musicId;
    self.parentViewController = parentViewController;
    [self requestMusicDetails];
    [_commentListViewController configureViewForMusicDetailsWithItemId:_musicId];
    [self.parentViewController addChildViewController:_commentListViewController];
    [_commentListViewController requestDatas];
    
    [self requestMusicRelatedMusics];
    preparedForReuse = NO;
}

#pragma mark - Network Request

- (void)requestMusicDetails {
    [MLBHTTPRequester requestMusicDetailsById:_musicId success:^(id responseObject) {
        if ([responseObject[@"res"] integerValue] == 0) {
            NSError *error;
            MLBMusicDetails *details = [MTLJSONAdapter modelOfClass:[MLBMusicDetails class] fromJSONDictionary:responseObject[@"data"] error:&error];
            if (!error) {
                musicDetails = details;
                [self updateViews];
            } else {
                // callback
            }
        } else {
            // callback
        }
    } fail:^(NSError *error) {
        // callback
    }];
}

// 看返回结果应该最多是3首
- (void)requestMusicRelatedMusics {
    [MLBHTTPRequester requestMusicDetailsRelatedMusicsById:_musicId success:^(id responseObject) {
        if ([responseObject[@"res"] integerValue] == 0) {
            NSError *error;
            NSArray *musics = [MTLJSONAdapter modelsOfClass:[MLBRelatedMusic class] fromJSONArray:responseObject[@"data"] error:&error];
            if (!error) {
                relatedMusics = musics;
                [self updateRelatedMusicsTableView];
            } else {
                // callback
            }
        } else {
            // callback
        }
    } fail:^(NSError *error) {
        // callback
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint contentOffset = scrollView.contentOffset;
    if (contentOffset.y >= 0 && contentOffset.y <= initStatusContentOffsetY) {
        CGFloat distanceRatio = contentOffset.y / initStatusContentOffsetY;
        CGFloat topOffset = (distanceRatio * -(12 + 12)) + 12;
        _authorViewTopConstraint.offset(topOffset);
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return relatedMusics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:kMLBRelatedMusicCellID forIndexPath:indexPath];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [MLBCommonHeaderView headerViewHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [MLBCommonFooterView footerViewHeightForShadow];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MLBRelatedMusicCell cellHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!_relatedMusicHeaderView) {
        _relatedMusicHeaderView = [[MLBCommonHeaderView alloc] initWithHeaderViewType:MLBHeaderViewTypeRelatedMusic];
    }
    
    return _relatedMusicHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (!_relatedMusicFooterView) {
        _relatedMusicFooterView = [[MLBCommonFooterView alloc] initWithFooterViewType:MLBFooterViewTypeShadow];
    }
    
    return _relatedMusicFooterView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
        [(MLBRelatedMusicCell *)cell configureCellWithRelatedMusic:relatedMusics[indexPath.row] atIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MLBRelatedMusic *music = relatedMusics[indexPath.row];
    MLBMusicRelatedViewController *musicRelatedViewController = [[MLBMusicRelatedViewController alloc] init];
    musicRelatedViewController.relatedMusic = music;
    [self.parentViewController.navigationController pushViewController:musicRelatedViewController animated:YES];
}

@end
