//
//  MLBReadSerial.h
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"
#import "MLBAuthor.h"

@interface MLBReadSerial : MLBBaseModel

@property (nonatomic, copy) NSString *contentId;
@property (nonatomic, copy) NSString *serialId;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *excerpt;
@property (nonatomic, copy) NSString *readNum;
@property (nonatomic, copy) NSString *makeTime;
@property (nonatomic, strong) MLBAuthor *author;
@property (nonatomic, assign) BOOL hasAudio;

@end
