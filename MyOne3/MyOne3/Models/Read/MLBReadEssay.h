//
//  MLBReadEssay.h
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseModel.h"
#import "MLBAuthor.h"

@interface MLBReadEssay : MLBBaseModel

@property (nonatomic, copy) NSString *contentId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *makeTime;
@property (nonatomic, copy) NSString *guideWord;
@property (nonatomic, copy) NSArray *authors;
@property (nonatomic, assign) BOOL hasAudio;

@end
