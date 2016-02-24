//
//  MLBCommentList.h
//  MyOne3
//
//  Created by meilbn on 2/23/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"
#import "MLBComment.h"

@interface MLBCommentList : MLBBaseModel

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSMutableArray *comments;

@end
