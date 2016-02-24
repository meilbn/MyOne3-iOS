//
//  MLBHomeView.m
//  MyOne3
//
//  Created by meilbn on 2/22/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBHomeView.h"
#import "MLBHomeItem.h"

NSString *const kMLBHomeViewID = @"MLBHomeViewID";

@interface MLBHomeView ()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *diaryButton;
@property (strong, nonatomic) UIButton *likeButton;
@property (strong, nonatomic) UILabel *likeNumLabel;
@property (strong, nonatomic) UIButton *moreButton;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *coverView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *weatherView;
@property (strong, nonatomic) UILabel *temperatureLabel;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UITextView *contentTextView;
@property (strong, nonatomic) UILabel *volLabel;

@property (strong, nonatomic) MASConstraint *textViewHeightConstraint;

@end

@implementation MLBHomeView {
    NSInteger viewIndex;
}

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
    if (!_scrollView) {
        self.backgroundColor = [UIColor clearColor];
        
        _scrollView = ({
            UIScrollView *scrollView = [UIScrollView new];
            scrollView.showsVerticalScrollIndicator = NO;
            [self addSubview:scrollView];
            [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
            scrollView;
        });
        
        _diaryButton = ({
            UIButton *button = [MLBUIFactory buttonWithImageName:nil highlightImageName:nil target:self action:@selector(diaryButtonClicked)];
            [_scrollView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.sizeOffset(CGSizeMake(66, 44));
                make.left.equalTo(_scrollView).offset(8);
                make.bottom.equalTo(_scrollView).offset(-25);
            }];
            
            button;
        });
        
        _moreButton = ({
            UIButton *button = [MLBUIFactory buttonWithImageName:nil highlightImageName:nil target:self action:@selector(moreButtonClicked)];
            [_scrollView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@44);
                make.right.equalTo(_scrollView).offset(-8);
                make.bottom.equalTo(_scrollView).offset(-25);
            }];
            
            button;
        });
        
        _likeNumLabel = ({
            UILabel *label = [UILabel new];
            [_scrollView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@44);
                make.right.equalTo(_moreButton.mas_left);
                make.bottom.equalTo(_scrollView).offset(-25);
            }];
            
            label;
        });
        
        _likeButton = ({
            UIButton *button = [MLBUIFactory buttonWithImageName:nil highlightImageName:nil target:self action:@selector(likeButtonClicked)];
            [_scrollView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@44);
                make.right.equalTo(_likeNumLabel.mas_left);
                make.bottom.equalTo(_scrollView).offset(-25);
            }];
            
            button;
        });
        
        _contentView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor whiteColor];
            view.layer.shadowColor = MLBShadowColor.CGColor;// #666666
            view.layer.shadowRadius = 2;
            view.layer.shadowOffset = CGSizeZero;
            view.layer.shadowOpacity = 0.5;
            view.layer.cornerRadius = 5;
            [_scrollView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(_scrollView).insets(UIEdgeInsetsMake(12, 12, 135, 12));
                make.width.equalTo(@(SCREEN_WIDTH - 24));
            }];
            
            view;
        });
        
        _coverView = ({
            UIImageView *imageView = [UIImageView new];
            imageView.backgroundColor = [UIColor whiteColor];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [_contentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(_contentView).insets(UIEdgeInsetsMake(6, 6, 0, 6));
                make.height.equalTo(imageView.mas_width).multipliedBy(0.75);
            }];
            
            imageView;
        });
        
        _titleLabel = ({
            UILabel *label = [UILabel new];
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = MLBGrayTextColor;
            label.font = FontWithSize(10);
            label.textAlignment = NSTextAlignmentRight;
            [_contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_coverView.mas_bottom).offset(8);
                make.left.right.equalTo(_coverView);
            }];
            
            label;
        });
        
        _weatherView = ({
            UIImageView *imageView = [UIImageView new];
            imageView.backgroundColor = [UIColor whiteColor];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [_contentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@24);
                make.top.equalTo(_titleLabel.mas_bottom).offset(30);
                make.left.equalTo(_coverView);
            }];
            
            imageView;
        });
        
        _temperatureLabel = ({
            UILabel *label = [UILabel new];
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = MLBDarkGrayTextColor;
            label.font = FontWithSize(24);
            [_contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(_weatherView);
                make.left.equalTo(_weatherView.mas_right).offset(10);
            }];
            
            label;
        });
        
        _locationLabel = ({
            UILabel *label = [UILabel new];
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = MLBDarkGrayTextColor;
            label.font = FontWithSize(12);
            [_contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_temperatureLabel.mas_right);
                make.bottom.equalTo(_temperatureLabel);
            }];
            
            label;
        });
        
        _dateLabel = ({
            UILabel *label = [UILabel new];
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = MLBDarkGrayTextColor;
            label.font = FontWithSize(12);
            [_contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.greaterThanOrEqualTo(_locationLabel.mas_right);
                make.right.equalTo(_coverView);
                make.bottom.equalTo(_locationLabel);
            }];
            
            label;
        });
        
        _contentTextView = ({
            UITextView *textView = [UITextView new];
            textView.backgroundColor = [UIColor whiteColor];
            textView.textColor = MLBLightBlackTextColor;
            textView.font = FontWithSize(14);
            textView.editable = NO;
            [_contentView addSubview:textView];
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_dateLabel.mas_bottom).offset(10);
                make.left.right.equalTo(_coverView);
                _textViewHeightConstraint = make.height.equalTo(@0);
            }];
            
            textView;
        });
        
        _volLabel = ({
            UILabel *label = [UILabel new];
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = MLBLightGrayTextColor;
            label.font = FontWithSize(11);
            [_contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_contentTextView.mas_bottom).offset(30);
                make.right.equalTo(_contentTextView);
                make.bottom.equalTo(_contentView).offset(-12);
            }];
            
            label;
        });
    }
}

- (void)diaryButtonClicked {
    
}

- (void)likeButtonClicked {
    
}

- (void)moreButtonClicked {
    
}

#pragma mark - Public Method

- (void)configureViewWithHomeItem:(MLBHomeItem *)homeItem atIndex:(NSInteger)index {
    viewIndex = index;
    [_coverView mlb_sd_setImageWithURL:homeItem.imageURL placeholderImageName:@"home_cover_placeholder"];
    _titleLabel.text = homeItem.authorName;
    _weatherView.image = [UIImage imageNamed:@"light_rain"];
    _temperatureLabel.text = @"6";
    _locationLabel.text = @"℃ 杭州";
    _dateLabel.text = [MLBUtilities stringDateFormatWithddMMMyyyyEEEByNormalDateString:homeItem.makeTime];
    _contentTextView.text = homeItem.content;
    CGFloat textHeight = [homeItem.content mlb_heightWithFont:_contentTextView.font width:(SCREEN_WIDTH - 24 - 12)];
    _textViewHeightConstraint.equalTo(@(textHeight + 25));
    _volLabel.text = homeItem.title;
    _scrollView.contentOffset = CGPointZero;
}

@end
