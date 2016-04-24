//
//  MLBReadSerial.m
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadSerial.h"

@implementation MLBReadSerial

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"contentId" : @"id",
             @"serialId" : @"serial_id",
             @"number" : @"number",
             @"title" : @"title",
             @"excerpt" : @"excerpt",
             @"readNum" : @"read_num",
             @"makeTime" : @"maketime",
             @"author" : @"author",
             @"hasAudio" : @"has_audio"};
}

+ (NSValueTransformer *)authorJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[MLBAuthor class]];
}

@end
