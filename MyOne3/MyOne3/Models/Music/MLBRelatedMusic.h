//
//  MLBRelatedMusic.h
//  MyOne3
//
//  Created by meilbn on 2/23/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"
#import "MLBAuthor.h"

@interface MLBRelatedMusic : MLBBaseModel

@property (nonatomic, strong) NSString *musicId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *platform;
@property (nonatomic, strong) NSString *musicLongId;
@property (nonatomic, strong) MLBAuthor *author;

@end
