//
//  MLBMovieViewController.m
//  MyOne3
//
//  Created by meilbn on 2/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBMovieViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "MLBMovieListItem.h"
#import "MLBMovieListItemCCell.h"
#import "MLBMovieDetailsViewController.h"

@interface MLBMovieViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation MLBMovieViewController

#pragma mark - Lifecycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)init {
	self = [super init];
	
	if (self) {
		self.hidesBottomBarWhenPushed = NO;
	}
	
	return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = MLBMovieTitle;
    [self addNavigationBarLeftSearchItem];
    [self addNavigationBarRightMeItem];
    
    [self initDatas];
    [self setupViews];
    [self loadCache];
    [self requestMovieListWithOffser:0];
}

#pragma mark - Private Method

- (void)initDatas {
    _dataSource = @[].mutableCopy;
}

- (void)setupViews {
    _collectionView = ({
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = [MLBMovieListItemCCell cellSize];
        layout.minimumLineSpacing = 5;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
		collectionView.backgroundColor = MLBSeparatorColor;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[MLBMovieListItemCCell class] forCellWithReuseIdentifier:kMLBMovieListItemCCellID];
        [self.view addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        collectionView;
    });
    
    [MLBUIFactory addMJRefreshTo:_collectionView target:self refreshAction:nil loadMoreAction:@selector(loadMoreMovieItem)];
}

- (void)loadCache {
    id cacheMovieList = [NSKeyedUnarchiver unarchiveObjectWithFile:MLBCacheMovieListFilePath];
    if (cacheMovieList) {
        _dataSource = cacheMovieList;
        [_collectionView reloadData];
    }
}

#pragma mark - Action

- (void)loadMoreMovieItem {
    NSInteger offset = _dataSource.count + (30 - (_dataSource.count % 30));
    [self requestMovieListWithOffser:offset];
}

#pragma mark - Network Request

- (void)requestMovieListWithOffser:(NSInteger)offset {
	__weak typeof(self) weakSelf = self;
    [MLBHTTPRequester requestMovieListWithOffer:offset success:^(id responseObject) {
		__strong typeof(weakSelf) strongSelf = weakSelf;
		if (!strongSelf) {
			return;
		}
		
        if ([responseObject[@"res"] integerValue] == 0) {
            if (offset == 0) {
                [strongSelf.dataSource removeAllObjects];
            }
            
            NSError *error;
            NSArray *movies = [MTLJSONAdapter modelsOfClass:[MLBMovieListItem class] fromJSONArray:responseObject[@"data"] error:&error];
            if (!error) {
                [strongSelf.dataSource addObjectsFromArray:movies];
                [strongSelf.collectionView reloadData];
                [strongSelf.collectionView mlb_endRefreshingHasMoreData:movies.count >= 30];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [NSKeyedArchiver archiveRootObject:strongSelf.dataSource toFile:MLBCacheMovieListFilePath];
                });
                return;
            } else {
                [strongSelf.view showHUDModelTransformFailedWithError:error];
            }
        } else {
            [strongSelf.view showHUDErrorWithText:responseObject[@"msg"]];
        }
        
        [strongSelf.collectionView mlb_endRefreshingHasMoreData:YES];
    } fail:^(NSError *error) {
		__strong typeof(weakSelf) strongSelf = weakSelf;
		if (!strongSelf) {
			return;
		}
		
        [strongSelf.view showHUDServerError];
        [strongSelf.collectionView mlb_endRefreshingHasMoreData:YES];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:kMLBMovieListItemCCellID forIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(MLBMovieListItemCCell *)cell configureCellWithMovieListItem:_dataSource[indexPath.row] atIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(MLBMovieListItemCCell *)cell stopCountDownIfNeeded];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    MLBMovieDetailsViewController *movieDetailsViewController = [[MLBMovieDetailsViewController alloc] init];
    movieDetailsViewController.movieListItem = _dataSource[indexPath.row];
    [self.navigationController pushViewController:movieDetailsViewController animated:YES];
}

@end
