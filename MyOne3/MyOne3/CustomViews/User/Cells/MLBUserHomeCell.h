//
//  MLBUserHomeCell.h
//  MyOne3
//
//  Created by meilbn on 3/17/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

FOUNDATION_EXPORT NSString *const kUserHomeCellID;

@interface MLBUserHomeCell : MLBBaseCell

+ (CGFloat)cellHeight;

- (void)configureCellWithTitle:(NSString *)title imageName:(NSString *)imageName atIndexPath:(NSIndexPath *)indexPath;

@end
