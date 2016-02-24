//
//  NSString+MLBUtilities.h
//  meilbn
//
//  Created by meilbn on 12/1/15.
//  Copyright © 2015 meilbn. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface NSString (MLBUtilities)

- (NSURL *)mlb_encodedURL;

- (NSString *)trimWhitespace;

- (BOOL)isEmpty;

- (NSString *)transformToPinyin;

- (BOOL)hasListenChar;

- (NSURL *)ma_iTunesURL;

- (NSString *)mlb_base64String;

- (NSString *)mlb_base64DecodeString;

// 文字高度
- (CGFloat)mlb_heightWithFont:(UIFont *)font width:(CGFloat)width;

- (NSAttributedString *)htmlAttributedStringForMusicDetails;

@end
