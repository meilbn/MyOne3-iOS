//
//  MLBReadingSerial.m
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadingSerial.h"

@implementation MLBReadingSerial

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"rid" : @"id",
             @"serialId" : @"serial_id",
             @"number" : @"number",
             @"title" : @"title",
             @"excerpt" : @"excerpt",
             @"readNum" : @"read_num",
             @"makeTime" : @"maketime",
             @"author" : @"author"};
}

+ (NSValueTransformer *)authorJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[MLBAuthor class]];
}

@end
