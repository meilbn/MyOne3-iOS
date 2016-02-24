//
//  MLBApiConstants.h
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#ifndef MLBApiConstants_h
#define MLBApiConstants_h

// 服务器地址
#define MLBApiServerAddress                     @"http://v3.wufazhuce.com:8000/api"

#pragma mark - Home Page

// 首页图文列表
#define MLBApiHomePageMore                      @"/hp/more/0"
// 月的首页图文列表
#define MLBApiHomePageByMonth                   @"/hp/bymonth/%@"

#pragma mark - Reading

// 阅读头部轮播列表
#define MLBApiReadingCarousel                   @"/reading/carousel"
// 阅读文章索引列表
#define MLBApiReadingIndex                      @"/reading/index"

#pragma mark - Music

// 音乐Id列表
#define MLBApiMusicIdList                       @"/music/idlist/0"
// 音乐详情
#define MLBApiMusicDetailsById                  @"/music/detail/%@"
// 音乐详情评论点赞数降序排序列表
#define MLBApiMusicDetailsCommentsById          @"/comment/praise/music/%@/0"
// 音乐详情相似歌曲列表
#define MLBApiMusicDetailsRelatedMusicsById     @"/related/music/%@"

#pragma mark - Movie

// 电影列表
#define MLBApiMovieList                         @"/movie/list/%ld"


#endif /* MLBApiConstants_h */
