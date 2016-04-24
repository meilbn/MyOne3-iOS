//
//  ZYImageView.h
//  ZYCornerRadiusImageView
//
//  Created by lzy on 16/3/3.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYImageView : UIImageView

@property (assign ,nonatomic) CGFloat cornerRadius;
@property (assign, nonatomic) UIRectCorner rectCornerType;
@property (assign, nonatomic) BOOL isRounding;
@property (assign, nonatomic) BOOL hadAddObserver;



+ (ZYImageView *)zy_cornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;

- (instancetype)initWithCornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;

- (void)zy_cornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;

+ (ZYImageView *)zy_roundingRectImageView;

- (instancetype)initWithRoundingRectImageView;

- (void)zy_cornerRadiusRoundingRect;

- (void)zy_cornerRadiusWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;

- (void)zy_cornerRadiusWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType backgroundColor:(UIColor *)backgroundColor;

@end
