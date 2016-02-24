//
//  MLBMusicDetails.m
//  MyOne3
//
//  Created by meilbn on 2/23/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBMusicDetails.h"

@implementation MLBMusicDetails

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"musicId" : @"id",
             @"title" : @"title",
             @"cover" : @"cover",
             @"isFirst" : @"isfirst",
             @"storyTitle" : @"story_title",
             @"story" : @"story",
             @"lyric" : @"lyric",
             @"info" : @"info",
             @"platform" : @"platform",
             @"musicURL" : @"music_id",
             @"chargeEditor" : @"charge_edt",
             @"relatedTo" : @"related_to",
             @"webURL" : @"web_url",
             @"praiseNum" : @"praisenum",
             @"sort" : @"sort",
             @"makeTime" : @"maketime",
             @"lastUpdateDate" : @"last_update_date",
             @"author" : @"author",
             @"storyAuthor" : @"story_author"};
}

+ (NSValueTransformer *)authorJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[MLBAuthor class]];
}

+ (NSValueTransformer *)storyAuthorJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[MLBAuthor class]];
}

@end
