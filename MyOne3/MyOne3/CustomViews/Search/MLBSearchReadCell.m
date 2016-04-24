//
//  MLBSearchReadCell.m
//  MyOne3
//
//  Created by meilbn on 4/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBSearchReadCell.h"
#import "MLBSearchRead.h"

NSString *const kMLBSearchReadCellID = @"MLBSearchReadCellID";

@interface MLBSearchReadCell ()

@property (strong, nonatomic) UIImageView *readTypeView;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation MLBSearchReadCell

#pragma mark - Class Method

+ (CGFloat)cellHeight {
    return 64;
}

#pragma mark - View Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _readTypeView.image = nil;
}

#pragma mark - Private Method

- (void)setupViews {
    if (_readTypeView) {
        return;
    }
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _readTypeView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@48);
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(8);
        }];
        
        imageView;
    });
    
    _titleLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor whiteColor];
        label.font = FontWithSize(17);
        label.textColor = MLBLightBlackTextColor;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(_readTypeView.mas_right).offset(8);
            make.right.equalTo(self.contentView);
        }];
        
        label;
    });
}

#pragma mark - Public Method

- (void)configureCellWithSearchRead:(MLBSearchRead *)read {
    if ([read.type isEqualToString:@"essay"]) {
        _readTypeView.image = [UIImage imageNamed:@"icon_read"];
    } else if ([read.type isEqualToString:@"serialcontent"]) {
        _readTypeView.image = [UIImage imageNamed:@"icon_serial"];
    } else if ([read.type isEqualToString:@"question"]) {
        _readTypeView.image = [UIImage imageNamed:@"icon_question"];
    } else {
        _readTypeView.image = nil;
    }
    
    _titleLabel.text = read.title;
}

@end
