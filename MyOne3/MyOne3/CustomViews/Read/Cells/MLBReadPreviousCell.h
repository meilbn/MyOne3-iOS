//
//  MLBReadPreviousCell.h
//  MyOne3
//
//  Created by meilbn on 4/19/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseCell.h"

FOUNDATION_EXPORT NSString *const kMLBReadPreviousCellID;

@class MLBBaseModel;

@interface MLBReadPreviousCell : MLBBaseCell

- (void)configureViewWithReadModel:(MLBBaseModel *)model type:(MLBReadType)type atIndexPath:(NSIndexPath *)indexPath;

@end
