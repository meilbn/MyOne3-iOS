//
//  MLBMoviePosterCCell.h
//  MyOne3
//
//  Created by meilbn on 3/8/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const kMLBMoviePosterCCellID;

@interface MLBMoviePosterCCell : UICollectionViewCell

- (void)configureCellWithPostURL:(NSString *)posterURL;

@end
