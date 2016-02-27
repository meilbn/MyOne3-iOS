//
//  MLBHTTPRequester.m
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBHTTPRequester.h"
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

#pragma mark - Common

+ (void)requestCommentsWithType:(NSString *)type itemId:(NSString *)itemId offset:(NSInteger)offset success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiGetComments, MLBApiEssay, itemId, [@(offset) stringValue]] success:successBlock fail:failBlock];
}

+ (void)requestReadDetailsWithType:(NSString *)type itemId:(NSString *)itemId success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiGetReadDetails, type, itemId] success:successBlock fail:failBlock];
}

+ (void)requestRelatedsWithType:(NSString *)type itemId:(NSString *)itemId success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiGetRelateds, type, itemId] success:successBlock fail:failBlock];
}

#pragma mark - Home Page

// 首页图文列表
+ (void)requestHomeMoreWithSuccess:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:MLBApiHomePageMore success:successBlock fail:failBlock];
}

#pragma mark - Read

// 头部轮播列表
+ (void)requestReadCarouselWithSuccess:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:MLBApiReadingCarousel success:successBlock fail:failBlock];
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
    [MLBHTTPRequester requestCommentsWithType:MLBApiEssay itemId:essayId offset:0 success:successBlock fail:failBlock];
}

// 短篇文章相关列表
+ (void)requestEssayRelatedsById:(NSString *)essayId success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiGetRelateds, MLBApiEssay, essayId] success:successBlock fail:failBlock];
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
    [MLBHTTPRequester requestCommentsWithType:MLBApiMusic itemId:musicId offset:0 success:successBlock fail:failBlock];
}

// 音乐详情相似歌曲列表
+ (void)requestMusicDetailsRelatedMusicsById:(NSString *)musicId success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiGetRelateds, MLBApiMusic, musicId] success:successBlock fail:failBlock];
}

#pragma mark - Movie

// 获取电影列表
+ (void)requestMovieListWithOffer:(NSInteger)offset success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiMovieList, offset] success:successBlock fail:failBlock];
}

@end
