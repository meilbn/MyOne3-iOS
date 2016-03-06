//
//  MLBMovieStory.h
//  MyOne3
//
//  Created by meilbn on 3/2/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"
#import "MLBUser.h"

@interface MLBMovieStory : MLBBaseModel

@property (nonatomic, copy) NSString *storyId;
@property (nonatomic, copy) NSString *movieId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, copy) NSString *inputDate;
@property (nonatomic, copy) NSString *storyType;
@property (nonatomic, copy) MLBUser *user;

@end
