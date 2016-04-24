//
//  MLBSearchPictureCell.h
//  MyOne3
//
//  Created by meilbn on 4/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

FOUNDATION_EXPORT NSString *const kMLBSearchPictureCellID;

@class MLBHomeItem;

@interface MLBSearchPictureCell : MLBBaseCell

+ (CGFloat)cellHeight;

- (void)configureCellWithHomeItem:(MLBHomeItem *)item;

@end
