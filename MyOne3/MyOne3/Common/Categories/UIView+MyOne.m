//
//  UIView+MyOne.m
//  MyOne3
//
//  Created by meilbn on 9/9/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "UIView+MyOne.h"
#import "PopMenu.h"
#import "MenuButton.h"

@implementation UIView (MyOne)

/**
 *  显示分享菜单
 *
 *  @param block 菜单 item 点击回调
 */
- (void)mlb_showPopMenuViewWithMenuSelectedBlock:(MenuSelectedBlock)block {
	NSArray *imgNames = @[@"more_wechat", @"more_moments", @"more_sina", @"more_qq", @"more_link", @"more_collection"];
	NSArray *titles = @[@"微信好友", @"朋友圈", @"微博", @"QQ", @"复制链接", @"收藏"];
	NSArray *colors = @[[UIColor colorWithRGBHex:0x70E08D],
						[UIColor colorWithRGBHex:0x70E08D],
						[UIColor colorWithRGBHex:0xFF8467],
						[UIColor colorWithRGBHex:0x49AFD6],
						[UIColor colorWithRGBHex:0x659AD9],
						[UIColor colorWithRGBHex:0xF6CC41]];
	NSMutableArray *items = [NSMutableArray arrayWithCapacity:imgNames.count];
	for (NSInteger i = 0; i < imgNames.count; i++) {
		MenuItem *item = [[MenuItem alloc] initWithTitle:titles[i] iconName:imgNames[i] glowColor:colors[i] index:i];
		[items addObject:item];
	}
	
	PopMenu *popMenu = [[PopMenu alloc] initWithFrame:kKeyWindow.bounds items:items];
	popMenu.menuAnimationType = kPopMenuAnimationTypeSina;
	popMenu.perRowItemCount = 1;
	popMenu.didSelectedItemCompletion = ^(MenuItem *selectedItem) {
		if (block) {
			block((MLBPopMenuType)selectedItem.index);
		}
	};
	
	[popMenu showMenuAtView:kKeyWindow];
}

/**
 *  展示图片
 *
 *  @param image         要展示的图片
 *  @param referenceRect 尺寸大小
 *  @param referenceView 父视图
 */
- (void)blowUpImage:(UIImage *)image referenceRect:(CGRect)referenceRect referenceView:(UIView *)referenceView {
	// Create image info
	JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
	imageInfo.image = image;
	imageInfo.referenceRect = referenceRect;
	imageInfo.referenceView = referenceView;
	
	// Setup view controller
	JTSImageViewController *imageViewer = [[JTSImageViewController alloc] initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
	
	// Present the view controller.
	[imageViewer showFromViewController:kKeyWindow.rootViewController transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

@end
