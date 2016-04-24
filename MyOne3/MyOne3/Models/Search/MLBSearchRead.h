//
//  MLBSearchRead.h
//  MyOne3
//
//  Created by meilbn on 4/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"

@interface MLBSearchRead : MLBBaseModel

@property (nonatomic, copy) NSString *readId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger number;

@end
