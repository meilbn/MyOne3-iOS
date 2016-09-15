//
//  MLBMovieReview.h
//  MyOne3
//
//  Created by meilbn on 3/2/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"
#import "MLBAuthor.h"

@interface MLBMovieReview : MLBBaseModel

@property (nonatomic, strong) NSString *reviewId;
@property (nonatomic, strong) NSString *movieId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *inputDate;
@property (nonatomic, strong) MLBAuthor *author;

@end
