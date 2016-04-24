//
//  MLBSearchMovieCell.m
//  MyOne3
//
//  Created by meilbn on 4/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBSearchMovieCell.h"

NSString *const kMLBSearchMovieCellID = @"MLBSearchMovieCellID";

@implementation MLBSearchMovieCell

+ (CGFloat)cellHeight {
    return 44;
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
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor whiteColor];
        label.font = FontWithSize(17);
        label.textColor = MLBLightBlackTextColor;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 8, 0, 0));
        }];
        
        label;
    });
}

@end
