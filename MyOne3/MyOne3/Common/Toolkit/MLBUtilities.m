//
//  MLBUtilities.m
//  MyOne3
//
//  Created by meilbn on 2/22/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBUtilities.h"

static NSDateFormatter *myOneDateFormatter;
static NSDateFormatter *loneDateFormatter;

@implementation MLBUtilities

#pragma mark - String / 字符串

+ (NSString *)stringDateFormatWithddMMMyyyyEEEByNormalDateString:(NSString *)normalDateString {
    if (!myOneDateFormatter) {
        myOneDateFormatter = [NSDateFormatter new];
        myOneDateFormatter.dateFormat = @"dd MMM,yyyy. EEE.";
        myOneDateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    }
    
    NSDate *date = [MLBUtilities dateWithString:normalDateString];
    
    return [myOneDateFormatter stringFromDate:date];
}

+ (NSDate *)dateWithString:(NSString *)string {
    if (!loneDateFormatter) {
        loneDateFormatter = [NSDateFormatter new];
        loneDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        loneDateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    }
    
    return [loneDateFormatter dateFromString:string];
}

@end
