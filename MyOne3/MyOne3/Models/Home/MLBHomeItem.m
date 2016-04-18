//
//  MLBHomeItem.m
//  MyOne3
//
//  Created by meilbn on 2/22/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBHomeItem.h"

@implementation MLBHomeItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"contentId" : @"hpcontent_id",
             @"content" : @"hp_content",
             @"title" : @"hp_title",
             @"imageURL" : @"hp_img_url",
             @"imageOriginalURL" : @"hp_img_original_url",
             @"authorId" : @"author_id",
             @"authorName" : @"hp_author",
             @"iPadURL" : @"ipad_url",
             @"makeTime" : @"hp_makettime",
             @"lastUpdateDate" : @"last_update_date",
             @"webURL" : @"web_url",
             @"wbImageURL" : @"wb_img_url",
             @"praiseNum" : @"praisenum",
             @"shareNum" : @"sharenum",
             @"commentNum" : @"commentnum"};
}

@end
