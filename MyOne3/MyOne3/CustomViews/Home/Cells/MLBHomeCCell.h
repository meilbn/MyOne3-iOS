//
//  MLBHomeCCell.h
//  MyOne3
//
//  Created by meilbn on 4/18/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const kMLBHomeCCellID;

@class MLBHomeItem;

@interface MLBHomeCCell : UICollectionViewCell

+ (CGSize)cellSizeWithHomeItem:(MLBHomeItem *)item;

- (void)configureCellWithHomeItem:(MLBHomeItem *)homeItem atIndexPath:(NSIndexPath *)indexPath;

@end
