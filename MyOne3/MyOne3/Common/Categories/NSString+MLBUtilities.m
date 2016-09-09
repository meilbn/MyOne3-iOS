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

- (NSString *)mlb_trimming {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)mlb_trimWhitespace {
	NSMutableString *str = [self mutableCopy];
	CFStringTrimWhitespace((__bridge CFMutableStringRef)str);
	
	return str;
}

- (BOOL)mlb_isEmpty {
	NSString *trimWhitespace = [self mlb_trimming];
	return !trimWhitespace || [trimWhitespace isEqualToString:@""];
}

// 转换拼音
- (NSString *)mlb_transformToPinyin {
	if (self.length <= 0) {
		return self;
	}
	
	NSString *tempString = [self mutableCopy];
	CFStringTransform((CFMutableStringRef)tempString, NULL, kCFStringTransformToLatin, false);
	tempString = (NSMutableString *)[tempString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
	tempString = [tempString stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	return [tempString uppercaseString];
}

// 是否是字母
- (BOOL)matchLetter {
	NSString *ZIMU = @"^[A-Za-z]+$";
	NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
	
	if ([regextestA evaluateWithObject:self] == YES) {
		return YES;
	} else {
		return NO;
	}
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

// 文字宽度
- (CGFloat)mlb_widthWithFont:(UIFont *)font height:(CGFloat)height {
	CGRect rect = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
									 options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
								  attributes:@{NSFontAttributeName : font}
									 context:nil];
	return ceil(rect.size.width);
}

- (NSAttributedString *)htmlAttributedStringForMusicDetails {
	NSDictionary *attributes = @{NSFontAttributeName : FontWithSize(15),
								 NSForegroundColorAttributeName : [UIColor darkGrayColor]};
	
	return [[NSAttributedString alloc] initWithData:[self dataUsingEncoding:NSUnicodeStringEncoding]
											options:@{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType }
								 documentAttributes:&attributes
											  error:nil];
}

/**
 *  给文字添加行间距
 *
 *  @param text        文字
 *  @param lineSpacing 行间距
 *  @param font        字体
 *  @param textColor   颜色
 *
 *  @return 带有行间距的文字
 */
+ (NSAttributedString *)mlb_attributedStringWithText:(NSString *)text lineSpacing:(CGFloat)lineSpacing font:(UIFont *)font textColor:(UIColor *)textColor {
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.lineSpacing = lineSpacing;
	
	NSDictionary *attrsDictionary = @{NSFontAttributeName : font, NSForegroundColorAttributeName : textColor, NSParagraphStyleAttributeName : paragraphStyle};
	NSAttributedString *attributedString =  [[NSAttributedString alloc] initWithString:text attributes:attrsDictionary];
	
	return attributedString;
}

/**
 *  判断是否包含特殊字符
 *
 *  @return 是否包含特殊字符
 */
- (BOOL)mlb_containsSpecialCharacter {
	NSString *regex = @".*[`~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？].*";
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject:self];
}

@end
