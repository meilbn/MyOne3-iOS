//
//  MLBMovieReview.m
//  MyOne3
//
//  Created by meilbn on 3/2/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBMovieReview.h"

@implementation MLBMovieReview

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"reviewId" : @"id",
             @"movieId" : @"movie_id",
             @"content" : @"content",
             @"score" : @"score",
             @"praiseNum" : @"praisenum",
             @"sort" : @"sort",
             @"inputDate" : @"input_date",
             @"author" : @"author"};
}

+ (NSValueTransformer *)authorJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[MLBAuthor class]];
}

@end
