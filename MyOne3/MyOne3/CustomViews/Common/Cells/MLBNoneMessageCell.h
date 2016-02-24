//
//  MLBNoneMessageCell.h
//  MyOne3
//
//  Created by meilbn on 2/24/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

FOUNDATION_EXPORT NSString *const kMLBNoneMessageCellID;

@interface MLBNoneMessageCell : MLBBaseCell

@property (nonatomic, strong) UIImageView *hintView;

+ (CGFloat)cellHeight;

@end
