//
//  UIViewController+MLBShowSharesPopMenu.h
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

@interface UIViewController (MLBShowSharesPopMenu)

- (void)mlb_showPopMenuViewWithMenuSelectedBlock:(MenuSelectedBlock)block;

@end
