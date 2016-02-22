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
//    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
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
//    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
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

#pragma mark - Reading

// 头部轮播列表
+ (void)requestReadingCarouselWithSuccess:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:MLBApiReadingCarousel success:successBlock fail:failBlock];
}

// 文章列表
+ (void)requestReadingIndexWithSuccess:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:MLBApiReadingIndex success:successBlock fail:failBlock];
}

#pragma mark - Movie

// 获取电影列表
+ (void)requestMovieListWithOffer:(NSInteger)offset success:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    [MLBHTTPRequester getWithURI:[NSString stringWithFormat:MLBApiMovieList, offset] success:successBlock fail:failBlock];
}

@end
