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

@property (nonatomic, strong) NSArray *essay;
@property (nonatomic, strong) NSArray *serial;
@property (nonatomic, strong) NSArray *question;

@end
