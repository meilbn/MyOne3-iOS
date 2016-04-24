//
//  MLBTopTenArtical.h
//  MyOne3
//
//  Created by meilbn on 2/27/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"

@interface MLBTopTenArtical : MLBBaseModel

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, copy) NSString *webURL;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, copy) NSString *type;

@end
