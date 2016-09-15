//
//  MLBComment.h
//  MyOne3
//
//  Created by meilbn on 2/23/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"
#import "MLBUser.h"

typedef NS_ENUM(NSUInteger, MLBCommentType) {
	MLBCommentTypeHot, // 热门评论
	MLBCommentTypeNormal, // 普通评论
};

@interface MLBComment : MLBBaseModel

@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) NSString *quote;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, strong) NSString *inputDate;
@property (nonatomic, strong) MLBUser *user;
@property (nonatomic, strong) MLBUser *toUser;
@property (nonatomic, assign) MLBCommentType commentType;

@property (nonatomic, assign) NSInteger numberOflines;
@property (nonatomic, assign, getter=isUnfolded) BOOL unfolded; // 是否已经展开

@property (nonatomic, assign, getter=isLastHotComment) BOOL lastHotComment;

@end
