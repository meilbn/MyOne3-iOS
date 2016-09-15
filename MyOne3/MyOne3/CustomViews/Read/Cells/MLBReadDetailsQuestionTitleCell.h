//
//  MLBReadDetailsQuestionTitleCell.h
//  MyOne3
//
//  Created by meilbn on 9/15/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

FOUNDATION_EXTERN NSString *const kMLBReadDetailsQuestionTitleCellID;

@class MLBReadQuestionDetails;

@interface MLBReadDetailsQuestionTitleCell : MLBBaseCell

- (void)configureCellWithQuestionDetails:(MLBReadQuestionDetails *)questionDetails;

@end
