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

@property (nonatomic, strong) NSString *contentId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *makeTime;
@property (nonatomic, strong) NSString *guideWord;
@property (nonatomic, strong) NSArray *authors;
@property (nonatomic, assign) BOOL hasAudio;

@end
