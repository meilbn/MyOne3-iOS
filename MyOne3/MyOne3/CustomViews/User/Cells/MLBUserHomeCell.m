//
//  MLBUserHomeCell.m
//  MyOne3
//
//  Created by meilbn on 3/17/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBUserHomeCell.h"

NSString *const kUserHomeCellID = @"MLBUserHomeCellID";

@interface MLBUserHomeCell ()

@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation MLBUserHomeCell

+ (CGFloat)cellHeight {
    return 44;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _leftImageView.image = nil;
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
    if (_leftImageView) {
        return;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _leftImageView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.top.left.equalTo(self.contentView);
        }];
        
        imageView;
    });
    
    _titleLabel = ({
        UILabel *label = [UILabel new];
        label.font = FontWithSize(14);
        label.textColor = [UIColor colorWithWhite:72 / 255.0 alpha:1];// #484848
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(_leftImageView.mas_right).offset(8);
        }];
        
        label;
    });
    
    UIImageView *forwardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forward_info"]];
    [self.contentView addSubview:forwardView];
    [forwardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(6, 10));
        make.centerY.equalTo(self.contentView);
        make.left.greaterThanOrEqualTo(_titleLabel.mas_right).offset(8);
        make.right.equalTo(self.contentView).offset(-14);
    }];
}

#pragma mark - Public Method

- (void)configureCellWithTitle:(NSString *)title imageName:(NSString *)imageName atIndexPath:(NSIndexPath *)indexPath {
    _titleLabel.text = title;
    if (IsStringNotEmpty(imageName)) {
        _leftImageView.image = [UIImage imageNamed:imageName];
    }
}

@end
