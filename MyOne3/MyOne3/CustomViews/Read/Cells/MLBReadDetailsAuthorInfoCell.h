//
//  MLBReadDetailsAuthorInfoCell.h
//  MyOne3
//
//  Created by meilbn on 9/13/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

FOUNDATION_EXTERN NSString *const kMLBReadDetailsAuthorInfoCellID;

@class MLBAuthor;

@interface MLBReadDetailsAuthorInfoCell : MLBBaseCell

- (void)configureCellWithAuthor:(MLBAuthor *)author;

@end
