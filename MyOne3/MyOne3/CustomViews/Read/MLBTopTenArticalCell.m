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

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *authorNameLabel;

@end

@implementation MLBTopTenArticalCell

+ (CGFloat)cellHeight {
    return 90;
}

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
    
    _titleLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.font = BoldFontWithSize(18);
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(16, 8, 0, 8));
        }];
        
        label;
    });
    
    _authorNameLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.font = FontWithSize(15);
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(5);
            make.left.right.equalTo(_titleLabel);
        }];
        
        label;
    });
}

#pragma mark - Public Method

- (void)configureCellWithTopTenArtical:(MLBTopTenArtical *)artical {
    _titleLabel.text = artical.title;
    _authorNameLabel.text = artical.authorName;
}

@end
