//
//  MenuView.m
//  JackFastKit
//
//  Created by 曾 宪华 on 14-10-13.
//  Copyright (c) 2014年 华捷 iOS软件开发工程师 曾宪华. All rights reserved.
//

#import "PopMenu.h"
#import "MenuButton.h"
#import "XHRealTimeBlur.h"
#import <POP.h>

#define MenuButtonHeight 48
#define MenuButtonVerticalPadding 12
#define MenuButtonHorizontalMargin 24
#define MenuButtonAnimationTime 0.3
#define MenuButtonAnimationInterval (MenuButtonAnimationTime / 5)

#define kMenuButtonBaseTag 100

@interface PopMenu ()

@property (nonatomic, strong) XHRealTimeBlur *realTimeBlur;

@property (nonatomic, strong, readwrite) NSArray *items;

@property (nonatomic, strong) MenuItem *selectedItem;

@property (nonatomic, assign, readwrite) BOOL isShowed;

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *separatorView;

@end

@implementation PopMenu


#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.items = items;
        
        [self setup];
    }
    return self;
}

// 设置属性
- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.perRowItemCount = 3;
    
    typeof(self) __weak weakSelf = self;
    _realTimeBlur = [[XHRealTimeBlur alloc] initWithFrame:self.bounds];
    _realTimeBlur.showDuration = 0.3;
    _realTimeBlur.disMissDuration = 0.5;
    _realTimeBlur.willShowBlurViewcomplted = ^(void) {
        weakSelf.isShowed = YES;
        [weakSelf showButtons];
    };
    
    _realTimeBlur.willDismissBlurViewCompleted = ^(void) {
        [weakSelf hidenButtons];
    };
    _realTimeBlur.didDismissBlurViewCompleted = ^(BOOL finished) {
        weakSelf.isShowed = NO;
        if (finished && weakSelf.selectedItem) {
            if (weakSelf.didSelectedItemCompletion) {
                weakSelf.didSelectedItemCompletion(weakSelf.selectedItem);
                weakSelf.selectedItem = nil;
            }
        }
        [weakSelf removeFromSuperview];
    };
    _realTimeBlur.hasTapGestureEnable = YES;
    
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [UILabel new];
            label.textColor = [UIColor colorWithWhite:127 / 255.0 alpha:1];// #7F7F7F
            label.font = FontWithSize(16);
            label.text = @"分享 & 收藏";
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@20);
                make.left.top.right.equalTo(self).insets(UIEdgeInsetsMake(90, 24, 0, 24));
            }];
            
            label;
        });
        
        _separatorView = ({
            UIView *view = [UIView new];
            view.backgroundColor = MLBLightGrayTextColor;
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0.5);
                make.top.equalTo(_titleLabel.mas_bottom).offset(24);
                make.left.equalTo(self).offset(24);
                make.right.equalTo(self).offset(-24);
            }];
            
            view;
        });
    }
}

#pragma mark - 公开方法

- (void)showMenuAtView:(UIView *)containerView {
    CGPoint startPoint = CGPointMake(0, CGRectGetHeight(self.bounds));
    CGPoint endPoint = startPoint;
    switch (self.menuAnimationType) {
        case kPopMenuAnimationTypeNetEase:
            startPoint.x = CGRectGetMidX(self.bounds);
            endPoint.x = startPoint.x;
            break;
        default:
            break;
    }
    [self showMenuAtView:containerView startPoint:startPoint endPoint:endPoint];
}

- (void)showMenuAtView:(UIView *)containerView startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    if (self.isShowed) {
        return;
    }
    self.startPoint = startPoint;
    self.endPoint = endPoint;
    [containerView addSubview:self];
    [self.realTimeBlur showBlurViewAtView:self];
}

- (void)dismissMenu {
    if (!self.isShowed) {
        return;
    }
    [self.realTimeBlur disMiss];
}

#pragma mark - 私有方法

- (void)reset {
    _titleLabel.alpha = 0;
    _separatorView.alpha = 0;
}

- (void)willShow {
    [self reset];
    
    [UIView animateWithDuration:MenuButtonAnimationTime animations:^{
        _titleLabel.alpha = 1;
        _separatorView.alpha = 1;
    }];
}

- (void)willDismiss {
    [UIView animateWithDuration:MenuButtonAnimationTime animations:^{
        _titleLabel.alpha = 0;
        _separatorView.alpha = 0;
    }];
}

/**
 *  添加菜单按钮
 */
- (void)showButtons {
    NSArray *items = [self menuItems];
    
    NSInteger perRowItemCount = self.perRowItemCount;
    
    CGFloat menuButtonWidth = (CGRectGetWidth(self.bounds) - ((perRowItemCount + 1) * MenuButtonHorizontalMargin)) / perRowItemCount;
    
    typeof(self) __weak weakSelf = self;
    for (int index = 0; index < items.count; index ++) {
        
        MenuItem *menuItem = items[index];
        // 如果没有自定义index，就按照正常流程，从0开始
        if (menuItem.index < 0) {
            menuItem.index = index;
        }
        MenuButton *menuButton = (MenuButton *)[self viewWithTag:kMenuButtonBaseTag + index];
        
        CGRect toRect = [self getFrameWithItemCount:items.count
                                    perRowItemCount:perRowItemCount
                                  perColumItemCount:items.count/perRowItemCount+(items.count%perRowItemCount>0?1:0)
                                          itemWidth:menuButtonWidth
                                         itemHeight:MenuButtonHeight
                                           paddingX:MenuButtonHorizontalMargin
                                           paddingY:MenuButtonVerticalPadding
                                            atIndex:index
                                             onPage:0];
        
        CGRect fromRect = toRect;
        
        switch (self.menuAnimationType) {
            case kPopMenuAnimationTypeSina:
                fromRect.origin.y = self.startPoint.y;
                break;
            case kPopMenuAnimationTypeNetEase:
                fromRect.origin.x = self.startPoint.x - menuButtonWidth / 2.0;
                fromRect.origin.y = self.startPoint.y;
                break;
            default:
                break;
        }
        if (!menuButton) {
            menuButton = [[MenuButton alloc] initWithFrame:fromRect menuItem:menuItem];
            menuButton.tag = kMenuButtonBaseTag + index;
            menuButton.didSelctedItemCompleted = ^(MenuItem *menuItem) {
                weakSelf.selectedItem = menuItem;
                [weakSelf dismissMenu];
            };
            [self addSubview:menuButton];
        } else {
            menuButton.frame = fromRect;
        }
        
        double delayInSeconds = index * MenuButtonAnimationInterval;
        
        [self initailzerAnimationWithToPostion:toRect formPostion:fromRect atView:menuButton beginTime:delayInSeconds];
    }
    
    [self willShow];
}
/**
 *  隐藏按钮
 */
- (void)hidenButtons {
    NSArray *items = [self menuItems];
    
    for (int index = 0; index < items.count; index ++) {
        MenuButton *menuButton = (MenuButton *)[self viewWithTag:kMenuButtonBaseTag + index];
        
        CGRect fromRect = menuButton.frame;
        
        CGRect toRect = fromRect;
        
        switch (self.menuAnimationType) {
            case kPopMenuAnimationTypeSina:
                toRect.origin.y = self.endPoint.y;
                break;
            case kPopMenuAnimationTypeNetEase:
                toRect.origin.x = self.endPoint.x - CGRectGetMidX(menuButton.bounds);
                toRect.origin.y = self.endPoint.y;
                break;
            default:
                break;
        }
        double delayInSeconds = (items.count - index) * MenuButtonAnimationInterval;
        
        [self initailzerAnimationWithToPostion:toRect formPostion:fromRect atView:menuButton beginTime:delayInSeconds];
    }
    
    [self willDismiss];
}

- (NSArray *)menuItems {
    return self.items;
}

/**
 *  通过目标的参数，获取一个grid布局  网格布局
 *
 *  @param perRowItemCount   每行有多少列
 *  @param perColumItemCount 每列有多少行
 *  @param itemWidth         gridItem的宽度
 *  @param itemHeight        gridItem的高度
 *  @param paddingX          gridItem之间的X轴间隔
 *  @param paddingY          gridItem之间的Y轴间隔
 *  @param index             某个gridItem所在的index序号
 *  @param page              某个gridItem所在的页码
 *
 *  @return 返回一个已经处理好的gridItem frame
 */
- (CGRect)getFrameWithItemCount:(NSInteger)itemCount
                perRowItemCount:(NSInteger)perRowItemCount
              perColumItemCount:(NSInteger)perColumItemCount
                      itemWidth:(CGFloat)itemWidth
                     itemHeight:(NSInteger)itemHeight
                       paddingX:(CGFloat)paddingX
                       paddingY:(CGFloat)paddingY
                        atIndex:(NSInteger)index
                         onPage:(NSInteger)page {
    
    NSUInteger rowCount = itemCount / perRowItemCount + (itemCount % perColumItemCount > 0 ? 1 : 0);
    CGFloat insetY = (CGRectGetHeight(self.bounds) - (itemHeight + paddingY) * rowCount) / 2.0;
    
    CGFloat originX = (index % perRowItemCount) * (itemWidth + paddingX) + paddingX + (page * CGRectGetWidth(self.bounds));
    CGFloat originY = ((index / perRowItemCount) - perColumItemCount * page) * (itemHeight + paddingY) + paddingY + 44;
    
    CGRect itemFrame = CGRectMake(originX, originY + insetY, itemWidth, itemHeight);
    return itemFrame;
}

#pragma mark - Animation

- (void)initailzerAnimationWithToPostion:(CGRect)toRect formPostion:(CGRect)fromRect atView:(UIView *)view beginTime:(CFTimeInterval)beginTime {
    POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
    springAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    springAnimation.removedOnCompletion = YES;
    springAnimation.beginTime = beginTime + CACurrentMediaTime();
    CGFloat springBounciness = 10 - beginTime * 2;
    springAnimation.springBounciness = springBounciness;    // value between 0-20
    
    CGFloat springSpeed = 12 - beginTime * 2;
    springAnimation.springSpeed = springSpeed;     // value between 0-20
    springAnimation.toValue = [NSValue valueWithCGRect:toRect];
    springAnimation.fromValue = [NSValue valueWithCGRect:fromRect];
    
    [view pop_addAnimation:springAnimation forKey:@"POPSpringAnimationKey"];
}

@end
