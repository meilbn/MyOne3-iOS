//
//  MLBReadingBaseCell.m
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadingBaseCell.h"
#import "MLBReadingEssay.h"
#import "MLBReadingSerial.h"
#import "MLBReadingQuestion.h"

NSString *const kMLBReadingBaseCellID = @"MLBReadingBaseCellID";

@interface MLBReadingBaseCell ()

@property (strong, nonatomic) UIImageView *readingTypeView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *authorLabel;
@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation MLBReadingBaseCell

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
    if (!_readingTypeView) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _readingTypeView = ({
            UIImageView *imageView = [UIImageView new];
            imageView.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@44);
                make.left.top.equalTo(self.contentView).offset(10);
            }];
            
            imageView;
        });
        
        _titleLabel = ({
            UILabel *label = [UILabel new];
            label.textColor = MLBLightBlackTextColor;
            label.font = FontWithSize(18);
            label.numberOfLines = 0;
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_readingTypeView.mas_right).offset(6);
                make.top.equalTo(self.contentView).offset(19);
                make.right.equalTo(self.contentView).offset(-12);
            }];
            
            label;
        });
        
        _authorLabel = ({
            UILabel *label = [UILabel new];
            label.textColor = MLBAppThemeColor;
            label.font = FontWithSize(12);
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_titleLabel.mas_bottom).offset(5);
                make.left.right.equalTo(_titleLabel);
            }];
            
            label;
        });
        
        _contentLabel = ({
            UILabel *label = [UILabel new];
            label.textColor = MLBGrayTextColor;
            label.font = FontWithSize(13);
            label.numberOfLines = 0;
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_authorLabel.mas_bottom).offset(5);
                make.left.right.equalTo(_authorLabel);
                make.bottom.equalTo(self.contentView).offset(-12);
            }];
            
            label;
        });
    }
}

#pragma mark - Public Method

- (void)configureCellWithReadingEssay:(MLBReadingEssay *)readingEssay {
    _readingTypeView.image = [UIImage imageNamed:@"reading_essay"];
    _titleLabel.text = readingEssay.title;
    if (readingEssay.authors.count > 0) {
        MLBAuthor *author = readingEssay.authors[0];
        _authorLabel.text = author.username;
    } else {
        _authorLabel.text = @"";
    }
    _contentLabel.text = readingEssay.guideWord;
}

- (void)configureCellWithReadingSerial:(MLBReadingSerial *)readingSerial {
    _readingTypeView.image = [UIImage imageNamed:@"reading_serial"];
    _titleLabel.text = [NSString stringWithFormat:@"%@( %@ )", readingSerial.title, readingSerial.number];
    _authorLabel.text = readingSerial.author.username;
    _contentLabel.text = readingSerial.excerpt;
}

- (void)configureCellWithReadingQuestion:(MLBReadingQuestion *)readingQuestion {
    _readingTypeView.image = [UIImage imageNamed:@"reading_question"];
    _titleLabel.text = readingQuestion.questionTitle;
    _authorLabel.text = @"";
    _contentLabel.text = readingQuestion.answerTitle;
}

@end
