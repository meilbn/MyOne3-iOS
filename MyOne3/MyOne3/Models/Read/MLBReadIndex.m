//
//  MLBReadIndex.m
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadIndex.h"

@implementation MLBReadIndex

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"essay" : @"essay",
             @"serial" : @"serial",
             @"question" : @"question"};
}

+ (NSValueTransformer *)essayJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MLBReadEssay class]];
}

+ (NSValueTransformer *)serialJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MLBReadSerial class]];
}

+ (NSValueTransformer *)questionJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MLBReadQuestion class]];
}

@end
