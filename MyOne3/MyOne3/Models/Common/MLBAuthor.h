//
//  MLBAuthor.h
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"

@interface MLBAuthor : MLBBaseModel

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *webURL;
@property (nonatomic, copy) NSString *wbName;
@property (nonatomic, copy) NSString *desc;

@end
