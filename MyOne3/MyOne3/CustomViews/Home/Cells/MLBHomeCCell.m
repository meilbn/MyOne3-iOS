//
//  MLBHomeCCell.m
//  MyOne3
//
//  Created by meilbn on 4/18/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBHomeCCell.h"
#import "MLBHomeItem.h"

NSString *const kMLBHomeCCellID = @"MLBHomeCCellID";

@interface MLBHomeCCell ()

@property (strong, nonatomic) UIImageView *coverView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation MLBHomeCCell

#pragma mark - Class Method

+ (CGSize)cellSizeWithHomeItem:(MLBHomeItem *)item {
    CGFloat cellWidth = ceilf((SCREEN_WIDTH - 6 * 2 - 12) / 2.0);
    CGFloat cellHeight = 0.0f;
    
    CGFloat coverHeight = cellWidth * 0.75;
    CGRect contentRect = [item.content boundingRectWithSize:CGSizeMake(cellWidth - 4 * 2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FontWithSize(12)} context:nil];
    CGFloat contentHeight = contentRect.size.height;
    
    cellHeight = coverHeight + 4 + contentHeight + 4;
    
    return CGSizeMake(cellWidth, ceilf(cellHeight));
}

#pragma mark - View Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _coverView.image = nil;
}

#pragma mark - Private Method

- (void)setupViews {
    if (_coverView) {
        return;
    }
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 5;
    self.contentView.clipsToBounds = YES;
    
    _coverView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView);
            make.height.equalTo(imageView.mas_width).multipliedBy(0.75);
        }];
        
        imageView;
    });
    
    _titleLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.4];
        label.font = FontWithSize(10);
        label.textColor = [UIColor colorWithWhite:229 / 255.0 alpha:229 / 255.0];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(_coverView);
        }];
        
        label;
    });
    
    _contentLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor whiteColor];
        label.font = FontWithSize(12);
        label.textColor = MLBLightBlackTextColor;
        label.numberOfLines = 0;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_coverView.mas_bottom).offset(4);
            make.left.bottom.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 4, 4, 4));
        }];
        
        label;
    });
}

#pragma mark - Public Method

- (void)configureCellWithHomeItem:(MLBHomeItem *)homeItem atIndexPath:(NSIndexPath *)indexPath {
    [_coverView mlb_sd_setImageWithURL:homeItem.imageURL placeholderImageName:nil];
    _titleLabel.text = homeItem.title;
    _contentLabel.text = homeItem.content;
}

@end
