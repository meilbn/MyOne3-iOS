//
//  MLBReadCarouselItem.h
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"

@interface MLBReadCarouselItem : MLBBaseModel

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *bottomText;
@property (nonatomic, copy) NSString *bgColor;
@property (nonatomic, copy) NSString *pvURL;

@end
