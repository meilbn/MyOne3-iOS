//
//  MLBMusicDetails.h
//  MyOne3
//
//  Created by meilbn on 2/23/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"
#import "MLBAuthor.h"

@interface MLBMusicDetails : MLBBaseModel

@property (nonatomic, copy) NSString *musicId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *isFirst;
@property (nonatomic, copy) NSString *storyTitle;
@property (nonatomic, copy) NSString *story;
@property (nonatomic, copy) NSString *lyric;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *musicURL;
@property (nonatomic, copy) NSString *chargeEditor;
@property (nonatomic, copy) NSString *relatedTo;
@property (nonatomic, copy) NSString *webURL;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *makeTime;
@property (nonatomic, copy) NSString *lastUpdateDate;
@property (nonatomic, copy) MLBAuthor *author;
@property (nonatomic, copy) MLBAuthor *storyAuthor;

@end
