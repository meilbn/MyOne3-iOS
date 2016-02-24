//
//  MLBMusicView.h
//  MyOne3
//
//  Created by meilbn on 2/22/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const kMLBMusicViewID;

@interface MLBMusicView : UIView

- (void)configureViewWithMusicId:(NSString *)musicId atIndex:(NSInteger)index;

@end
