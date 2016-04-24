//
//  MLBBaseViewController.h
//  MyOne3
//
//  Created by meilbn on 2/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MLBPopMenuType) {
    MLBPopMenuTypeWechatFrined,// 微信好友
    MLBPopMenuTypeMoments,// 朋友圈
    MLBPopMenuTypeWeibo,// 微博
    MLBPopMenuTypeQQ,// QQ
    MLBPopMenuTypeCopyURL,// 复制链接
    MLBPopMenuTypeFavorite,// 收藏
};

typedef void(^MenuSelectedBlock)(MLBPopMenuType menuType);

@interface MLBBaseViewController : UIViewController

@property (nonatomic, assign) BOOL hideNavigationBar;

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

// 右侧盆栽和音乐
- (void)addNavigationBarRightItems;

// 左侧搜索按钮
- (void)addNavigationBarLeftSearchItem;

// 右侧"我"按钮
- (void)addNavigationBarRightMeItem;

// 右侧单独一个音乐
- (void)addNavigationBarRightMusicItem;

- (void)endRefreshingScrollView:(UIScrollView *)scrollView hasMoreData:(BOOL)hasMoreData;

- (void)showPopMenuViewWithMenuSelectedBlock:(MenuSelectedBlock)block;

#pragma mark - Action

- (void)presentLoginOptsViewController;

- (void)blowUpImage:(UIImage *)image referenceRect:(CGRect)referenceRect referenceView:(UIView *)referenceView;

@end
