//
//  UIImageView+MLBSDImageLoader.m
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "UIImageView+MLBSDImageLoader.h"

@implementation UIImageView (MLBSDImageLoader)

- (void)mlb_sd_setImageWithURL:(NSString *)url placeholderImageName:(NSString *)placeholderImageName {
    [self mlb_sd_setImageWithURL:url placeholderImageName:placeholderImageName cachePlachoderImage:YES];
}

- (void)mlb_sd_setImageWithURL:(NSString *)url placeholderImageName:(NSString *)placeholderImageName cachePlachoderImage:(BOOL)cachePlachoderImage {
    if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:url]) {
        self.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url];
    } else {
        UIImage *placeholderImage;
        if (IsStringNotEmpty(placeholderImageName)) {
            if (cachePlachoderImage) {
                placeholderImage = [UIImage imageNamed:placeholderImageName];
            } else {
                NSString *pathOfImage = [[NSBundle mainBundle] pathForResource:placeholderImageName ofType:@"png"];
                placeholderImage = [UIImage imageWithContentsOfFile:pathOfImage];
            }
        }
        [self sd_setImageWithURL:[url mlb_encodedURL] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[SDImageCache sharedImageCache] storeImage:image forKey:url toDisk:YES];
            });
        }];
    }
}

@end
