//
//  MLBRelatedMusicCCell.h
//  MyOne3
//
//  Created by meilbn on 9/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSString *const kMLBRelatedMusicCCellID;

@class MLBRelatedMusic;

@interface MLBRelatedMusicCCell : UICollectionViewCell

+ (CGSize)cellSize;

- (void)configureCellWithRelatedMusic:(MLBRelatedMusic *)music;

@end
