//
//  MLBSerialList.m
//  MyOne3
//
//  Created by meilbn on 3/9/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBSerialList.h"

@implementation MLBSerialList

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"serialId" : @"id",
             @"title" : @"title",
             @"finished" : @"finished",
             @"list" : @"list"};
}

+ (NSValueTransformer *)listJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MLBReadSerial class]];
}

@end
