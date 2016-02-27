//
//  MLBApiConstants.h
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#ifndef MLBApiConstants_h
#define MLBApiConstants_h

#pragma mark - Common

// 服务器地址
#define MLBApiServerAddress                     @"http://v3.wufazhuce.com:8000/api"

// 获取文章详情
#define MLBApiGetReadDetails                    @"/%@/%@"

// 获取评论列表
#define MLBApiGetComments                       @"/comment/praise/%@/%@/%@"

// 获取相关列表
#define MLBApiGetRelateds                       @"/related/%@/%@"

// 获取相关列表
#define MLBApiGetRelateds                       @"/related/%@/%@"

#pragma mark - Home Page

// 首页图文列表
#define MLBApiHomePageMore                      @"/hp/more/0"
// 月的首页图文列表
#define MLBApiHomePageByMonth                   @"/hp/bymonth/%@"

#pragma mark - Read

// 短篇
#define MLBApiEssay                             @"essay"
// 连载
#define MLBApiSerial                            @"serial"
#define MLBApiSerialContent                     @"serialcontent"
// 问题
#define MLBApiQuestion                          @"question"

// 阅读头部轮播列表
#define MLBApiReadingCarousel                   @"/reading/carousel"
// 阅读文章索引列表
#define MLBApiReadingIndex                      @"/reading/index"
// 短篇文章详情
#define MLBApiEssayDetailsById                  @"/essay/%@"

#pragma mark - Music

// 音乐
#define MLBApiMusic                             @"music"
// 音乐Id列表
#define MLBApiMusicIdList                       @"/music/idlist/0"
// 音乐详情
#define MLBApiMusicDetailsById                  @"/music/detail/%@"

#pragma mark - Movie

// 电影列表
#define MLBApiMovieList                         @"/movie/list/%ld"


#endif /* MLBApiConstants_h */
