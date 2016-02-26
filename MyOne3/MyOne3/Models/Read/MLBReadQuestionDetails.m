//
//  MLBReadQuestionDetails.m
//  MyOne3
//
//  Created by meilbn on 2/26/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadQuestionDetails.h"

@implementation MLBReadQuestionDetails

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"questionId" : @"question_id",
             @"questionTitle" : @"question_title",
             @"questionContent" : @"question_content",
             @"answerTitle" : @"answer_title",
             @"answerContent" : @"answer_content",
             @"questionMakeTime" : @"question_makettime",
             @"recommendFlag" : @"recommend_flag",
             @"chargeEditor" : @"charge_edt",
             @"lastUpdateDate" : @"last_update_date",
             @"webURL" : @"web_url",
             @"praiseNum" : @"praisenum"};
}

@end
