//
//  MLBTopTenArticalCell.m
//  MyOne3
//
//  Created by meilbn on 2/27/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBTopTenArticalCell.h"
#import "MLBTopTenArtical.h"

NSString *const kMLBTopTenArticalCellID = @"MLBTopTenArticalCellID";

@interface MLBTopTenArticalCell ()

@property (strong, nonatomic) UILabel *numberLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *authorNameLabel;
@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation MLBTopTenArticalCell

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
    if (_titleLabel) {
        return;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _numberLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont italicSystemFontOfSize:14];
        [label setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(8);
            make.left.equalTo(self.contentView).offset(36);
        }];
        
        label;
    });
    
    _titleLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.font = BoldFontWithSize(18);
        label.numberOfLines = 2;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_numberLabel);
            make.left.equalTo(_numberLabel.mas_right).offset(8);
            make.right.equalTo(self.contentView).offset(-36);
        }];
        
        label;
    });
    
    _authorNameLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.font = FontWithSize(12);
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(8);
            make.left.right.equalTo(_titleLabel);
        }];
        
        label;
    });
    
    _contentLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 2;
        label.font = FontWithSize(13);
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_authorNameLabel.mas_bottom).offset(8);
            make.left.right.equalTo(_titleLabel);
            make.bottom.equalTo(self.contentView).offset(-30);
        }];
        
        label;
    });
}

#pragma mark - Public Method

- (void)configureCellWithTopTenArtical:(MLBTopTenArtical *)artical atIndexPath:(NSIndexPath *)indexPath {
    _numberLabel.text = [@(indexPath.row + 1) stringValue];
    _titleLabel.text = artical.title;
    _authorNameLabel.text = artical.authorName;
    _contentLabel.text = artical.introduction;
}

@end
