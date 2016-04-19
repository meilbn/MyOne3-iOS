//
//  MLBReadPreviousCell.m
//  MyOne3
//
//  Created by meilbn on 4/19/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadPreviousCell.h"
#import "MLBReadEssay.h"
#import "MLBReadSerial.h"
#import "MLBReadQuestion.h"

NSString *const kMLBReadPreviousCellID = @"MLBReadPreviousCellID";

@interface MLBReadPreviousCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *readTypeView;
@property (strong, nonatomic) UILabel *authorLabel;
@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation MLBReadPreviousCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    if (_titleLabel) {
        return;
    }
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor whiteColor];
        label.font = BoldFontWithSize(18);
        label.textColor = MLBDarkBlackTextColor;
        label.numberOfLines = 0;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(16);
            make.left.equalTo(self.contentView).offset(10);
        }];
        
        label;
    });
    
    _readTypeView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(41, 19));
            make.top.equalTo(_titleLabel);
            make.left.greaterThanOrEqualTo(_titleLabel.mas_right).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
        }];
        
        imageView;
    });
    
    _authorLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor whiteColor];
        label.font = FontWithSize(13);
        label.textColor = MLBLightBlackTextColor;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(10);
            make.left.equalTo(_titleLabel);
            make.right.equalTo(_readTypeView);
        }];
        
        label;
    });
    
    _contentLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor whiteColor];
        label.font = FontWithSize(13);
        label.textColor = MLBLightBlackTextColor;
        label.numberOfLines = 0;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_authorLabel.mas_bottom).offset(10);
            make.left.right.equalTo(_authorLabel);
            make.bottom.equalTo(self.contentView).offset(-24);
        }];
        
        label;
    });
}

#pragma mark - Public Method

- (void)configureViewWithReadModel:(MLBBaseModel *)model type:(MLBReadType)type atIndexPath:(NSIndexPath *)indexPath {
    switch (type) {
        case MLBReadTypeEssay: {
            MLBReadEssay *essay = (MLBReadEssay *)model;
            _titleLabel.text = essay.title;
            _authorLabel.text = ((MLBAuthor *)[essay.authors firstObject]).username;
            _contentLabel.text = essay.guideWord;
            _readTypeView.image = [UIImage imageNamed:@"icon_read"];
            break;
        }
        case MLBReadTypeSerial: {
            MLBReadSerial *serial = (MLBReadSerial *)model;
            _titleLabel.text = [NSString stringWithFormat:@"%@( %@ )", serial.title, serial.number];
            _authorLabel.text = serial.author.username;
            _contentLabel.text = serial.excerpt;
            _readTypeView.image = [UIImage imageNamed:@"icon_serial"];
            break;
        }
        case MLBReadTypeQuestion: {
            MLBReadQuestion *question = (MLBReadQuestion *)model;
            _titleLabel.text = question.questionTitle;
            _authorLabel.text = @"";
            _contentLabel.text = question.answerTitle;
            _readTypeView.image = [UIImage imageNamed:@"icon_question"];
            break;
        }
    }
}

@end
