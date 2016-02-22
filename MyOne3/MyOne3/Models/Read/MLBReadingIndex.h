//
//  MLBReadingIndex.h
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"
#import "MLBReadingEssay.h"
#import "MLBReadingSerial.h"
#import "MLBReadingQuestion.h"

@interface MLBReadingIndex : MLBBaseModel

@property (nonatomic, copy) NSArray *essay;
@property (nonatomic, copy) NSArray *serial;
@property (nonatomic, copy) NSArray *question;

@end
