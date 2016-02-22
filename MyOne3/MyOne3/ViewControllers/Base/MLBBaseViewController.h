//
//  MLBBaseViewController.h
//  MyOne3
//
//  Created by meilbn on 2/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLBBaseViewController : UIViewController

#pragma mark - HUD

- (void)showHUDWithText:(NSString *)text delay:(NSTimeInterval)delay;
- (void)showHUDDone;
- (void)showHUDDoneWithText:(NSString *)text;
- (void)showHUDErrorWithText : (NSString *)text;
- (void)showHUDNetError;
- (void)showHUDServerError;
- (void)showWithLabelText:(NSString *)showText executing:(SEL)method;
- (void)showHUDWithText:(NSString *)text;
- (void)modelTransformFailedWithError:(NSError *)error;
/**
 *  隐藏当前显示的提示框
 */
- (void)hideHud;

#pragma mark - UI

- (void)addNavigationBarRightItems;

- (void)endRefreshingScrollView:(UIScrollView *)scrollView hasMoreData:(BOOL)hasMoreData;

@end
