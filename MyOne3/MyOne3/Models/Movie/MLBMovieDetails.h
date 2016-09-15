//
//  MLBMovieDetails.h
//  MyOne3
//
//  Created by meilbn on 3/2/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"

@interface MLBMovieDetails : MLBBaseModel

@property (nonatomic, strong) NSString *movieId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *indexCover;
@property (nonatomic, strong) NSString *detailCover;
@property (nonatomic, strong) NSString *videoURL;
@property (nonatomic, strong) NSString *review;
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) NSString *movieLongId;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *officialStory;
@property (nonatomic, strong) NSString *chargeEditor;
@property (nonatomic, strong) NSString *webURL;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *makeTime;
@property (nonatomic, strong) NSString *lastUpdateDate;
@property (nonatomic, strong) NSString *verse;
@property (nonatomic, strong) NSString *verseEn;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *revisedScore;
@property (nonatomic, strong) NSString *releaseTime;
@property (nonatomic, strong) NSString *scoreTime;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, assign) NSTimeInterval serverTime;

@end
