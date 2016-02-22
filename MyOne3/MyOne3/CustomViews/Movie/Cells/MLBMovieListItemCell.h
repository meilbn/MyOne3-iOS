//
//  MLBMovieListItemCell.h
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

FOUNDATION_EXPORT NSString *const kMLBMovieListItemCellID;

@class MLBMovieListItem;

@interface MLBMovieListItemCell : MLBBaseCell

+ (CGFloat)cellHight;

- (void)configureCellWithMovieListItem:(MLBMovieListItem *)movieListItem atIndexPath:(NSIndexPath *)indexPath;

@end
