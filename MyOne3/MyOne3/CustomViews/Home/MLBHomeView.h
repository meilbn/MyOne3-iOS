//
//  MLBHomeView.h
//  MyOne3
//
//  Created by meilbn on 2/22/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseView.h"

FOUNDATION_EXPORT NSString *const kMLBHomeViewID;

@class MLBHomeItem;

@interface MLBHomeView : MLBBaseView

@property (nonatomic, copy) void (^clickedButton)(MLBActionType type);

- (void)configureViewWithHomeItem:(MLBHomeItem *)homeItem atIndex:(NSInteger)index;

- (void)configureViewWithHomeItem:(MLBHomeItem *)homeItem atIndex:(NSInteger)index inViewController:(MLBBaseViewController *)parentViewController;

@end
