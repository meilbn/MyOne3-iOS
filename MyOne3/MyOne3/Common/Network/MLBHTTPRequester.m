//
//  MLBHTTPRequester.m
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBHTTPRequester.h"
#import "MLBApiConstants.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

@implementation MLBHTTPRequester

#pragma mark - Private Class Method

+ (AFHTTPSessionManager *)AFHTTPSessionManager {
    static AFHTTPSessionManager *manager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[AFHTTPSessionManager alloc] init];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    });
    
    return manager;
}

+ (NSString *)urlWithApi:(NSString *)api {
    return [NSString stringWithFormat:@"%@%@", MLBApiServerAddress, api];
}

+ (void)postWithApi:(NSString *)api success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    AFHTTPSessionManager *manager = [MLBHTTPRequester AFHTTPSessionManager];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [manager POST:[MLBHTTPRequester urlWithApi:api] parameters:nil constructingBodyWithBlock:NULL progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DDLogDebug(@"operation = %@, error = %@", task, error);
        if (failBlock) {
            failBlock(error);
        }
    }];
}

+ (void)getWithURI:(NSString *)api success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    AFHTTPSessionManager *manager = [MLBHTTPRequester AFHTTPSessionManager];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [manager GET:[MLBHTTPRequester urlWithApi:api] parameters:nil progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DDLogDebug(@"operation = %@, error = %@", task, error);
        if (failBlock) {
            failBlock(error);
        }
    }];
}

#pragma mark - Public Class Method

#pragma mark - get Api String

+ (NSString *)apiStringForReadDetailsWithReadType:(MLBReadType)readType {
    if (readType == MLBReadTypeSerial) {
        return MLBApiSerialContent;
    } else {
        return [MLBHTTPRequester apiStringForReadWithReadType:readType];
    }
}

+ (NSString *)apiStringForReadWithReadType:(MLBReadType)readType {
    switch (readType) {
        case MLBReadTypeEssay:
            return MLBApiEssay;
        case MLBReadTypeSerial:
            return MLBApiSerial;
        case MLBReadTypeQuestion:
            return MLBApiQuestion;
    }
}

+ (NSString *)apiStringForMusic {
    return MLBApiMusic;
}

+ (NSString *)apiStringForMovie {
    return MLBApiMovie;
}

+ (NSString *)apiStringForSearchWithSearchType:(MLBSearchType)type {
    switch (type) {
        case MLBSearchTypeHome:
            return MLBApiHomePage;
        case MLBSearchTypeRead:
            return MLBApiReading;
        case MLBSearchTypeMusic:
            return MLBApiMusic;
        case MLBSearchTypeMovie:
            return MLBApiMovie;
        case MLBSearchTypeAuthor:
            return MLBApiAuthor;
        default:
            return @"";
    }
}

#pragma mark - Common

+ (void)requestPraiseCommentsWithType:(NSString *)type itemId:(NSString *)itemId firstItemId:(NSString *)firstItemId success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiGetPraiseComments, type, itemId, firstItemId] success:successBlock fail:failBlock];
}

+ (void)requestTimeCommentsWithType:(NSString *)type itemId:(NSString *)itemId firstItemId:(NSString *)firstItemId success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiGetTimeComments, type, itemId, firstItemId] success:successBlock fail:failBlock];
}

+ (void)requestReadDetailsWithType:(NSString *)type itemId:(NSString *)itemId success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiGetReadDetails, type, itemId] success:successBlock fail:failBlock];
}

+ (void)requestRelatedsWithType:(NSString *)type itemId:(NSString *)itemId success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiGetRelateds, type, itemId] success:successBlock fail:failBlock];
}

// 搜索
+ (void)searchWithType:(NSString *)type keywords:(NSString *)keywords success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiSearching, type, [keywords mlb_encodedURL]] success:successBlock fail:failBlock];
}

#pragma mark - Home Page

// 首页图文列表
+ (void)requestHomeMoreWithSuccess:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:MLBApiHomePageMore success:successBlock fail:failBlock];
}

// 首页指定月份的图文列表
+ (void)requestHomeByMonthWithPeriod:(NSString *)period success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiHomePageByMonth, period] success:successBlock fail:failBlock];
}

#pragma mark - Read

// 头部轮播列表
+ (void)requestReadCarouselWithSuccess:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:MLBApiReadingCarousel success:successBlock fail:failBlock];
}

+ (void)requestReadCarouselDetailsById:(NSString *)carouselId success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:@"%@/%@", MLBApiReadingCarousel, carouselId] success:successBlock fail:failBlock];
}

// 文章列表
+ (void)requestReadIndexWithSuccess:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:MLBApiReadingIndex success:successBlock fail:failBlock];
}

// 短篇文章详情
+ (void)requestEssayDetailsById:(NSString *)essayId success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiEssayDetailsById, essayId] success:successBlock fail:failBlock];
}

// 短篇文章评论列表
+ (void)requestEssayCommentsById:(NSString *)essayId success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester requestPraiseCommentsWithType:MLBApiEssay itemId:essayId firstItemId:0 success:successBlock fail:failBlock];
}

// 短篇文章相关列表
+ (void)requestEssayRelatedsById:(NSString *)essayId success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiGetRelateds, MLBApiEssay, essayId] success:successBlock fail:failBlock];
}

// 连载文章列表
+ (void)requestSerialListById:(NSString *)serialId success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiSerialList, serialId] success:successBlock fail:failBlock];
}

// 指定月份的短篇文章列表
+ (void)requestEssayByMonthWithPeriod:(NSString *)period success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiReadByMonth, MLBApiEssay, period] success:successBlock fail:failBlock];
}

// 指定月份的连载文章列表
+ (void)requestSerialByMonthWithPeriod:(NSString *)period success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiReadByMonth, MLBApiSerialContent, period] success:successBlock fail:failBlock];
}

// 指定月份的问题列表
+ (void)requestQuestionByMonthWithPeriod:(NSString *)period success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiReadByMonth, MLBApiQuestion, period] success:successBlock fail:failBlock];
}

#pragma mark - Music

+ (void)requestMusicIdListWithSuccess:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:MLBApiMusicIdList success:successBlock fail:failBlock];
}

// 音乐详情
+ (void)requestMusicDetailsById:(NSString *)musicId success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiMusicDetailsById, musicId] success:successBlock fail:failBlock];
}

// 音乐详情评论点赞数降序排序列表
+ (void)requestMusicDetailsPraiseCommentsById:(NSString *)musicId success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester requestPraiseCommentsWithType:MLBApiMusic itemId:musicId firstItemId:0 success:successBlock fail:failBlock];
}

// 音乐详情相似歌曲列表
+ (void)requestMusicDetailsRelatedMusicsById:(NSString *)musicId success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiGetRelateds, MLBApiMusic, musicId] success:successBlock fail:failBlock];
}

// 指定月份的音乐列表
+ (void)requestMusicByMonthWithPeriod:(NSString *)period success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiMusicByMonth, period] success:successBlock fail:failBlock];
}

#pragma mark - Movie

// 获取电影列表
+ (void)requestMovieListWithOffer:(NSInteger)offset success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiMovieList, offset] success:successBlock fail:failBlock];
}

// 获取电影详情
+ (void)requestMovieDetailsById:(NSString *)movieId success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiMovieDetails, movieId] success:successBlock fail:failBlock];
}

// 获取电影故事列表
+ (void)requestMovieDetailsMovieStoriesById:(NSString *)movieId success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiMovieStories, movieId, @"1", @"0"] success:successBlock fail:failBlock];
}

+ (void)requestMovieStoriesById:(NSString *)movieId firstItemId:(NSString *)firstItemId forDetails:(BOOL)forDetails success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiMovieStories, movieId, forDetails ? @"1" : @"0", firstItemId] success:successBlock fail:failBlock];
}

// 获取电影短评列表
+ (void)requestMovieDetailsMovieReviewsById:(NSString *)movieId success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiMovieReviews, movieId, @"1", @"0"] success:successBlock fail:failBlock];
}

+ (void)requestMovieReviewsById:(NSString *)movieId firstItemId:(NSString *)firstItemId forDetails:(BOOL)forDetails success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiMovieReviews, movieId, forDetails ? @"1" : @"0", firstItemId] success:successBlock fail:failBlock];
}

// 获取电影评论列表
+ (void)requestMovieDetailsPraiseCommentsById:(NSString *)movieId success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiGetPraiseComments, MLBApiMovie, movieId, @"0"] success:successBlock fail:failBlock];
}

@end
