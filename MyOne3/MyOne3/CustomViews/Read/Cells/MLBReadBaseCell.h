//
//  MLBReadBaseCell.h
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

FOUNDATION_EXPORT NSString *const kMLBReadBaseCellID;

@class MLBReadEssay;
@class MLBReadSerial;
@class MLBReadQuestion;

@interface MLBReadBaseCell : MLBBaseCell

- (void)configureCellWithreadEssay:(MLBReadEssay *)readEssay;

- (void)configureCellWithreadSerial:(MLBReadSerial *)readSerial;

- (void)configureCellWithreadQuestion:(MLBReadQuestion *)readQuestion;

@end
