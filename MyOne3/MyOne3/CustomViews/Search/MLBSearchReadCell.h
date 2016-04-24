//
//  MLBSearchReadCell.h
//  MyOne3
//
//  Created by meilbn on 4/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

FOUNDATION_EXPORT NSString *const kMLBSearchReadCellID;

@class MLBSearchRead;

@interface MLBSearchReadCell : MLBBaseCell

+ (CGFloat)cellHeight;

- (void)configureCellWithSearchRead:(MLBSearchRead *)read;

@end
