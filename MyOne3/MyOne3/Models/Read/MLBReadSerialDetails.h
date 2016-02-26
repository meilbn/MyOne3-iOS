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

@property (nonatomic, copy) NSString *contentId;
@property (nonatomic, copy) NSString *serialId;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *excerpt;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *chargeEditor;
@property (nonatomic, copy) NSString *readNum;
@property (nonatomic, copy) NSString *makeTime;
@property (nonatomic, copy) NSString *lastUpdateDate;
@property (nonatomic, copy) NSString *audioURL;
@property (nonatomic, copy) NSString *webURL;
@property (nonatomic, copy) NSString *inputName;
@property (nonatomic, copy) NSString *lastUpdateName;
@property (nonatomic, strong) MLBAuthor *author;
@property (nonatomic, assign) NSInteger praiseNum;

@end
