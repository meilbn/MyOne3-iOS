//
//  MLBReadQuestionDetails.h
//  MyOne3
//
//  Created by meilbn on 2/26/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"

@interface MLBReadQuestionDetails : MLBBaseModel

@property (nonatomic, strong) NSString *questionId;
@property (nonatomic, strong) NSString *questionTitle;
@property (nonatomic, strong) NSString *questionContent;
@property (nonatomic, strong) NSString *answerTitle;
@property (nonatomic, strong) NSString *answerContent;
@property (nonatomic, strong) NSString *questionMakeTime;
@property (nonatomic, strong) NSString *recommendFlag;
@property (nonatomic, strong) NSString *chargeEditor;
@property (nonatomic, strong) NSString *lastUpdateDate;
@property (nonatomic, strong) NSString *webURL;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, strong) NSString *readNum;
@property (nonatomic, strong) NSString *guideWord;
@property (nonatomic, assign) NSInteger shareNum;
@property (nonatomic, assign) NSInteger commentNum;

@end
