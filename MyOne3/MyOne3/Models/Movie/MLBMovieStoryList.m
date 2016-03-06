//
//  MLBMovieStoryList.m
//  MyOne3
//
//  Created by meilbn on 3/2/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBMovieStoryList.h"

@implementation MLBMovieStoryList

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"count" : @"count",
             @"stories" : @"data"};
}

+ (NSValueTransformer *)storiesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MLBMovieStory class]];
}

@end
