//
//  MenuButton.m
//  JackFastKit
//
//  Created by 曾 宪华 on 14-10-13.
//  Copyright (c) 2014年 华捷 iOS软件开发工程师 曾宪华. All rights reserved.
//

#import "MenuButton.h"
#import <POP.h>

// Model
#import "MenuItem.h"

// View
#import "GlowImageView.h"

@interface MenuButton ()

@property (nonatomic, strong) GlowImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (strong, nonatomic) UIView *separatorLine;

@property (nonatomic, strong) MenuItem *menuItem;

@end

@implementation MenuButton

- (instancetype)initWithFrame:(CGRect)frame menuItem:(MenuItem *)menuItem {
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        self.menuItem = menuItem;
        
        self.backgroundColor = menuItem.glowColor;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = menuItem.title;
        [self addSubview:self.titleLabel];
        
        self.iconImageView = [[GlowImageView alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
        self.iconImageView.userInteractionEnabled = NO;
        [self.iconImageView setImage:menuItem.iconImage forState:UIControlStateNormal];
        self.iconImageView.glowColor = menuItem.glowColor;
        [self addSubview:self.iconImageView];
        
        _separatorLine = [[UIView alloc] initWithFrame:CGRectMake(48, 0, 1, 48)];
        _separatorLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
        [self addSubview:_separatorLine];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // 播放缩放动画
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animation];
    scaleAnimation.springBounciness = 20;    // value between 0-20
    scaleAnimation.springSpeed = 20;     // value between 0-20
    scaleAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.1, 1.1)];
    [self pop_addAnimation:scaleAnimation forKey:@"scaleAnimationKey"];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self disMissCompleted:NULL];
}

- (void)disMissCompleted:(void(^)(BOOL finished))completed {
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animation];
    scaleAnimation.springBounciness = 16;    // value between 0-20
    scaleAnimation.springSpeed = 14;     // value between 0-20
    scaleAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (completed) {
            completed(finished);
        }
    };
    [self pop_addAnimation:scaleAnimation forKey:@"scaleAnimationKey"];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // 回调
    [self disMissCompleted:^(BOOL finished) {
        if (self.didSelctedItemCompleted) {
            self.didSelctedItemCompleted(self.menuItem);
        }
    }];
}

@end
