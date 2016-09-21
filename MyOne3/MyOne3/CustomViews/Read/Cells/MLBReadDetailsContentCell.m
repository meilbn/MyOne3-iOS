//
//  MLBReadDetailsContentCell.m
//  MyOne3
//
//  Created by meilbn on 9/13/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadDetailsContentCell.h"
#import "MLBReadEssayDetails.h"
#import "MLBReadSerialDetails.h"

NSString *const kMLBReadDetailsContentCellID = @"MLBReadDetailsContentCellID";

@interface MLBReadDetailsContentCell ()

@property (strong, nonatomic) UITextView *contentTextView;

@property (strong, nonatomic) MASConstraint *contentTextViewHeightConstraint;

@end

@implementation MLBReadDetailsContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
	if (self) {
		[self setupViews];
	}
	
	return self;
}

- (void)setupViews {
	if (_contentTextView) {
		return;
	}
	
	self.contentView.backgroundColor = [UIColor whiteColor];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	_contentTextView = ({
		UITextView *textView = [UITextView new];
		textView.backgroundColor = [UIColor whiteColor];
		textView.textColor = MLBLightBlackTextColor;
		textView.font = FontWithSize(16);
		textView.editable = NO;
		textView.scrollEnabled = NO;
		textView.showsVerticalScrollIndicator = NO;
		textView.showsHorizontalScrollIndicator = NO;
		textView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
		[self.contentView addSubview:textView];
		[textView mas_makeConstraints:^(MASConstraintMaker *make) {
			_contentTextViewHeightConstraint = make.height.equalTo(@0).priority(999);
			make.edges.equalTo(self.contentView);
		}];
		
		textView;
	});
}

#pragma mark - Public Methods

- (void)configureCellWithContent:(NSString *)content editor:(NSString *)editor {
	if (IsStringEmpty(content)) {
		_contentTextView.attributedText = nil;
		_contentTextViewHeightConstraint.equalTo(@0);
		return;
	}
	
	_contentTextView.width = self.width;
	
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.lineSpacing = MLBLineSpacing;
	
	NSDictionary *attributes = @{ NSFontAttributeName : FontWithSize(16),
								  NSForegroundColorAttributeName : MLBLightBlackTextColor,
								  NSParagraphStyleAttributeName : paragraphStyle };
	
	NSString *editorText = [NSString stringWithFormat:@"<br>\n<br>%@<br>\n", editor];
	NSString *string = [NSString stringWithFormat:@"%@%@", content, editorText];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding]
																						  options:@{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
																									 NSCharacterEncodingDocumentAttribute : @(NSUnicodeStringEncoding) }
																			   documentAttributes:nil
																							error:nil];
	
	NSRange editorRange = [attributedString.string rangeOfString:editor];
	
	[attributedString setAttributes:attributes range:NSMakeRange(0, attributedString.string.length - editorRange.length)];
	
	[attributedString setAttributes:@{ NSFontAttributeName : FontWithSize(12),
									   NSForegroundColorAttributeName : MLBLightBlackTextColor,
									   NSParagraphStyleAttributeName : paragraphStyle } range:editorRange];
	
	_contentTextView.attributedText = attributedString;
	
	CGSize fitSize = [_contentTextView sizeThatFits:CGSizeMake(CGRectGetWidth(_contentTextView.bounds), CGFLOAT_MAX)];
	//	NSLog(@"fitSize = %@", NSStringFromCGSize(fitSize));
	_contentTextViewHeightConstraint.equalTo(@(ceil(fitSize.height)));
}

@end
