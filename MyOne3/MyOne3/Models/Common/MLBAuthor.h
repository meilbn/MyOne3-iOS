//
//  MLBAuthor.h
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"

@interface MLBAuthor : MLBBaseModel

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *webURL;
@property (nonatomic, strong) NSString *wbName;
@property (nonatomic, strong) NSString *desc;

@end
