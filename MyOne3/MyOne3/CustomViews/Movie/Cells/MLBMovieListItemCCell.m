//
//  MLBMovieListItemCCell.m
//  MyOne3
//
//  Created by meilbn on 3/8/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBMovieListItemCCell.h"
#import "MLBMovieListItem.h"
#import "MLBScoreView.h"
#import "MZTimerLabel.h"

NSString *const kMLBMovieListItemCCellID = @"MLBMovieListItemCCellID";

@interface MLBMovieListItemCCell ()

@property (strong, nonatomic) UIImageView *coverView;
@property (strong, nonatomic) MLBScoreView *scoreView;
@property (strong, nonatomic) UILabel *comingSoonLabel;
@property (strong, nonatomic) MZTimerLabel *timerLabel;

@end

@implementation MLBMovieListItemCCell

+ (CGSize)cellSize {
    return  CGSizeMake(SCREEN_WIDTH, 140);
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _coverView.image = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    if (_coverView) {
        return;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    self.coverView.backgroundColor = [UIColor whiteColor];
    
    _coverView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        imageView;
    });
    
    _scoreView = ({
        MLBScoreView *view = [MLBScoreView new];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.contentView).offset(-10);
        }];
        
        view;
    });
    
    _comingSoonLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"即将上映";
        label.textColor = [UIColor colorWithWhite:85 / 255.0 alpha:1];// #555555
        label.font = FontWithSize(12);
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.contentView).offset(-6);
        }];
        label.hidden = YES;
        
        label;
    });
    
    _timerLabel = ({
        MZTimerLabel *label = [[MZTimerLabel alloc] initWithTimerType:MZTimerLabelTypeTimer];
        label.textColor = [UIColor colorWithWhite:85 / 255.0 alpha:1];// #555555
        label.font = FontWithSize(12);
        label.text = @"00:00:00";
        label.timeFormat = @"距离公布分数还剩：HH:mm:ss";
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.contentView).offset(-6);
        }];
        label.hidden = YES;
        
        label;
    });
}

#pragma mark - Public Method

- (void)configureCellWithMovieListItem:(MLBMovieListItem *)movieListItem atIndexPath:(NSIndexPath *)indexPath {
    NSString *placeholderImageName = [NSString stringWithFormat:@"movieList_placeholder_%ld", indexPath.row % 12];
    [_coverView mlb_sd_setImageWithURL:movieListItem.cover placeholderImageName:placeholderImageName];
    if (IsStringEmpty(movieListItem.score)) {
        _scoreView.hidden = YES;
        NSTimeInterval scoreDiffTimeInterval = [MLBUtilities diffTimeIntervalSinceNowToDateString:movieListItem.scoreTime];
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
        _scoreView.scoreLabel.text = movieListItem.score;
    }
}

- (void)stopCountDownIfNeeded {
    [_timerLabel pause];
    [_timerLabel reset];
}

@end
