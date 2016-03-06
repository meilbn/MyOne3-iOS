//
//  MLBUIFactory.h
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface MLBUIFactory : NSObject

#pragma mark - UIView

+ (UIView *)separatorLine;

#pragma mark - UIBUtton

+ (UIButton *)buttonWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName target:(id)target action:(SEL)action;

+ (UIButton *)buttonWithImageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName target:(id)target action:(SEL)action;

+ (UIButton *)buttonWithBackgroundImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName target:(id)target action:(SEL)action;

+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(NSInteger)fontSize target:(id)target action:(SEL)action;

#pragma mark - MJRefresh

+ (void)addMJRefreshTo:(UIScrollView *)scrollView target:(id)target refreshAction:(SEL)refreshAction loadMoreAction:(SEL)loadMoreAction;

+ (void)myOne_addMJRefreshTo:(UIScrollView *)scrollView target:(id)target refreshAction:(SEL)refreshAction loadMoreAction:(SEL)loadMoreAction;

@end
