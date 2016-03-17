//
//  MLBSettingsCell.m
//  MyOne3
//
//  Created by meilbn on 3/17/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBSettingsCell.h"

NSString *const kSettingsCellIDWithSwitch = @"MLBSettingsCellIDWithSwitch";
NSString *const kSettingsCellIDWithArrow = @"MLBSettingsCellIDWithArrow";
NSString *const kSettingsCellIDWithVerison = @"MLBSettingsCellIDWithVersion";

@interface MLBSettingsCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UISwitch *switchView;
@property (strong, nonatomic) UILabel *versionLabel;

@end

@implementation MLBSettingsCell

+ (CGFloat)cellHeight {
    return 44;
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
    if (_titleLabel) {
        return;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = ({
        UILabel *label = [UILabel new];
        label.font = FontWithSize(14);
        label.textColor = [UIColor colorWithWhite:72 / 255.0 alpha:1];// #484848
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
        }];
        
        label;
    });
    
    if (self.reuseIdentifier == kSettingsCellIDWithSwitch) {
        _switchView = ({
            UISwitch *switchView = [UISwitch new];
            switchView.onTintColor = MLBAppThemeColor;
            [switchView addTarget:self action:@selector(switchValueChanged) forControlEvents:UIControlEventValueChanged];
            [self.contentView addSubview:switchView];
            [switchView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView).offset(-12);
            }];
            
            switchView;
        });
    } else if (self.reuseIdentifier == kSettingsCellIDWithArrow) {
        UIImageView *forwardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forward_info"]];
        [self.contentView addSubview:forwardView];
        [forwardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(6, 10));
            make.centerY.equalTo(self.contentView);
            make.left.greaterThanOrEqualTo(_titleLabel.mas_right).offset(8);
            make.right.equalTo(self.contentView).offset(-14);
        }];
    } else if (self.reuseIdentifier == kSettingsCellIDWithVerison) {
        _versionLabel = ({
            UILabel *label = [UILabel new];
            label.font = FontWithSize(12);
            label.textColor = [UIColor colorWithWhite:72 / 255.0 alpha:1];// #484848
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.equalTo(self.contentView).offset(-12);
            }];
            
            label;
        });
    }
    
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = [UIColor colorWithWhite:223 / 255.0 alpha:1];// #DFDFDF
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.bottom.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 6, 0, 6));
    }];
}

#pragma mark - Action

- (void)switchValueChanged {
    if (_switchChanged) {
        _switchChanged(_switchView.isOn);
    }
}

#pragma mark - Public Method

- (void)configureCellWithTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)configureCellWithTitle:(NSString *)title isSwitchOn:(BOOL)isOn {
    [self configureCellWithTitle:title];
    if (_switchView) {
        _switchView.on = isOn;
    }
}

- (void)configureCellWithTitle:(NSString *)title version:(NSString *)version {
    [self configureCellWithTitle:title];
    if (_versionLabel) {
        _versionLabel.text = version;
    }
}

@end
