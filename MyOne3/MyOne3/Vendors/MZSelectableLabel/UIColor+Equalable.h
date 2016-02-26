//
//  UIColor+Equalable.h
//  MZSelectableLabelDemo
//
//  Created by Michał Zaborowski on 05.08.2014.
//  Copyright (c) 2014 Michal Zaborowski. All rights reserved.
//
// http://stackoverflow.com/questions/970475/how-to-compare-uicolors

#import <UIKit/UIKit.h>

@interface UIColor (Equalable)
- (BOOL)isEqualToColor:(UIColor *)otherColor;
@end
