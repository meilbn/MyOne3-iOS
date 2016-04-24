//
//  MLBUtilities.h
//  MyOne3
//
//  Created by meilbn on 2/22/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLBUtilities : NSObject

#pragma mark - String / 字符串

+ (NSString *)stringDateFormatWithddMMMyyyyEEEByNormalDateString:(NSString *)normalDateString;

+ (NSString *)stringDateForMusicDetailsDateString:(NSString *)normalDateString;

+ (NSString *)appCurrentVersion;

+ (NSString *)appCurrentBuild;

+ (NSAttributedString *)mlb_attributedStringWithText:(NSString *)text lineSpacing:(CGFloat)lineSpacing font:(UIFont *)font textColor:(UIColor *)textColor;

+ (CGRect)mlb_rectWithAttributedString:(NSAttributedString *)attributedString size:(CGSize)size;

#pragma mark - Int

+ (NSInteger)rowWithCount:(NSInteger)count colNumber:(NSInteger)colNumber;

#pragma mark - Date / 日期

+ (NSDate *)dateWithString:(NSString *)string;

+ (NSTimeInterval)diffTimeIntervalSinceNowFromDateString:(NSString *)dateString;

+ (NSTimeInterval)diffTimeIntervalSinceNowToDateString:(NSString *)dateString;

@end
