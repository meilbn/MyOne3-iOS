//
//  Constants.h
//  MyOne3
//
//  Created by meilbn on 2/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#pragma mark - NSString

#define MLBHomeTitle                            @"首页"
#define MLBReadTitle                            @"阅读"
#define MLBMusicTitle                           @"音乐"
#define MLBMovieTitle                           @"电影"

// Hint
#define BAD_NETWORK                             @"网络连接失败"
#define SERVER_ERROR                            @"服务器连接失败"

#pragma mark - UIColor

#define MLBAppThemeColor                        [UIColor colorWithRed:142 / 255.0 green:182 / 255.0 blue:230 / 255.0 alpha:1]// #8EB6E6
#define MLBNavigationBarTitleTextColor          [UIColor colorWithRed:78 / 255.0 green:92 / 255.0 blue:108 / 255.0 alpha:1]// #4E5C6C
#define MLBViewControllerBGColor                [UIColor colorWithRed:250 / 255.0 green:252 / 255.0 blue:255 / 255.0 alpha:1]// #FAFCFF
#define MLBScoreTextColor                       [UIColor colorWithRed:240 / 255.0 green:89 / 255.0 blue:93 / 255.0 alpha:1]// #F0595D
#define MLBLightBlackTextColor                  [UIColor colorWithWhite:90 / 255.0 alpha:1]// #5A5A5A
#define MLBDarkBlackTextColor                   [UIColor colorWithWhite:51 / 255.0 alpha:1]// #333333
#define MLBDarkGrayTextColor                    [UIColor colorWithWhite:173 / 255.0 alpha:1]// #ADADAD
#define MLBGrayTextColor                        [UIColor colorWithWhite:177 / 255.0 alpha:1]// #B1B1B1
#define MLBLightGrayTextColor                   [UIColor colorWithWhite:198 / 255.0 alpha:1]// #C6C6C6
#define MLBSeparatorColor                       [UIColor colorWithWhite:229 / 255.0 alpha:1]// #E5E5E5
#define MLBShadowColor                          [UIColor colorWithWhite:102 / 255.0 alpha:1]// #666666

#pragma mark - Digital

// HUD
#define HUD_DELAY                               1.5

#define MLBPullToRefreshBorderWidth             4

#pragma mark - Path

#define MLBCacheFilesFolderName                 @"CacheFiles"

// 首页图文列表
#define MLBCacheHomeItemFileName                @"MLBCacheHomeItem"
#define MLBCacheHomeItemFilePath                [NSString stringWithFormat:@"%@/%@/%@", DocumentsDirectory, MLBCacheFilesFolderName, MLBCacheHomeItemFileName]

// 阅读轮播列表
#define MLBCacheReadingCarouselFileName         @"MLBCacheReadingCarousel"
#define MLBCacheReadingCarouselFilePath         [NSString stringWithFormat:@"%@/%@/%@", DocumentsDirectory, MLBCacheFilesFolderName, MLBCacheReadingCarouselFileName]
// 阅读文章索引列表
#define MLBCacheReadingIndexFileName            @"MLBCacheReadingIndex"
#define MLBCacheReadingIndexFilePath            [NSString stringWithFormat:@"%@/%@/%@", DocumentsDirectory, MLBCacheFilesFolderName, MLBCacheReadingIndexFileName]

// 电影列表
#define MLBCacheMovieListFileName               @"MLBCacheMovieList"
#define MLBCacheMovieListFilePath               [NSString stringWithFormat:@"%@/%@/%@", DocumentsDirectory, MLBCacheFilesFolderName, MLBCacheMovieListFileName]

#pragma mark - NSUserDefault

#define MLBLastShowIntroduceVersionAndBuild     @"MLBLastShowIntroduceVersionAndBuild"

#endif /* Constants_h */
