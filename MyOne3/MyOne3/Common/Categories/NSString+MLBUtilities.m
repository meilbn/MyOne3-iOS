//
//  NSString+MLBUtilities.m
//  meilbn
//
//  Created by meilbn on 12/1/15.
//  Copyright © 2015 meilbn. All rights reserved.
//

#import "NSString+MLBUtilities.h"

@implementation NSString (MLBUtilities)

- (NSURL *)mlb_encodedURL {
    return [NSURL URLWithString:[self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (NSString *)trimWhitespace {
    NSMutableString *str = [self mutableCopy];
    CFStringTrimWhitespace((__bridge CFMutableStringRef)str);
    
    return str;
}

- (BOOL)isEmpty {
    return [[self trimWhitespace] isEqualToString:@""];
}

// 转换拼音
- (NSString *)transformToPinyin {
    if (self.length <= 0) {
        return self;
    }
    
    NSString *tempString = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)tempString, NULL, kCFStringTransformToLatin, false);
    tempString = (NSMutableString *)[tempString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    tempString = [tempString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return [tempString uppercaseString];
}

// 是否包含语音解析的图标
- (BOOL)hasListenChar {
    BOOL hasListenChar = NO;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    
    for (length = [self length]; length > 0; length--) {
        if (charBuffer[length -1] == 65532) {//'\U0000fffc'
            hasListenChar = YES;
            break;
        }
    }
    
    return hasListenChar;
}

- (NSURL *)ma_iTunesURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/apple-store/id%@?mt=8", self]];
}

- (NSString *)mlb_base64String {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return base64String;
}

- (NSString *)mlb_base64DecodeString {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *base64DecodeString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];;
    
    return base64DecodeString;
}

// 文字高度
- (CGFloat)mlb_heightWithFont:(UIFont *)font width:(CGFloat)width {
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName : font}
                                     context:nil];
    return ceil(rect.size.height);
}

- (NSAttributedString *)htmlAttributedStringForMusicDetails {
    NSDictionary *attributes = @{NSFontAttributeName : FontWithSize(15),
                                 NSForegroundColorAttributeName : MLBDarkBlackTextColor};
    
    return [[NSAttributedString alloc] initWithData:[self dataUsingEncoding:NSUnicodeStringEncoding]
                                            options:@{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType }
                                 documentAttributes:&attributes
                                              error:nil];
}

@end
