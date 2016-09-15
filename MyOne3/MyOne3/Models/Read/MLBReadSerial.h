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

@property (nonatomic, strong) NSString *contentId;
@property (nonatomic, strong) NSString *serialId;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *excerpt;
@property (nonatomic, strong) NSString *readNum;
@property (nonatomic, strong) NSString *makeTime;
@property (nonatomic, strong) MLBAuthor *author;
@property (nonatomic, assign) BOOL hasAudio;

@end
