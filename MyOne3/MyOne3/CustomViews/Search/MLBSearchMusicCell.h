//
//  MLBSearchMusicCell.h
//  MyOne3
//
//  Created by meilbn on 4/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

FOUNDATION_EXPORT NSString *const kMLBSearchMusicCellID;

@class MLBRelatedMusic;

@interface MLBSearchMusicCell : MLBBaseCell

+ (CGFloat)cellHeight;

- (void)configureCellWithRelatedMusic:(MLBRelatedMusic *)relatedMusic;

@end
