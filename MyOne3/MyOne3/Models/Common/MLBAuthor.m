//
//  MLBAuthor.m
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBAuthor.h"

@implementation MLBAuthor

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"userId" : @"user_id",
             @"username" : @"user_name",
             @"webURL" : @"web_url",
             @"wbName" : @"wb_name",
             @"desc" : @"desc"};
}

@end
