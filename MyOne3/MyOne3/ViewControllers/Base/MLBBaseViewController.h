//
//  MLBBaseViewController.h
//  MyOne3
//
//  Created by meilbn on 2/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLBBaseViewController : UIViewController

@property (nonatomic, assign) BOOL hideNavigationBar;

- (CGFloat)navigationBarHeight; // including status bar height

#pragma mark - UI

// 右侧盆栽和音乐
//- (void)addNavigationBarRightItems;

// 左侧搜索按钮
- (void)addNavigationBarLeftSearchItem;

// 右侧"我"按钮
- (void)addNavigationBarRightMeItem;

// 右侧单独一个音乐
//- (void)addNavigationBarRightMusicItem;

#pragma mark - Action

- (void)presentLoginOptsViewController;

@end
