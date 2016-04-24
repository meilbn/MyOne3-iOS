//
//  MLBReadBaseCell.m
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadBaseCell.h"
#import "MLBReadEssay.h"
#import "MLBReadSerial.h"
#import "MLBReadQuestion.h"

NSString *const kMLBReadBaseCellID = @"MLBReadBaseCellID";

@interface MLBReadBaseCell ()

@property (strong, nonatomic) UIImageView *readTypeView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *authorLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIView *bottomLine;

@end

@implementation MLBReadBaseCell

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    if (_readTypeView) {
        return;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    _readTypeView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(41, 19));
            make.top.equalTo(self.contentView).offset(16);
            make.right.equalTo(self.contentView).offset(-10);
        }];
        
        imageView;
    });
    
    _titleLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = MLBDarkBlackTextColor;
        label.font = BoldFontWithSize(18);
        label.numberOfLines = 0;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.top.equalTo(_readTypeView);
            make.right.lessThanOrEqualTo(_readTypeView.mas_left).offset(-10);
        }];
        
        label;
    });
    
    _authorLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = MLBLightBlackTextColor;
        label.font = FontWithSize(13);
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(10);
            make.left.right.equalTo(_titleLabel);
        }];
        
        label;
    });
    
    _contentLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = MLBLightBlackTextColor;
        label.font = FontWithSize(13);
        label.numberOfLines = 0;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_authorLabel.mas_bottom).offset(10);
            make.left.right.equalTo(_authorLabel);
            make.bottom.equalTo(self.contentView).offset(-24);
        }];
        
        label;
    });
    
    _bottomLine = ({
        UIView *line = [UIView new];
        line.backgroundColor = MLBSeparatorColor;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
            make.left.bottom.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
        }];
        
        line;
    });
}

#pragma mark - Public Method

- (void)configureCellWithBaseModel:(MLBBaseModel *)model {
    if ([model isMemberOfClass:[MLBReadEssay class]]) {
        [self configureCellWithReadEssay:(MLBReadEssay *)model];
    } else if ([model isMemberOfClass:[MLBReadSerial class]]) {
        [self configureCellWithReadSerial:(MLBReadSerial *)model];
    } else if ([model isMemberOfClass:[MLBReadQuestion class]]) {
        [self configureCellWithReadQuestion:(MLBReadQuestion *)model];
    }
}

- (void)configureCellWithReadEssay:(MLBReadEssay *)readEssay {
    _readTypeView.image = [UIImage imageNamed:@"icon_read"];
    _titleLabel.text = readEssay.title;
    
    if (readEssay.authors.count > 0) {
        MLBAuthor *author = readEssay.authors[0];
        _authorLabel.text = author.username;
    } else {
        _authorLabel.text = @"";
    }
    
    [self commonConfigureContentLabelWithText:readEssay.guideWord];
    _bottomLine.hidden = NO;
}

- (void)configureCellWithReadSerial:(MLBReadSerial *)readSerial {
    _readTypeView.image = [UIImage imageNamed:@"icon_serial"];
    _titleLabel.text = readSerial.title;
    _authorLabel.text = readSerial.author.username;
    [self commonConfigureContentLabelWithText:readSerial.excerpt];
    _bottomLine.hidden = NO;
}

- (void)configureCellWithReadQuestion:(MLBReadQuestion *)readQuestion {
    _readTypeView.image = [UIImage imageNamed:@"icon_question"];
    _titleLabel.text = readQuestion.questionTitle;
    _authorLabel.text = readQuestion.answerTitle;
    [self commonConfigureContentLabelWithText:readQuestion.answerContent];
    _bottomLine.hidden = YES;
}

- (void)commonConfigureContentLabelWithText:(NSString *)content {
    if (IsStringEmpty(content)) {
        return;
    }

    _contentLabel.attributedText = [MLBUtilities mlb_attributedStringWithText:content lineSpacing:10 font:_contentLabel.font textColor:_contentLabel.textColor];
}

@end
