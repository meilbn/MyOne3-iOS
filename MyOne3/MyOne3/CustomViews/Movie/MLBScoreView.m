//
//  MLBScoreView.m
//  MyOne3
//
//  Created by meilbn on 2/28/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBScoreView.h"

@interface MLBScoreView ()

@property (strong, nonatomic) UIImageView *scoreBottomLine;

@end

@implementation MLBScoreView

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
    if (_scoreLabel) {
        return;
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.transform = CGAffineTransformMake(0.97, -0.242, 0.242, 0.97, 0, 0);
    
    _scoreLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = MLBScoreTextColor;
        label.font = ScoreFontWithSize(48);
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@60);
            make.top.greaterThanOrEqualTo(self);
        }];
        
        label;
    });
    
    _scoreBottomLine = ({
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"redline"];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(81, 5));
            make.top.equalTo(_scoreLabel.mas_bottom);
            make.left.bottom.right.equalTo(self);
            make.centerX.equalTo(_scoreLabel);
        }];
        
        imageView;
    });
}

@end
