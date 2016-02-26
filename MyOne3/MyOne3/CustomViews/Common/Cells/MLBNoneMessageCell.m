//
//  MLBNoneMessageCell.m
//  MyOne3
//
//  Created by meilbn on 2/24/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBNoneMessageCell.h"

NSString *const kMLBNoneMessageCellID = @"MLBNoneMessageCellID";

@interface MLBNoneMessageCell ()



@end

@implementation MLBNoneMessageCell

+ (CGFloat)cellHeight {
    return 100.0;
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
    if (_hintView) {
        return;
    }
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _hintView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"sofa_image"];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        imageView;
    });
}

@end
