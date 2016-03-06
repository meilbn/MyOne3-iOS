//
//  MLBMovieStoryList.h
//  MyOne3
//
//  Created by meilbn on 3/2/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"
#import "MLBMovieStory.h"

@interface MLBMovieStoryList : MLBBaseModel

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSMutableArray *stories;

@end
