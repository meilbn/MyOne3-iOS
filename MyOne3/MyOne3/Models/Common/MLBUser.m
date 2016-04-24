//
//  MLBUser.m
//  MyOne3
//
//  Created by meilbn on 2/23/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBUser.h"

@implementation MLBUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"userId" : @"user_id",
             @"username" : @"user_name",
             @"webURL" : @"web_url",
             @"desc" : @"desc"};
}

@end
