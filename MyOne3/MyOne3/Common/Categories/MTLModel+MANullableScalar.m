//
//  MTLModel+MANullableScalar.m
//  meilbn
//
//  Created by meilbn on 12/23/15.
//  Copyright © 2015 meilbn. All rights reserved.
//

#import "MTLModel+MANullableScalar.h"

@implementation MTLModel (MANullableScalar)

- (void)setNilValueForKey:(NSString *)key {
    [self setValue:@0 forKey:key];  // For NSInteger/CGFloat/BOOL
}

@end
