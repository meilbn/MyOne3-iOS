//
//  MLBRelatedMusicCell.m
//  MyOne3
//
//  Created by meilbn on 2/23/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBRelatedMusicCell.h"
#import "MLBRelatedMusic.h"

NSString *const kMLBRelatedMusicCellID = @"MLBRelatedMusicCellID";

@interface MLBRelatedMusicCell ()

@property (strong, nonatomic) UIImageView *albumView;
@property (strong, nonatomic) UIImageView *coverView;
@property (strong, nonatomic) UILabel *musicNameLabel;
@property (strong, nonatomic) UILabel *authorNameLabel;
@property (strong, nonatomic) UIImageView *forwardInfoView;

@end

@implementation MLBRelatedMusicCell

+ (CGFloat)cellHeight {
    return 60.0;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _albumView.image = nil;
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
    if (_albumView) {
        return;
    }
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _albumView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@48);
            make.centerY.equalTo(self.contentView).offset(-2);
            make.left.equalTo(self.contentView).offset(12);
        }];
        
        imageView;
    });
    
    _musicNameLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = [UIColor colorWithWhite:72 / 255.0 alpha:1];// #484848
        label.font = FontWithSize(16);
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_albumView).offset(3);
            make.left.equalTo(_albumView.mas_right).offset(6);
        }];
        
        label;
    });
    
    _authorNameLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = MLBAppThemeColor;
        label.font = FontWithSize(12);
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_musicNameLabel.mas_bottom).offset(5);
            make.left.right.equalTo(_musicNameLabel);
        }];
        
        label;
    });
    
    _coverView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"music_cover_light"];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.opaque = YES;
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(62, 56));
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(6);
        }];
        
        imageView;
    });
    
    _forwardInfoView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"forward_info"];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(6, 10));
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-24);
            make.left.equalTo(_musicNameLabel.mas_right).offset(6);
        }];
        
        imageView;
    });
}

#pragma mark - Public Method

- (void)configureCellWithRelatedMusic:(MLBRelatedMusic *)relatedMusic atIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    [_albumView mlb_sd_setImageWithURL:relatedMusic.cover placeholderImageName:@"center_cd_cover"];
    _musicNameLabel.text = relatedMusic.title;
    _authorNameLabel.text = relatedMusic.author.username;
}

@end
