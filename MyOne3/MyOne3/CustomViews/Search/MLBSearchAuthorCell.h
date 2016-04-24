//
//  MLBSearchAuthorCell.h
//  MyOne3
//
//  Created by meilbn on 4/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

FOUNDATION_EXPORT NSString *const kMLBSearchAuthorCellID;

@class MLBUser;

@interface MLBSearchAuthorCell : MLBBaseCell

+ (CGFloat)cellHeight;

- (void)configureCellWithUser:(MLBUser *)user;

@end
