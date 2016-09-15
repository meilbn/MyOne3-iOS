//
//  MLBReadDetailsContentCell.h
//  MyOne3
//
//  Created by meilbn on 9/13/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

FOUNDATION_EXTERN NSString *const kMLBReadDetailsContentCellID;

@class MLBReadEssayDetails;
@class MLBReadSerialDetails;

@interface MLBReadDetailsContentCell : MLBBaseCell

- (void)configureCellWithContent:(NSString *)content editor:(NSString *)editor;

@end
