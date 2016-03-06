//
//  MLBMovieStory.m
//  MyOne3
//
//  Created by meilbn on 3/2/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBMovieStory.h"

@implementation MLBMovieStory

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"storyId" : @"id",
             @"movieId" : @"movie_id",
             @"title" : @"title",
             @"content" : @"content",
             @"userId" : @"user_id",
             @"sort" : @"sort",
             @"praiseNum" : @"praisenum",
             @"inputDate" : @"input_date",
             @"storyType" : @"story_type",
             @"user" : @"user"};
}

+ (NSValueTransformer *)userJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[MLBUser class]];
}

@end
