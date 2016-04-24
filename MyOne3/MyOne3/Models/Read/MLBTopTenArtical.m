//
//  MLBTopTenArtical.m
//  MyOne3
//
//  Created by meilbn on 2/27/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBTopTenArtical.h"

@implementation MLBTopTenArtical

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"itemId" : @"item_id",
             @"title" : @"title",
             @"introduction" : @"introduction",
             @"authorName" : @"author",
             @"webURL" : @"web_url",
             @"number" : @"number",
             @"type" : @"type"};
}

+ (NSValueTransformer *)numberJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return @([[NSString stringWithFormat:@"%@", value] integerValue]);
    }];
}

@end
