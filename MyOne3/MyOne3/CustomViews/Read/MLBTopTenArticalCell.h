//
//  MLBTopTenArticalCell.h
//  MyOne3
//
//  Created by meilbn on 2/27/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

FOUNDATION_EXPORT NSString *const kMLBTopTenArticalCellID;

@class MLBTopTenArtical;

@interface MLBTopTenArticalCell : MLBBaseCell

+ (CGFloat)cellHeight;

- (void)configureCellWithTopTenArtical:(MLBTopTenArtical *)artical;

@end
