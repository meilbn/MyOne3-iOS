//
//  UINavigationController+MLBNavigationShouldPopExtention.h
//  FZClothesReview
//
//  Created by meilbn on 6/16/16.
//  Copyright © 2016 hugh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UINavigationControllerShouldPop <NSObject>

- (BOOL)navigationControllerShouldPop:(UINavigationController *)navigationController;

@optional

- (BOOL)navigationControllerShouldStartInteractivePopGestureRecognizer:(UINavigationController *)navigationController;

@end

@interface UINavigationController (MLBNavigationShouldPopExtention) <UIGestureRecognizerDelegate>

@end
