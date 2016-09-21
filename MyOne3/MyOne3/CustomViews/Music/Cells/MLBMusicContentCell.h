//
//  MLBMusicContentCell.h
//  MyOne3
//
//  Created by meilbn on 9/16/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

FOUNDATION_EXTERN NSString *const kMLBMusicContentCellID;

@class MLBMusicDetails;

@interface MLBMusicContentCell : MLBBaseCell

@property (nonatomic, copy) void (^contentTypeButtonSelected)(MLBMusicDetailsType buttonType);

- (void)configureCellWithMusicDetails:(MLBMusicDetails *)musicDetails;

@end
