//
//  MLBMovieListItemCell.m
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBMovieListItemCell.h"
#import "MLBMovieListItem.h"

NSString *const kMLBMovieListItemCellID = @"MLBMovieListItemCellID";

@interface MLBMovieListItemCell ()

@property (strong, nonatomic) UIImageView *coverView;
@property (strong, nonatomic) UIView *scoreView;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UIImageView *scoreBottomLine;

@end

@implementation MLBMovieListItemCell

- (void)prepareForReuse {
    _coverView.image = nil;
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
    if (!_coverView) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor clearColor];
            view.transform = CGAffineTransformMake(0.97, -0.242, 0.242, 0.97, 0, 0);
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.equalTo(self.contentView).offset(-10);
            }];
            
            view;
        });
        
        _scoreLabel = ({
            UILabel *label = [UILabel new];
            label.textColor = MLBScoreTextColor;
            label.font = ScoreFontWithSize(48);
            label.textAlignment = NSTextAlignmentCenter;
            [_scoreView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@60);
                make.top.greaterThanOrEqualTo(_scoreView);
            }];
            
            label;
        });
        
        _scoreBottomLine = ({
            UIImageView *imageView = [UIImageView new];
            imageView.image = [UIImage imageNamed:@"redline"];
            [_scoreView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.sizeOffset(CGSizeMake(81, 5));
                make.top.equalTo(_scoreLabel.mas_bottom);
                make.left.bottom.right.equalTo(_scoreView);
                make.centerX.equalTo(_scoreLabel);
            }];
            
            imageView;
        });
    }
}

#pragma mark - Public Method

+ (CGFloat)cellHight {
    return 140;
}

- (void)configureCellWithMovieListItem:(MLBMovieListItem *)movieListItem atIndexPath:(NSIndexPath *)indexPath {
    NSString *placeholderImageName = [NSString stringWithFormat:@"movieList_placeholder_%ld", indexPath.row % 12];
    [_coverView mlb_sd_setImageWithURL:movieListItem.cover placeholderImageName:placeholderImageName];
    _scoreLabel.text = movieListItem.score;
}

@end
