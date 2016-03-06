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

@property (nonatomic, copy) NSString *reviewId;
@property (nonatomic, copy) NSString *movieId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *inputDate;
@property (nonatomic, copy) MLBAuthor *author;

@end
