//
//  MLBMovieDetailsHeaderView.m
//  MyOne3
//
//  Created by meilbn on 2/28/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBMovieDetailsHeaderView.h"
#import "MZTimerLabel.h"
#import "MLBScoreView.h"
#import "MLBMovieDetails.h"

@interface MLBMovieDetailsHeaderView ()

@property (strong, nonatomic) UIImageView *coverView;
@property (strong, nonatomic) UIImageView *shadowView;
@property (strong, nonatomic) MLBScoreView *scoreView;
@property (strong, nonatomic) UILabel *comingSoonLabel;
@property (strong, nonatomic) MZTimerLabel *timerLabel;

@end

@implementation MLBMovieDetailsHeaderView

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
    if (_coverView) {
        return;
    }
    
    self.clipsToBounds = YES;
    
    _coverView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        imageView;
    });
    
    _shadowView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"movie_shadow"]];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@115);
            make.left.bottom.right.equalTo(self);
        }];
        
        imageView;
    });
    
    _scoreView = ({
        MLBScoreView *view = [MLBScoreView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self).offset(-10);
        }];
        view.hidden = YES;
        
        view;
    });
    
    _comingSoonLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.font = FontWithSize(12);
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self).offset(-6);
        }];
        
        label;
    });
    
    _timerLabel = ({
        MZTimerLabel *label = [[MZTimerLabel alloc] initWithTimerType:MZTimerLabelTypeTimer];
        label.textColor = [UIColor whiteColor];
        label.font = FontWithSize(12);
        label.text = @"00:00:00";
        label.timeFormat = @"距离公布分数还剩：HH:mm:ss";
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self).offset(-6);
        }];
        label.hidden = YES;
        
        label;
    });
}

#pragma mark - Public Method

- (void)configureViewWithMovieDetails:(MLBMovieDetails *)movieDetails {
    [_coverView mlb_sd_setImageWithURL:movieDetails.detailCover placeholderImageName:[NSString stringWithFormat:@"movieList_placeholder_%ld", ([movieDetails.movieId integerValue] % 12)]];
    _scoreView.hidden = NO;
    
    if (IsStringEmpty(movieDetails.score)) {
        _scoreView.hidden = YES;
        NSTimeInterval scoreDiffTimeInterval = [MLBUtilities diffTimeIntervalSinceNowToDateString:movieDetails.scoreTime];
        if (scoreDiffTimeInterval < 24 * 60 * 60) {
            _comingSoonLabel.hidden = YES;
            _timerLabel.hidden = NO;
            [_timerLabel setCountDownTime:scoreDiffTimeInterval];
            [_timerLabel start];
        } else {
            _comingSoonLabel.hidden = NO;
        }
    } else {
        _scoreView.hidden = NO;
        _comingSoonLabel.hidden = YES;
        _timerLabel.hidden = YES;
        _scoreView.scoreLabel.text = movieDetails.score;
    }
}

@end
