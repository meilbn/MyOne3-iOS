//
//  MLBMovieReviewList.m
//  MyOne3
//
//  Created by meilbn on 3/2/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBMovieReviewList.h"

@implementation MLBMovieReviewList

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"count" : @"count",
             @"reviews" : @"data"};
}

+ (NSValueTransformer *)reviewsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MLBMovieReview class]];
}

@end
