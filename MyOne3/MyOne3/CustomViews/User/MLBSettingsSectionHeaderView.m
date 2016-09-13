//
//  MLBSettingsSectionHeaderView.m
//  MyOne3
//
//  Created by meilbn on 3/16/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBSettingsSectionHeaderView.h"

NSString *const kSettingsSectionHeaderViewID = @"MLBSettingsSectionHeaderViewID";

@implementation MLBSettingsSectionHeaderView

+ (CGFloat)viewHeight {
    return 24;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    if (_titleLabel) {
        return;
    }
    
	self.contentView.backgroundColor = MLBColorFCFDFE;
	
    _titleLabel = ({
        UILabel *label = [UILabel new];
		label.textColor = MLBColor7F7F7F;
        label.font = FontWithSize(11);
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 15, 0, 0));
        }];
        
        label;
    });
}

@end
