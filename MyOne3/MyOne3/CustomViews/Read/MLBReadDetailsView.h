//
//  MLBReadDetailsView.h
//  MyOne3
//
//  Created by meilbn on 2/26/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseView.h"

FOUNDATION_EXPORT NSString *const kMLBReadDetailsViewID;

@class MLBBaseModel;

@interface MLBReadDetailsView : MLBBaseView

- (void)prepareForReuseWithViewType:(MLBReadType)type;

- (void)configureViewWithReadModel:(MLBBaseModel *)model type:(MLBReadType)type atIndex:(NSInteger)index inViewController:(MLBBaseViewController *)parentViewController;

@end
