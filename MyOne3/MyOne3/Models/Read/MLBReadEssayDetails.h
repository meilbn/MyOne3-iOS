//
//  MLBReadEssayDetails.h
//  MyOne3
//
//  Created by meilbn on 2/26/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"
#import "MLBAuthor.h"

@interface MLBReadEssayDetails : MLBBaseModel

@property (nonatomic, strong) NSString *contentId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *authorName;
@property (nonatomic, strong) NSString *authorDesc;
@property (nonatomic, strong) NSString *chargeEditor;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *makeTime;
@property (nonatomic, strong) NSString *wbName;
@property (nonatomic, strong) NSString *wbImageURL;
@property (nonatomic, strong) NSString *lastUpdateDate;
@property (nonatomic, strong) NSString *webURL;
@property (nonatomic, strong) NSString *guideWord;
@property (nonatomic, strong) NSString *audioURL;
@property (nonatomic, strong) NSArray *authors;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, assign) NSInteger shareNum;
@property (nonatomic, assign) NSInteger commentNum;

@end
