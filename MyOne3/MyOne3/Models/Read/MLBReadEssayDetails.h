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

@property (nonatomic, copy) NSString *contentId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, copy) NSString *authorDesc;
@property (nonatomic, copy) NSString *chargeEditor;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *makeTime;
@property (nonatomic, copy) NSString *wbName;
@property (nonatomic, copy) NSString *wbImageURL;
@property (nonatomic, copy) NSString *lastUpdateDate;
@property (nonatomic, copy) NSString *webURL;
@property (nonatomic, copy) NSString *guideWord;
@property (nonatomic, copy) NSString *audioURL;
@property (nonatomic, copy) NSArray *authors;
@property (nonatomic, assign) NSInteger praiseNum;

@end
