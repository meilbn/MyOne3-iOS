//
//  UIView+MyOne.h
//  MyOne3
//
//  Created by meilbn on 9/9/16.
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

@interface UIView (MyOne)

/**
 *  显示分享菜单
 *
 *  @param block 菜单 item 点击回调
 */
- (void)mlb_showPopMenuViewWithMenuSelectedBlock:(MenuSelectedBlock)block;

/**
 *  展示图片
 *
 *  @param image         要展示的图片
 *  @param referenceRect 尺寸大小
 *  @param referenceView 父视图
 */
- (void)blowUpImage:(UIImage *)image referenceRect:(CGRect)referenceRect referenceView:(UIView *)referenceView;

@end
