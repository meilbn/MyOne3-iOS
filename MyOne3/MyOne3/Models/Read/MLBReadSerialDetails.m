//
//  MLBReadSerialDetails.m
//  MyOne3
//
//  Created by meilbn on 2/26/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadSerialDetails.h"

@implementation MLBReadSerialDetails

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"contentId" : @"id",
             @"serialId" : @"serial_id",
             @"number" : @"number",
             @"title" : @"title",
             @"excerpt" : @"excerpt",
             @"content" : @"content",
             @"chargeEditor" : @"charge_edt",
             @"lastUpdateDate" : @"last_update_date",
             @"audioURL" : @"audio",
             @"webURL" : @"web_url",
             @"inputName" : @"input_name",
             @"lastUpdateName" : @"last_update_name",
             @"readNum" : @"read_num",
             @"makeTime" : @"maketime",
             @"author" : @"author",
             @"praiseNum" : @"praisenum"};
}

+ (NSValueTransformer *)authorJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[MLBAuthor class]];
}

@end
