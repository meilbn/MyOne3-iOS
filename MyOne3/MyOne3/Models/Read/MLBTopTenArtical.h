//
//  MLBTopTenArtical.h
//  MyOne3
//
//  Created by meilbn on 2/27/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"

@interface MLBTopTenArtical : MLBBaseModel

@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *introduction;
@property (nonatomic, strong) NSString *authorName;
@property (nonatomic, strong) NSString *webURL;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, strong) NSString *type;

@end
