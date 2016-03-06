//
//  MLBMovieListItem.h
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"

@interface MLBMovieListItem : MLBBaseModel

@property (nonatomic, copy) NSString *movieId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *verse;
@property (nonatomic, copy) NSString *verseEn;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *revisedScore;
@property (nonatomic, copy) NSString *releaseTime;
@property (nonatomic, copy) NSString *scoreTime;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, assign) NSTimeInterval serverTime;

@end
