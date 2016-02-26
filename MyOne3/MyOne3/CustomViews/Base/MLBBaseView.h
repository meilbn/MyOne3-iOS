//
//  MLBBaseView.h
//  MyOne3
//
//  Created by meilbn on 2/25/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLBBaseViewController;

@interface MLBBaseView : UIView

@property (nonatomic, weak) MLBBaseViewController *parentViewController;
@property (nonatomic, assign) NSInteger viewIndex;

@end
