//
//  MLBRelatedMusicCCell.m
//  MyOne3
//
//  Created by meilbn on 9/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBRelatedMusicCCell.h"
#import "MLBRelatedMusic.h"

NSString *const kMLBRelatedMusicCCellID = @"MLBRelatedMusicCCellID";

@interface MLBRelatedMusicCCell ()

@property (strong, nonatomic) UIImageView *coverBGView;
@property (strong, nonatomic) UIImageView *coverView;
@property (strong, nonatomic) UILabel *musicNameLabel;
@property (strong, nonatomic) UILabel *authorNameLabel;

@end

@implementation MLBRelatedMusicCCell

+ (CGSize)cellSize {
	return (CGSize){135, 180};
}

- (void)prepareForReuse {
	[super prepareForReuse];
	_coverView.image = nil;
	[_coverView sd_cancelCurrentImageLoad];
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setupViews];
	}
	
	return self;
}

- (void)setupViews {
	if (_coverBGView) {
		return;
	}
	
	self.contentView.backgroundColor = [UIColor whiteColor];
	
	self.coverBGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"music_cover_light"]];
	self.coverBGView.backgroundColor = [UIColor whiteColor];
	[self.contentView addSubview:self.coverBGView];
	[self.coverBGView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.sizeOffset(CGSizeMake(106, 98));
		make.centerX.equalTo(self.contentView);
		make.top.equalTo(self.contentView).offset(20);
	}];
	
	self.coverView = [UIImageView new];
	self.coverView.backgroundColor = [UIColor whiteColor];
	self.coverView.contentMode = UIViewContentModeScaleAspectFill;
	self.coverView.clipsToBounds = YES;
	[self.contentView addSubview:self.coverView];
	[self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(_coverBGView).insets(UIEdgeInsetsMake(4, 9, 11, 15));
	}];
	
	self.musicNameLabel = [MLBUIFactory labelWithTextColor:MLBColor6A6A6A font:FontWithSize(14)];
	[self.contentView addSubview:self.musicNameLabel];
	[self.musicNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_coverBGView.mas_bottom).offset(10);
		make.left.equalTo(_coverBGView);
		make.right.lessThanOrEqualTo(self.contentView);
	}];
	
	self.authorNameLabel = [MLBUIFactory labelWithTextColor:MLBColor80ACE1 font:FontWithSize(11)];
	[self.contentView addSubview:self.authorNameLabel];
	[self.authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_musicNameLabel.mas_bottom).offset(5);
		make.left.equalTo(_musicNameLabel);
		make.right.lessThanOrEqualTo(self.contentView);
	}];
}

#pragma mark - Action



#pragma mark - Public Methods

- (void)configureCellWithRelatedMusic:(MLBRelatedMusic *)music {
	[_coverView mlb_sd_setImageWithURL:music.cover placeholderImageName:@"music_cover_small" cachePlachoderImage:NO];
	_musicNameLabel.text = music.title;
	_authorNameLabel.text = music.author.username;
}

@end
