//
//  MLBCommentList.m
//  MyOne3
//
//  Created by meilbn on 2/23/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBCommentList.h"

@implementation MLBCommentList

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"count" : @"count",
             @"comments" : @"data"};
}

+ (NSValueTransformer *)commentsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MLBComment class]];
}

@end
