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

@property (nonatomic, strong) NSString *storyId;
@property (nonatomic, strong) NSString *movieId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, strong) NSString *inputDate;
@property (nonatomic, strong) NSString *storyType;
@property (nonatomic, strong) MLBUser *user;

@end
