//
//  MLBSearchPictureCell.m
//  MyOne3
//
//  Created by meilbn on 4/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBSearchPictureCell.h"
#import "MLBHomeItem.h"

NSString *const kMLBSearchPictureCellID = @"MLBSearchPictureCellID";

@interface MLBSearchPictureCell ()

@property (strong, nonatomic) UIImageView *coverView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation MLBSearchPictureCell

#pragma mark - Class Method

+ (CGFloat)cellHeight {
    return 64;
}

#pragma mark - View Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _coverView.image = nil;
}

#pragma mark - Private Method

- (void)setupViews {
    if (_coverView) {
        return;
    }
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _coverView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(65, 48));
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(8);
        }];
        
        imageView;
    });
    
    _titleLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor whiteColor];
        label.font = FontWithSize(13);
        label.textColor = MLBLightBlackTextColor;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_coverView);
            make.left.equalTo(_coverView.mas_right).offset(8);
            make.right.equalTo(self.contentView);
        }];
        
        label;
    });
    
    _contentLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor whiteColor];
        label.font = FontWithSize(13);
        label.textColor = MLBLightBlackTextColor;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_titleLabel);
            make.bottom.equalTo(_coverView);
        }];
        
        label;
    });
}

#pragma mark - Public Method

- (void)configureCellWithHomeItem:(MLBHomeItem *)item {
    [_coverView mlb_sd_setImageWithURL:item.imageURL placeholderImageName:@"home_cover_placeholder"];
    _titleLabel.text = item.title;
    _contentLabel.text = item.content;
}

@end
