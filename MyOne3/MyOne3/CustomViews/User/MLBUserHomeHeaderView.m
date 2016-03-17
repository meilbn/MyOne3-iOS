//
//  MLBUserHomeHeaderView.m
//  MyOne3
//
//  Created by meilbn on 3/16/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBUserHomeHeaderView.h"

@interface MLBUserHomeHeaderView ()

@property (strong, nonatomic) MLBTapImageView *userAvatarView;
@property (strong, nonatomic) UILabel *nicknameLabel;
@property (strong, nonatomic) UILabel *oneCoinCountLabel;

@property (nonatomic, assign) MLBUserType userType;

@end

@implementation MLBUserHomeHeaderView

#pragma mark - LifeCycle

- (instancetype)initWithUserType:(MLBUserType)userType {
    self = [super init];
    
    if (self) {
        _userType = userType;
        [self setupViews];
    }
    
    return self;
}

#pragma mark - Private Method

- (void)setupViews {
    if (_userType == MLBUserTypeMe) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 206);
    } else if (_userType == MLBUserTypeOthers) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 386);
    }
    
    _userAvatarView = ({
        MLBTapImageView *imageView = [MLBTapImageView new];
        imageView.layer.cornerRadius = 30;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 1;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@60);
            make.top.equalTo(self).offset(64);
            make.centerX.equalTo(self);
        }];
        
        imageView;
    });
    
    _nicknameLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.font = FontWithSize(15);
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_userAvatarView.mas_bottom).offset(8);
            make.left.right.equalTo(self);
        }];
        
        label;
    });
    
    _oneCoinCountLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.font = FontWithSize(11);
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nicknameLabel.mas_bottom).offset(8);
            make.left.equalTo(_nicknameLabel.mas_centerX);
            make.right.lessThanOrEqualTo(self).offset(-8);
            make.bottom.lessThanOrEqualTo(self).offset(-30);
        }];
        
        label;
    });
}

#pragma mark - Public Method

- (CGFloat)viewHeight {
    return CGRectGetHeight(self.frame);
}

- (void)configureHeaderViewForTestMe {
    _userAvatarView.image = [UIImage imageNamed:@"personal"];
    _nicknameLabel.text = @"请登录";
    _oneCoinCountLabel.text = @"";
}

@end
