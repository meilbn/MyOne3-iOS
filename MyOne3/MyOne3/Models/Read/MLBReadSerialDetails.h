//
//  MLBReadSerialDetails.h
//  MyOne3
//
//  Created by meilbn on 2/26/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"
#import "MLBAuthor.h"

@interface MLBReadSerialDetails : MLBBaseModel

@property (nonatomic, strong) NSString *contentId;
@property (nonatomic, strong) NSString *serialId;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *excerpt;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *chargeEditor;
@property (nonatomic, strong) NSString *readNum;
@property (nonatomic, strong) NSString *makeTime;
@property (nonatomic, strong) NSString *lastUpdateDate;
@property (nonatomic, strong) NSString *audioURL;
@property (nonatomic, strong) NSString *webURL;
@property (nonatomic, strong) NSString *inputName;
@property (nonatomic, strong) NSString *lastUpdateName;
@property (nonatomic, strong) MLBAuthor *author;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, assign) NSInteger commentNum;
@property (nonatomic, assign) NSInteger shareNum;

@end
