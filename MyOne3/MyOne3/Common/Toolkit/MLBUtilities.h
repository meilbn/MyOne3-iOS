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

#pragma mark - Date / 日期

+ (NSDate *)dateWithString:(NSString *)string;

@end
