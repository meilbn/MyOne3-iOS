//
//  MLBReadQuestion.m
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadQuestion.h"

@implementation MLBReadQuestion

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"questionId" : @"question_id",
             @"questionTitle" : @"question_title",
             @"answerTitle" : @"answer_title",
             @"answerContent" : @"answer_content",
             @"questionMakeTime" : @"question_makettime"};
}

@end
