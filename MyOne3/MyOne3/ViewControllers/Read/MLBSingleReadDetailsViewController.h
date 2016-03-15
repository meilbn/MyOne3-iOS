//
//  MLBSingleReadDetailsViewController.h
//  MyOne3
//
//  Created by meilbn on 3/15/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseViewController.h"

@class MLBBaseModel;

@interface MLBSingleReadDetailsViewController : MLBBaseViewController

@property (nonatomic, copy) MLBBaseModel *readModel;
@property (nonatomic, assign) MLBReadType readType;

@end
