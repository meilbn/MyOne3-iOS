//
//  MLBSearchAuthorCell.m
//  MyOne3
//
//  Created by meilbn on 4/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBSearchAuthorCell.h"
#import "MLBUser.h"
#import "ZYImageView.h"

NSString *const kMLBSearchAuthorCellID = @"MLBSearchAuthorCellID";

@interface MLBSearchAuthorCell ()

@property (strong, nonatomic) ZYImageView *avatarView;
@property (strong, nonatomic) UILabel *usernameLabel;
@property (strong, nonatomic) UILabel *descLabel;

@end

@implementation MLBSearchAuthorCell

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
    _avatarView.image = nil;
}

#pragma mark - Private Method

- (void)setupViews {
    if (_avatarView) {
        return;
    }
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _avatarView = ({
        ZYImageView *imageView = [ZYImageView zy_roundingRectImageView];
        imageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@48);
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(8);
        }];
        
        imageView;
    });
    
    _usernameLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = MLBLightBlackTextColor;
        label.font = FontWithSize(13);
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_avatarView).offset(2);
            make.left.equalTo(_avatarView.mas_right).offset(8);
            make.right.equalTo(self.contentView);
        }];
        
        label;
    });
    
    _descLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = MLBAppThemeColor;
        label.font = FontWithSize(12);
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_usernameLabel);
            make.bottom.equalTo(_avatarView).offset(-4);
        }];
        
        label;
    });
}

#pragma mark - Public Method

- (void)configureCellWithUser:(MLBUser *)user {
    [_avatarView mlb_sd_setImageWithURL:user.webURL placeholderImageName:nil];
    _usernameLabel.text = user.username;
    _descLabel.text = user.desc;
}

@end
