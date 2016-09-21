//
//  MLBRelatedMusicCollectionCell.m
//  MyOne3
//
//  Created by meilbn on 9/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBRelatedMusicCollectionCell.h"
#import "MLBRelatedMusicCCell.h"
#import "MLBRelatedMusic.h"

NSString *const kMLBRelatedMusicCollectionCellID = @"MLBRelatedMusicCollectionCellID";

@interface MLBRelatedMusicCollectionCell () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation MLBRelatedMusicCollectionCell {
	NSArray<MLBRelatedMusic *> *relatedMusics;
}

+ (CGFloat)cellHeight {
	return [MLBRelatedMusicCCell cellSize].height;
}

- (void)prepareForReuse {
	[super prepareForReuse];
	
	relatedMusics = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
	if (self) {
		[self setupViews];
	}
	
	return self;
}

- (void)setupViews {
	if (_collectionView) {
		return;
	}
	
	self.contentView.backgroundColor = [UIColor whiteColor];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	self.collectionView = ({
		UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
		layout.itemSize = [MLBRelatedMusicCCell cellSize];
		layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		layout.minimumLineSpacing = 0;
		layout.minimumInteritemSpacing = 0;
		
		UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:layout];
		collectionView.backgroundColor = [UIColor whiteColor];
		collectionView.dataSource = self;
		collectionView.delegate = self;
		collectionView.showsHorizontalScrollIndicator = NO;
		collectionView.showsVerticalScrollIndicator = NO;
		collectionView.alwaysBounceHorizontal = YES;
		collectionView.alwaysBounceVertical = NO;
		[collectionView registerClass:[MLBRelatedMusicCCell class] forCellWithReuseIdentifier:kMLBRelatedMusicCCellID];
		[self.contentView addSubview:collectionView];
		[collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self.contentView);
		}];
		
		collectionView;
	});
}

#pragma mark - Action



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return relatedMusics.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	MLBRelatedMusicCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMLBRelatedMusicCCellID forIndexPath:indexPath];
	[cell configureCellWithRelatedMusic:relatedMusics[indexPath.row]];
	
	return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - Public Methods

- (void)configureCellWithRelatedMusics:(NSArray<MLBRelatedMusic *> *)musics {
	relatedMusics = musics;
	_collectionView.contentOffset = CGPointZero;
	[_collectionView reloadData];
}

@end
