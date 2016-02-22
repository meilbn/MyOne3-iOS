//
//  MLBReadingCarouselItem.m
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadingCarouselItem.h"

@implementation MLBReadingCarouselItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"itemId" : @"id",
             @"title" : @"title",
             @"cover" : @"cover",
             @"bottomText" : @"bottom_text",
             @"bgColor" : @"bgcolor",
             @"inputName" : @"input_name"};
}

@end
