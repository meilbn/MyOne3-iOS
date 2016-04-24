//
//  MLBReadEssay.m
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadEssay.h"

@implementation MLBReadEssay

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"contentId" : @"content_id",
             @"title" : @"hp_title",
             @"makeTime" : @"hp_makettime",
             @"guideWord" : @"guide_word",
             @"authors" : @"author",
             @"hasAudio" : @"has_audio"};
}

+ (NSValueTransformer *)authorsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MLBAuthor class]];
}

@end
