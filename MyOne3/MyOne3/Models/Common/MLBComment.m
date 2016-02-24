//
//  MLBComment.m
//  MyOne3
//
//  Created by meilbn on 2/23/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBComment.h"

@implementation MLBComment

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"commentId" : @"id",
             @"quote" : @"quote",
             @"content" : @"content",
             @"praiseNum" : @"praisenum",
             @"inputDate" : @"input_date",
             @"user" : @"user",
             @"toUser" : @"touser",
             @"score" : @"score"};
}

+ (NSValueTransformer *)userJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[MLBUser class]];
}

+ (NSValueTransformer *)toUserJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[MLBUser class]];
}

@end
