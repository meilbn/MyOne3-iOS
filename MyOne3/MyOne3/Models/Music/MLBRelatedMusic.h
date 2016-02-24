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

@property (nonatomic, copy) NSString *musicId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *platform;
@property (nonatomic, copy) NSString *musicLongId;
@property (nonatomic, copy) MLBAuthor *author;

@end
