//
//  MLBMoviePosterCCell.m
//  MyOne3
//
//  Created by meilbn on 3/8/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBMoviePosterCCell.h"

NSString *const kMLBMoviePosterCCellID = @"kMLBMoviePosterCCellID";

@interface MLBMoviePosterCCell ()

@property (strong, nonatomic) UIImageView *posterView;

@end

@implementation MLBMoviePosterCCell

- (void)prepareForReuse {
    [super prepareForReuse];
    _posterView.image = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    if (_posterView) {
        return;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _posterView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        imageView;
    });
}

#pragma mark - Public Method

- (void)configureCellWithPostURL:(NSString *)posterURL {
    [_posterView mlb_sd_setImageWithURL:posterURL placeholderImageName:nil];
}

@end
