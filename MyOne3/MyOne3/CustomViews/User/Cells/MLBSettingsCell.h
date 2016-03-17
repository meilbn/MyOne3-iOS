//
//  MLBSettingsCell.h
//  MyOne3
//
//  Created by meilbn on 3/17/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

FOUNDATION_EXPORT NSString *const kSettingsCellIDWithSwitch;
FOUNDATION_EXPORT NSString *const kSettingsCellIDWithArrow;
FOUNDATION_EXPORT NSString *const kSettingsCellIDWithVerison;

@interface MLBSettingsCell : MLBBaseCell

@property (nonatomic, copy) void (^switchChanged)(BOOL isOn);

+ (CGFloat)cellHeight;

- (void)configureCellWithTitle:(NSString *)title;

- (void)configureCellWithTitle:(NSString *)title isSwitchOn:(BOOL)isOn;

- (void)configureCellWithTitle:(NSString *)title version:(NSString *)version;

@end
