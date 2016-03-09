//
//  MLBSerialCollectionView.h
//  MyOne3
//
//  Created by meilbn on 3/9/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLBReadSerial;

@interface MLBSerialCollectionView : UIView

@property (nonatomic, copy) MLBReadSerial *serial;

- (void)show;

- (void)dismiss;

@end
