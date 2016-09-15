//
//  MLBHomeItem.h
//  MyOne3
//
//  Created by meilbn on 2/22/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"

@interface MLBHomeItem : MLBBaseModel

@property (nonatomic, strong) NSString *contentId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *imageOriginalURL;
@property (nonatomic, strong) NSString *authorId;
@property (nonatomic, strong) NSString *authorName;
@property (nonatomic, strong) NSString *iPadURL;
@property (nonatomic, strong) NSString *makeTime;
@property (nonatomic, strong) NSString *lastUpdateDate;
@property (nonatomic, strong) NSString *webURL;
@property (nonatomic, strong) NSString *wbImageURL;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, assign) NSInteger shareNum;
@property (nonatomic, assign) NSInteger commentNum;

@end
