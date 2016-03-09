//
//  MLBSerialCCell.m
//  MyOne3
//
//  Created by meilbn on 3/9/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBSerialCCell.h"

NSString *const kMLBSerialCCellID = @"MLBSerialCCellID";

@implementation MLBSerialCCell

+ (CGSize)cellSize {
    return CGSizeMake(44, 44);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    if (_numberLabel) {
        return;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _numberLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor whiteColor];
        label.font = FontWithSize(15);
        label.textColor = MLBAppThemeColor;
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        label;
    });
}

@end
