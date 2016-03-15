//
//  MLBReadBaseCell.h
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

FOUNDATION_EXPORT NSString *const kMLBReadBaseCellID;

@class MLBBaseModel;
@class MLBReadEssay;
@class MLBReadSerial;
@class MLBReadQuestion;

@interface MLBReadBaseCell : MLBBaseCell

- (void)configureCellWithBaseModel:(MLBBaseModel *)model;

- (void)configureCellWithReadEssay:(MLBReadEssay *)readEssay;

- (void)configureCellWithReadSerial:(MLBReadSerial *)readSerial;

- (void)configureCellWithReadQuestion:(MLBReadQuestion *)readQuestion;

@end
