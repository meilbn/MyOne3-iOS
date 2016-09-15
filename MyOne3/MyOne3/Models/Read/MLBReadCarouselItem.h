//
//  MLBReadCarouselItem.h
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"

@interface MLBReadCarouselItem : MLBBaseModel

@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *bottomText;
@property (nonatomic, strong) NSString *bgColor;
@property (nonatomic, strong) NSString *pvURL;

@end
