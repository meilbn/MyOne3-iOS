//
//  MLBSerialList.h
//  MyOne3
//
//  Created by meilbn on 3/9/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"
#import "MLBReadSerial.h"

@interface MLBSerialList : MLBBaseModel

@property (nonatomic, strong) NSString *serialId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *finished;
@property (nonatomic, strong) NSArray *list;

@end
