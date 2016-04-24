//
//  MLBReadQuestion.h
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"

@interface MLBReadQuestion : MLBBaseModel

@property (nonatomic, copy) NSString *questionId;
@property (nonatomic, copy) NSString *questionTitle;
@property (nonatomic, copy) NSString *answerTitle;
@property (nonatomic, copy) NSString *answerContent;
@property (nonatomic, copy) NSString *questionMakeTime;

@end
