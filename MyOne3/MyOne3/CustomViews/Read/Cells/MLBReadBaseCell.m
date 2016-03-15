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
            make.left.equalTo(_readTypeView.mas_right).offset(6);
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
    _readTypeView.image = [UIImage imageNamed:@"read_essay"];
    _titleLabel.text = readEssay.title;
    if (readEssay.authors.count > 0) {
        MLBAuthor *author = readEssay.authors[0];
        _authorLabel.text = author.username;
    } else {
        _authorLabel.text = @"";
    }
    _contentLabel.text = readEssay.guideWord;
}

- (void)configureCellWithReadSerial:(MLBReadSerial *)readSerial {
    _readTypeView.image = [UIImage imageNamed:@"read_serial"];
    _titleLabel.text = [NSString stringWithFormat:@"%@( %@ )", readSerial.title, readSerial.number];
    _authorLabel.text = readSerial.author.username;
    _contentLabel.text = readSerial.excerpt;
}

- (void)configureCellWithReadQuestion:(MLBReadQuestion *)readQuestion {
    _readTypeView.image = [UIImage imageNamed:@"read_question"];
    _titleLabel.text = readQuestion.questionTitle;
    _authorLabel.text = @"";
    _contentLabel.text = readQuestion.answerTitle;
}

@end
