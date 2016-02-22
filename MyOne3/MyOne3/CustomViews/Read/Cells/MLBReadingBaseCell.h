//
//  MLBReadingBaseCell.h
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

FOUNDATION_EXPORT NSString *const kMLBReadingBaseCellID;

@class MLBReadingEssay;
@class MLBReadingSerial;
@class MLBReadingQuestion;

@interface MLBReadingBaseCell : MLBBaseCell

- (void)configureCellWithReadingEssay:(MLBReadingEssay *)readingEssay;

- (void)configureCellWithReadingSerial:(MLBReadingSerial *)readingSerial;

- (void)configureCellWithReadingQuestion:(MLBReadingQuestion *)readingQuestion;

@end
