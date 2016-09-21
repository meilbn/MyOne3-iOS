//
//  MLBRelatedMusicCollectionCell.h
//  MyOne3
//
//  Created by meilbn on 9/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

FOUNDATION_EXTERN NSString *const kMLBRelatedMusicCollectionCellID;

@class MLBRelatedMusic;

@interface MLBRelatedMusicCollectionCell : MLBBaseCell

+ (CGFloat)cellHeight;

- (void)configureCellWithRelatedMusics:(NSArray<MLBRelatedMusic *> *)musics;

@end
