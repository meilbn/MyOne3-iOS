//
//  MLBReadingBaseView.h
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const kMLBReadingBaseViewID;

@class MLBReadingEssay;
@class MLBReadingSerial;
@class MLBReadingQuestion;

@interface MLBReadingBaseView : UIView

- (void)configureViewWithReadingEssay:(MLBReadingEssay *)readingEssay readingSerial:(MLBReadingSerial *)readingSerial readingQuestion:(MLBReadingQuestion *)readingQuestion atIndex:(NSInteger)index;

@end
