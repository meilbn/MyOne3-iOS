/**********************************************************************************
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2014 Michał Zaborowski
 *
 * This project is an rewritten version of the KILabel
 *
 * https://github.com/Krelborn/KILabel
 ***********************************************************************************
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2013 Matthew Styles
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 ***********************************************************************************/

#import <UIKit/UIKit.h>

#ifndef IBInspectable
#define IBInspectable
#endif

typedef void(^MZSelectableLabelTapHandler)(NSRange range, NSString *string);

@interface MZSelectableLabelRange : NSObject
@property (nonatomic, assign) NSRange range;
@property (nonatomic, strong) UIColor *color;

+ (instancetype)selectableRangeWithRange:(NSRange)range color:(UIColor *)color;
@end

@interface MZSelectableLabel : UILabel
@property (nonatomic, copy) NSMutableArray *selectableRanges;

//detected ranges in the text
@property (nonatomic, copy) NSArray *detectedSelectableRanges;

@property (nonatomic, copy) MZSelectableLabelTapHandler selectionHandler;

@property (nonatomic, assign, getter = isAutomaticForegroundColorDetectionEnabled) IBInspectable BOOL automaticForegroundColorDetectionEnabled;
@property (nonatomic, strong) IBInspectable UIColor *automaticDetectionBackgroundHighlightColor;
@property (nonatomic, strong) IBInspectable UIColor *skipColorForAutomaticDetection;

- (void)setSelectableRange:(NSRange)range;
- (void)setSelectableRange:(NSRange)range hightlightedBackgroundColor:(UIColor *)color;

- (MZSelectableLabelRange *)rangeValueAtLocation:(CGPoint)location;

@end
