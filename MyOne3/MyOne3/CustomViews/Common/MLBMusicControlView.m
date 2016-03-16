//
//  MLBMusicControlView.m
//  MyOne3
//
//  Created by meilbn on 3/16/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBMusicControlView.h"

@interface MLBMusicControlView ()

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UILabel *musicTitleLabel;
@property (strong, nonatomic) UIButton *previousButton;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) UIButton *playModeButton;
@property (strong, nonatomic) UIButton *addToListButton;
@property (strong, nonatomic) UIButton *lookupDetailsButton;

@end

@implementation MLBMusicControlView

#pragma mark - Class Method

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static MLBMusicControlView *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - LifeCycle

- (void)dealloc {
    DDLogDebug(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

#pragma mark - Private Method

- (void)setupViews {
    if (_contentView) {
        return;
    }
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
    
    _contentView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.99];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
        }];
        
        view;
    });
    
    UIView *topView = [UIView new];
    [_contentView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@66);
        make.left.top.right.equalTo(_contentView);
    }];
    
    _titleLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = MLBNavigationBarTitleTextColor;
        label.font = FontWithSize(18);
        label.text = @"ONE";
        [topView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(topView);
            make.bottom.equalTo(topView).offset(-10);
        }];
        
        label;
    });
    
    _progressView = ({
        UIProgressView *progressView = [UIProgressView new];
        progressView.progressTintColor = [UIColor colorWithRed:128 / 255.0 green:172 / 255.0 blue:225 / 255.0 alpha:1];
        progressView.trackTintColor = [UIColor whiteColor];
        [_contentView addSubview:progressView];
        [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@2);
            make.top.equalTo(topView.mas_bottom).offset(-2);
            make.left.right.equalTo(_contentView);
        }];
        
        progressView;
    });
    
    UIView *bottomView = [UIView new];
    [_contentView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@168);
        make.top.equalTo(_progressView.mas_bottom);
        make.left.bottom.right.equalTo(_contentView);
    }];
    
    _musicTitleLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"one";
        label.textColor = [UIColor colorWithRed:128 / 255.0 green:172 / 255.0 blue:225 / 255.0 alpha:1];
        label.font = FontWithSize(12);
        [bottomView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bottomView);
            make.top.equalTo(bottomView).offset(20);
        }];
        
        label;
    });
    
    _playButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"playerPause" selectedImageName:@"playerPlaying" target:self action:@selector(playButtonClicked)];
        [bottomView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.top.equalTo(_musicTitleLabel.mas_bottom).offset(20);
            make.centerX.equalTo(bottomView);
        }];
        
        button;
    });
    
    _previousButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"previous_normal" selectedImageName:@"previous_highlighted" target:self action:@selector(previousButtonClicked)];
        [bottomView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.top.equalTo(_playButton);
            make.right.equalTo(_playButton.mas_left).offset(-62);
        }];
        
        button;
    });
    
    _nextButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"next_nromal" selectedImageName:@"next_highlighted" target:self action:@selector(nextButtonClicked)];
        [bottomView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.top.equalTo(_playButton);
            make.left.equalTo(_playButton.mas_right).offset(62);
        }];
        
        button;
    });
    
    _playModeButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"player_single_cycle" selectedImageName:@"player_all_cycle" target:self action:@selector(playModeButtonClicked)];
        [bottomView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.left.equalTo(bottomView).offset(8);
            make.bottom.equalTo(bottomView).offset(-8);
        }];
        
        button;
    });
    
    _lookupDetailsButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"detail_content" selectedImageName:nil target:self action:@selector(lookupDetailsButtonClicked)];
        [bottomView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.right.bottom.equalTo(bottomView).offset(-8);
        }];
        
        button;
    });
    
    _addToListButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"music_collection" selectedImageName:nil target:self action:@selector(addToListButtonClicked)];
        [bottomView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.right.equalTo(_lookupDetailsButton.mas_left).offset(-10);
            make.bottom.equalTo(_lookupDetailsButton);
        }];
        
        button;
    });
}

#pragma mark - Action

- (void)playButtonClicked {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    _playButton.selected = !_playButton.isSelected;
}

- (void)previousButtonClicked {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
}

- (void)nextButtonClicked {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
}

- (void)playModeButtonClicked {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
    _playModeButton.selected = !_playModeButton.isSelected;
}

- (void)addToListButtonClicked {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
}

- (void)lookupDetailsButtonClicked {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
}

#pragma mark - Public Method

- (void)show {
    if (!self.superview) {
        self.alpha = 0;
        [kKeyWindow addSubview:self];
        [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 1;
        }];
    }
}

- (void)dismiss {
    if (self.superview) {
        [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

@end
