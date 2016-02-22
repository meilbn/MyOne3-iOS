//
//  MLBHTTPRequester.h
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import <Foundation/Foundation.h>

// 成功，失败 block
typedef void(^SuccessBlock)(id responseObject);
typedef void(^FailBlock)(NSError *error);

@interface MLBHTTPRequester : NSObject

#pragma mark - Reading

// 头部轮播列表
+ (void)requestReadingCarouselWithSuccess:(SuccessBlock)successBlock fail:(FailBlock)failBlock;

// 文章列表
+ (void)requestReadingIndexWithSuccess:(SuccessBlock)successBlock fail:(FailBlock)failBlock;

#pragma mark - Movie

// 获取电影列表
+ (void)requestMovieListWithOffer:(NSInteger)offset success:(SuccessBlock)successBlock fail:(FailBlock)failBlock;

@end
