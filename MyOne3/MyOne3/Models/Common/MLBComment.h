//
//  MLBComment.h
//  MyOne3
//
//  Created by meilbn on 2/23/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"
#import "MLBUser.h"

@interface MLBComment : MLBBaseModel

@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *quote;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, copy) NSString *inputDate;
@property (nonatomic, copy) MLBUser *user;
@property (nonatomic, copy) MLBUser *toUser;
@property (nonatomic, copy) NSString *score;

@end
