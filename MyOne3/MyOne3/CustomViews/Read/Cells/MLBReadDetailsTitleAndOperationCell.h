//
//  MLBReadDetailsTitleAndOperationCell.h
//  MyOne3
//
//  Created by meilbn on 9/13/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

FOUNDATION_EXTERN NSString *const kMLBReadDetailsTitleAndOperationCellID;

@interface MLBReadDetailsTitleAndOperationCell : MLBBaseCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *serialsButton;

@property (nonatomic, copy) void (^serialsClicked)();

@end
