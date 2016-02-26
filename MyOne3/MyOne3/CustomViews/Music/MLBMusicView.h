//
//  MLBMusicView.h
//  MyOne3
//
//  Created by meilbn on 2/22/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseView.h"

FOUNDATION_EXPORT NSString *const kMLBMusicViewID;

@interface MLBMusicView : MLBBaseView

- (void)prepareForReuse;

- (void)configureViewWithMusicId:(NSString *)musicId atIndex:(NSInteger)index;

- (void)configureViewWithMusicId:(NSString *)musicId atIndex:(NSInteger)index inViewController:(MLBBaseViewController *)parentViewController;

@end
