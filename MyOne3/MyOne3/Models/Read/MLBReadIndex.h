//
//  MLBReadIndex.h
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"
#import "MLBReadEssay.h"
#import "MLBReadSerial.h"
#import "MLBReadQuestion.h"

@interface MLBReadIndex : MLBBaseModel

@property (nonatomic, copy) NSArray *essay;
@property (nonatomic, copy) NSArray *serial;
@property (nonatomic, copy) NSArray *question;

@end
