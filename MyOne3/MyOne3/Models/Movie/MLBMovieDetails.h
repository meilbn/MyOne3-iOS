//
//  MLBMovieDetails.h
//  MyOne3
//
//  Created by meilbn on 3/2/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"

@interface MLBMovieDetails : MLBBaseModel

@property (nonatomic, copy) NSString *movieId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *indexCover;
@property (nonatomic, copy) NSString *detailCover;
@property (nonatomic, copy) NSString *videoURL;
@property (nonatomic, copy) NSString *review;
@property (nonatomic, copy) NSString *keywords;
@property (nonatomic, copy) NSString *movieLongId;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *officialStory;
@property (nonatomic, copy) NSString *chargeEditor;
@property (nonatomic, copy) NSString *webURL;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *makeTime;
@property (nonatomic, copy) NSString *lastUpdateDate;
@property (nonatomic, copy) NSString *verse;
@property (nonatomic, copy) NSString *verseEn;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *revisedScore;
@property (nonatomic, copy) NSString *releaseTime;
@property (nonatomic, copy) NSString *scoreTime;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, copy) NSArray *photos;
@property (nonatomic, assign) NSTimeInterval serverTime;

@end
