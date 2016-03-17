//
//  MLBTapImageView.h
//  MyOne3
//
//  Created by meilbn on 3/16/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapAction)(id obj);

@interface MLBTapImageView : UIImageView

- (void)addTapBlock:(TapAction)tapAction;

- (void)setImageWithURL:(NSString *)imgURL placeholderImageName:(NSString *)placeholderImageName tapBlock:(TapAction)tapAction;

@end
