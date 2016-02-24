//
//  MLBRelatedMusicCell.h
//  MyOne3
//
//  Created by meilbn on 2/23/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

FOUNDATION_EXPORT NSString *const kMLBRelatedMusicCellID;

@class MLBRelatedMusic;

@interface MLBRelatedMusicCell : MLBBaseCell

+ (CGFloat)cellHeight;

- (void)configureCellWithRelatedMusic:(MLBRelatedMusic *)relatedMusic atIndexPath:(NSIndexPath *)indexPath;

@end
