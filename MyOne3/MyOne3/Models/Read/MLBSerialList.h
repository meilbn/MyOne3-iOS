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

@property (nonatomic, copy) NSString *serialId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *finished;
@property (nonatomic, copy) NSArray *list;

@end
