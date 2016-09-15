//
//  MLBReadDetailsAuthorCell.h
//  MyOne3
//
//  Created by meilbn on 9/13/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

FOUNDATION_EXTERN NSString *const kMLBReadDetailsAuthorCellID;

@class MLBReadEssayDetails;
@class MLBReadSerialDetails;

@interface MLBReadDetailsAuthorCell : MLBBaseCell

- (void)configureCellWithEssayDetails:(MLBReadEssayDetails *)essayDetails;

- (void)configureCellWithSerialDetails:(MLBReadSerialDetails *)serialDetails;

@end
