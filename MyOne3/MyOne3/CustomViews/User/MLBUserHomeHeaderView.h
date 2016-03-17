//
//  MLBUserHomeHeaderView.h
//  MyOne3
//
//  Created by meilbn on 3/16/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLBUserHomeHeaderView : UIView

- (instancetype)initWithUserType:(MLBUserType)userType;

- (CGFloat)viewHeight;

- (void)configureHeaderViewForTestMe;

@end
