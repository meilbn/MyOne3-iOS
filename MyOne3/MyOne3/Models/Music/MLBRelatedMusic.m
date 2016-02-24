//
//  MLBRelatedMusic.m
//  MyOne3
//
//  Created by meilbn on 2/23/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBRelatedMusic.h"

@implementation MLBRelatedMusic

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"musicId" : @"id",
             @"title" : @"title",
             @"cover" : @"cover",
             @"platform" : @"platform",
             @"musicLongId" : @"music_id",
             @"author" : @"author"};
}

+ (NSValueTransformer *)authorJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[MLBAuthor class]];
}

@end
