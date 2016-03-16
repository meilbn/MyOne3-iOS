//
//  MLBMacros.h
//  COCOON
//
//  Created by meilbn on 11/24/15.
//  Copyright © 2015 cocoon. All rights reserved.
//

#ifndef MLBMacros_h
#define MLBMacros_h



#pragma mark - UI / 屏幕、控件尺寸

#define kKeyWindow [UIApplication sharedApplication].keyWindow

#define isRetina                  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define isPad                     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define BottomEdgeYOfView(view)   view.frame.origin.y + view.frame.size.height
// 屏幕高度
#define SCREEN_HEIGHT             [[UIScreen mainScreen] bounds].size.height
// 屏幕宽度
#define SCREEN_WIDTH              [[UIScreen mainScreen] bounds].size.width
#define FULL_WIDTH                SCREEN_WIDTH
#define FULL_HEIGHT               (SCREEN_HEIGHT - ((SYSTEM_VERSION >= 7) ? 0 : STATUSBAR_HEIGHT))
#define CONTENT_HEIGHT            (FULL_HEIGHT - NAVBAR_HEIGHT)

#define Device_Is_iPhone5         ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define Device_Is_iPhone6         ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define Device_Is_iPhone6Plus     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define DEVICE_UUID               [[[UIDevice currentDevice] identifierForVendor] UUIDString]

#define KEYBOARD_HEIGHT           216

// 获取 View 的 frame 的属性
#define GetViewWidth(view)  view.frame.size.width
#define GetViewHeight(view) view.frame.size.height
#define GetViewX(view)      view.frame.origin.x
#define GetViewY(view)      view.frame.origin.y

#define ScaleFrom_iPhone5_Desgin(_X_) (_X_ * (320 / SCREEN_WIDTH))

#pragma mark - color / 颜色

#define UIColorFromRGB(rgbValue)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]
#define ColorWithRGBA(r,g,b,a)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define ColorWithWhite(w)         [UIColor colorWithWhite:w alpha:1]
#define ColorWithWhiteAlpha(w,a)  [UIColor colorWithWhite:w alpha:a]
#define RGBA(r,g,b,a)             [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r,g,b)                [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

// 字体
#pragma mark - font
#define FontWithNameSize(name, size)    [UIFont fontWithName:name size:size]
#define FontWithSize(size)              [UIFont systemFontOfSize:size]
#define ScoreFontWithSize(fontSize)     [UIFont fontWithName:@"Bradley Hand" size:fontSize]
#define BoldFontWithSize(size)          [UIFont boldSystemFontOfSize:size]
#define BoldSystemFont(size)            [UIFont boldSystemFontOfSize:size]
#define systemFont(size)                [UIFont systemFontOfSize:size]

#pragma mark - GCD
// 单例
#define DISPATCH_ONCE_BLOCK(onceBlock); static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);
// 直接一行搞定
//DISPATCH_ONCE_BLOCK(^{
//    sharedService = [XXX new];
//});

// 在Main线程上运行
#define DISPATCH_ON_MAIN_THREAD(mainQueueBlock); dispatch_async(dispatch_get_main_queue(), mainQueueBlock);

// 在Global Queue上运行
#define DISPATCH_ON_GLOBAL_QUEUE_HIGH(globalQueueBlock)       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), globalQueueBlock)
#define DISPATCH_ON_GLOBAL_QUEUE_DEFAULT(globalQueueBlock)    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlock)
#define DISPATCH_ON_GLOBAL_QUEUE_LOW(globalQueueBlock)        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), globalQueueBlock)
#define DISPATCH_ON_GLOBAL_QUEUE_BACKGROUND(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), globalQueueBlock)
// 主线程上
//DISPATCH_ON_MAIN_THREAD(^{
//    // 更新UI
//});

//Global Queue
//DISPATCH_ON_GLOBAL_QUEUE_DEFAULT(^{
//    // 异步耗时任务
//});

#pragma mark - Device / 设备版本

#define CURRENT_IOS_VERSION       [[[UIDevice currentDevice] systemVersion] floatValue]
#define CURRENT_SYSTEN_VERSION    [[UIDevice currentDevice] systemVersion]
#define CURRENT_SOFT_VERSION      [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]
#define CURRENT_LANGUAGE          [[NSLocale preferredLanguages] objectAtIndex:0]
#define IS_IOS7_LATER             (CURRENT_IOS_VERSION >= 7.0)
#define IS_IOS8_LATER             (CURRENT_IOS_VERSION >= 8.0)
#define STATUSBAR_HEIGHT          [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVBAR_HEIGHT             (44.f + ((SYSTEM_VERSION >= 7) ? STATUSBAR_HEIGHT : 0))

#pragma mark - 字符串

// 是否为中文
#define IS_CH_SYMBOL(chr)               ((int)(chr)>127)
#define StringByTrimWhiteSpace(text)    [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
#define IsStringEmpty(string)           (!string || [@"" isEqualToString:string])
#define IsStringNotEmpty(string)        (string && ![@"" isEqualToString:string])

#pragma mark - Resources / 资源
// 图片
#define ImageWithFile(fileName, type)   [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:type]]

#pragma mark - Log

// 输出 rect，size 和 point
#define NSLogRect(rect)         NSLog(@"%s x:%.4f, y:%.4f, w:%.4f, h:%.4f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define NSLogSize(size)         NSLog(@"%s w:%.4f, h:%.4f", #size, size.width, size.height)
#define NSLogPoint(point)       NSLog(@"%s x:%.4f, y:%.4f", #point, point.x, point.y)
#define NSLogBOOL(msg, b)       NSLog(@"%@ = %@", msg, b ? @"YES" : @"NO");
#define NSLogError(error)       NSLog(@"error = %@", error)

#pragma mark - Common

#define UserDefaults            [NSUserDefaults standardUserDefaults]

#pragma mark - Path

#define DocumentsDirectory      [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define AppDirectory            [[NSBundle mainBundle] bundlePath]

// app sandbox
#define PATH_OF_APP_HOME        NSHomeDirectory()
#define PATH_OF_TEMP            NSTemporaryDirectory()
#define PATH_OF_DOCUMENT        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]



#endif /* MLBMacros_h */
