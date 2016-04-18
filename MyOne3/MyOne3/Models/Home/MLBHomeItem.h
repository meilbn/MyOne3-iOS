//
//  MLBHomeItem.h
//  MyOne3
//
//  Created by meilbn on 2/22/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"

@interface MLBHomeItem : MLBBaseModel

@property (nonatomic, copy) NSString *contentId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *imageOriginalURL;
@property (nonatomic, copy) NSString *authorId;
@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, copy) NSString *iPadURL;
@property (nonatomic, copy) NSString *makeTime;
@property (nonatomic, copy) NSString *lastUpdateDate;
@property (nonatomic, copy) NSString *webURL;
@property (nonatomic, copy) NSString *wbImageURL;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, assign) NSInteger shareNum;
@property (nonatomic, assign) NSInteger commentNum;

@end
