//
//  MLBUIFactory.m
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBUIFactory.h"

@implementation MLBUIFactory

#pragma mark - UIBUtton

+ (UIButton *)buttonWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (IsStringNotEmpty(imageName)) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (IsStringNotEmpty(highlightImageName)) {
        [button setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    }
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

@end
