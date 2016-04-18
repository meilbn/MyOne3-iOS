//
//  MLBPreviousViewController.h
//  MyOne3
//
//  Created by meilbn on 4/18/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseViewController.h"

typedef NS_ENUM(NSUInteger, MLBPreviousType) {
    MLBPreviousTypeHome,
    MLBPreviousTypeRead,
    MLBPreviousTypeMusic,
};

@interface MLBPreviousViewController : MLBBaseViewController

@property (nonatomic, assign) MLBPreviousType previousType;

@end
