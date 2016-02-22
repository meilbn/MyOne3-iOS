//
//  MLBReadingIndex.m
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadingIndex.h"

@implementation MLBReadingIndex

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"essay" : @"essay",
             @"serial" : @"serial",
             @"question" : @"question"};
}

+ (NSValueTransformer *)essayJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MLBReadingEssay class]];
}

+ (NSValueTransformer *)serialJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MLBReadingSerial class]];
}

+ (NSValueTransformer *)questionJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MLBReadingQuestion class]];
}

@end
