//
//  MLBReadBaseView.h
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseView.h"

FOUNDATION_EXPORT NSString *const kMLBReadBaseViewID;

@class MLBReadEssay;
@class MLBReadSerial;
@class MLBReadQuestion;

@interface MLBReadBaseView : MLBBaseView

@property (nonatomic, copy) void (^readSelected)(MLBReadType type);

- (void)configureViewWithReadEssay:(MLBReadEssay *)readEssay readSerial:(MLBReadSerial *)readSerial readQuestion:(MLBReadQuestion *)readQuestion atIndex:(NSInteger)index;

- (void)configureViewWithReadEssay:(MLBReadEssay *)readEssay readSerial:(MLBReadSerial *)readSerial readQuestion:(MLBReadQuestion *)readQuestion atIndex:(NSInteger)index inViewController:(MLBBaseViewController *)parentViewController;

@end
