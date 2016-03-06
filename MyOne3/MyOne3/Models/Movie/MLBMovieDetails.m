//
//  MLBMovieDetails.m
//  MyOne3
//
//  Created by meilbn on 3/2/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBMovieDetails.h"

@implementation MLBMovieDetails

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"movieId" : @"id",
             @"title" : @"title",
             @"indexCover" : @"indexcover",
             @"detailCover" : @"detailcover",
             @"videoURL" : @"video",
             @"review" : @"review",
             @"keywords" : @"keywords",
             @"movieLongId" : @"movie_id",
             @"info" : @"info",
             @"officialStory" : @"officialstory",
             @"chargeEditor" : @"charge_edt",
             @"webURL" : @"web_url",
             @"sort" : @"sort",
             @"makeTime" : @"maketime",
             @"lastUpdateDate" : @"last_update_date",
             @"verse" : @"verse",
             @"verseEn" : @"verse_en",
             @"score" : @"score",
             @"revisedScore" : @"revisedscore",
             @"releaseTime" : @"releasetime",
             @"scoreTime" : @"scoretime",
             @"praiseNum" : @"praisenum",
             @"photos" : @"photo",
             @"serverTime" : @"servertime"};
}

//+ (NSValueTransformer *)photosJSONTransformer {
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
//        if (!value) {
//            return @[].mutableCopy;
//        }
//        
//        NSError *jsonError;
//        NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
//        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
//        NSAssert(error, @"JSON Serialization failed");
//        return array;
//    }];
//}

@end
