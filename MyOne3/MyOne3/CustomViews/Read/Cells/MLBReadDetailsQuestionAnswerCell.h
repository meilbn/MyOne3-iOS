//
//  MLBReadDetailsQuestionAnswerCell.h
//  MyOne3
//
//  Created by meilbn on 9/15/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

FOUNDATION_EXTERN NSString *const kMLBReadDetailsQuestionAnswerCellID;

@class MLBReadQuestionDetails;

@interface MLBReadDetailsQuestionAnswerCell : MLBBaseCell

- (void)configureCellWithQuestionDetails:(MLBReadQuestionDetails *)questionDetails;

@end
