//
//  MLBMovieListItemCCell.h
//  MyOne3
//
//  Created by meilbn on 3/8/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const kMLBMovieListItemCCellID;

@class MLBMovieListItem;

@interface MLBMovieListItemCCell : UICollectionViewCell

+ (CGSize)cellSize;

- (void)configureCellWithMovieListItem:(MLBMovieListItem *)movieListItem atIndexPath:(NSIndexPath *)indexPath;

- (void)stopCountDownIfNeeded;

@end
