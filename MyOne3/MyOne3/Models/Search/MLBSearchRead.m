//
//  MLBSearchRead.m
//  MyOne3
//
//  Created by meilbn on 4/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBSearchRead.h"

@implementation MLBSearchRead

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"readId" : @"id",
             @"title" : @"title",
             @"type" : @"type",
             @"number" : @"number"};
}

+ (NSValueTransformer *)numberJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSString class]]) {
            return @([value integerValue]);
        } else {
            return value;
        }
    }];
}

@end
