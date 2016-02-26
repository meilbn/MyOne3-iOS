//
//  MLBReadQuestionDetails.h
//  MyOne3
//
//  Created by meilbn on 2/26/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"

@interface MLBReadQuestionDetails : MLBBaseModel

@property (nonatomic, copy) NSString *questionId;
@property (nonatomic, copy) NSString *questionTitle;
@property (nonatomic, copy) NSString *questionContent;
@property (nonatomic, copy) NSString *answerTitle;
@property (nonatomic, copy) NSString *answerContent;
@property (nonatomic, copy) NSString *questionMakeTime;
@property (nonatomic, copy) NSString *recommendFlag;
@property (nonatomic, copy) NSString *chargeEditor;
@property (nonatomic, copy) NSString *lastUpdateDate;
@property (nonatomic, copy) NSString *webURL;
@property (nonatomic, assign) NSInteger praiseNum;

@end
