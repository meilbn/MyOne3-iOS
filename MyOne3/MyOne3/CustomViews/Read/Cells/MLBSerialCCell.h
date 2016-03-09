//
//  MLBSerialCCell.h
//  MyOne3
//
//  Created by meilbn on 3/9/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const kMLBSerialCCellID;

@interface MLBSerialCCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *numberLabel;

+ (CGSize)cellSize;

@end
