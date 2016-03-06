//
//  MLBMovieListItem.m
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBMovieListItem.h"

@implementation MLBMovieListItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"movieId" : @"id",
             @"title" : @"title",
             @"verse" : @"verse",
             @"verseEn" : @"verse_en",
             @"score" : @"score",
             @"revisedScore" : @"revisedscore",
             @"releaseTime" : @"releasetime",
             @"scoreTime" : @"scoretime",
             @"cover" : @"cover",
             @"serverTime" : @"servertime"};
}

@end
