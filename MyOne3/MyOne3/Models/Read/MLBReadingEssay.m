//
//  MLBReadingEssay.m
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadingEssay.h"

@implementation MLBReadingEssay

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"contentId" : @"content_id",
             @"title" : @"hp_title",
             @"makeTime" : @"hp_makettime",
             @"guideWord" : @"guide_word",
             @"authors" : @"author"};
}

+ (NSValueTransformer *)authorsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MLBAuthor class]];
}

@end
