//
//  ZYImageView.m
//  ZYCornerRadiusImageView
//
//  Created by lzy on 16/3/3.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "ZYImageView.h"
#import <objc/runtime.h>

const char kZYProcessedImage;

@implementation ZYImageView



/**
 * @brief create Rounding ZYImageView, no off-screen-rendered
 */
+ (ZYImageView *)zy_roundingRectImageView {
    ZYImageView *imageView = [[ZYImageView alloc] init];
    [imageView zy_cornerRadiusRoundingRect];
    return imageView;
}

/**
 * @brief init the Rounding ZYImageView, no off-screen-rendered
 */
- (instancetype)initWithRoundingRectImageView {
    self = [super init];
    if (self) {
        [self zy_cornerRadiusRoundingRect];
    }
    return self;
}

/**
 * @brief create ZYImageView with cornerRadius, no off-screen-rendered
 */
+ (ZYImageView *)zy_cornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    ZYImageView *imageView = [[ZYImageView alloc] init];
    [imageView zy_cornerRadiusAdvance:cornerRadius rectCornerType:rectCornerType];
    return imageView;
}

/**
 * @brief init the ZYImageView with cornerRadius, no off-screen-rendered
 */
- (instancetype)initWithCornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    self = [super init];
    if (self) {
        [self zy_cornerRadiusAdvance:cornerRadius rectCornerType:rectCornerType];
    }
    return self;
}

#pragma mark - Kernel
/**
 * @brief clip the cornerRadius with image, ZYImageView must be setFrame before, no off-screen-rendered
 */
- (void)zy_cornerRadiusWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    if (nil == UIGraphicsGetCurrentContext()) {
        return;
    }
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCornerType cornerRadii:cornerRadii];
    [cornerPath addClip];
    [image drawInRect:self.bounds];
    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    objc_setAssociatedObject(processedImage, &kZYProcessedImage, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.image = processedImage;
}

/**
 * @brief clip the cornerRadius with image, draw the backgroundColor you want, ZYImageView must be setFrame before, no off-screen-rendered, no Color Blended layers
 */
- (void)zy_cornerRadiusWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType backgroundColor:(UIColor *)backgroundColor {
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    if (nil == UIGraphicsGetCurrentContext()) {
        return;
    }
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCornerType cornerRadii:cornerRadii];
    UIBezierPath *backgroundRect = [UIBezierPath bezierPathWithRect:self.bounds];
    [backgroundColor setFill];
    [backgroundRect fill];
    [cornerPath addClip];
    [image drawInRect:self.bounds];
    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    objc_setAssociatedObject(processedImage, &kZYProcessedImage, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.image = processedImage;
}

/**
 * @brief set cornerRadius for ZYImageView, no off-screen-rendered
 */
- (void)zy_cornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    self.cornerRadius = cornerRadius;
    self.rectCornerType = rectCornerType;
    self.isRounding = NO;
    if (!_hadAddObserver) {
        [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        self.hadAddObserver = YES;
    }
}

/**
 * @brief become Rounding ZYImageView, no off-screen-rendered
 */
- (void)zy_cornerRadiusRoundingRect {
    self.isRounding = YES;
    if (!_hadAddObserver) {
        [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        self.hadAddObserver = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_isRounding) {
        [self zy_cornerRadiusWithImage:self.image cornerRadius:self.frame.size.width/2 rectCornerType:UIRectCornerAllCorners];
    } else if (0 != _cornerRadius && _rectCornerType && nil != self.image) {
        [self zy_cornerRadiusWithImage:self.image cornerRadius:_cornerRadius rectCornerType:_rectCornerType];
    }
}

- (void)dealloc {
    if (_hadAddObserver) {
        [self removeObserver:self forKeyPath:@"image"];
    }
}


#pragma mark - KVO for .image
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"image"]) {
        UIImage *newImage = change[NSKeyValueChangeNewKey];
        if ([newImage isMemberOfClass:[NSNull class]]) {
            return;
        } else if ([objc_getAssociatedObject(newImage, &kZYProcessedImage) intValue] == 1) {
            return;
        }
        if (_isRounding) {
            [self zy_cornerRadiusWithImage:newImage cornerRadius:self.frame.size.width/2 rectCornerType:UIRectCornerAllCorners];
        } else if (0 != _cornerRadius && _rectCornerType && nil != self.image) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self zy_cornerRadiusWithImage:newImage cornerRadius:_cornerRadius rectCornerType:_rectCornerType];
            });
        }
    }
}

@end
