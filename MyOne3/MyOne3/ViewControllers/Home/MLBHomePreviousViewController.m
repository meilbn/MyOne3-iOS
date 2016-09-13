//
//  MLBHomePreviousViewController.m
//  MyOne3
//
//  Created by meilbn on 4/18/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBHomePreviousViewController.h"
#import "MLBHomeItem.h"
#import "MLBHomeCCell.h"
#import "DDCollectionViewFlowLayout.h"
#import "MLBSingleHomeViewController.h"

@interface MLBHomePreviousViewController () <UICollectionViewDataSource, DDCollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation MLBHomePreviousViewController

#pragma mark - Lifecycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _period;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = MLBSeparatorColor;
    
    [self initDatas];
    [self setupViews];
    [self requestPeriodList];
}

#pragma mark - Private Method

- (void)initDatas {
    
}

- (void)setupViews {
    _collectionView = ({
        DDCollectionViewFlowLayout *layout = [[DDCollectionViewFlowLayout alloc] init];
        layout.delegate = self;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        collectionView.backgroundColor = MLBSeparatorColor;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[MLBHomeCCell class] forCellWithReuseIdentifier:kMLBHomeCCellID];
        [self.view addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        collectionView;
    });
}

#pragma mark - Public Method



#pragma mark - Action



#pragma mark - Network Request

- (void)requestPeriodList {
    __weak typeof(self) weakSelf = self;
    [MLBHTTPRequester requestHomeByMonthWithPeriod:_period success:^(id responseObject) {
		__strong typeof(weakSelf) strongSelf = weakSelf;
		if (!strongSelf) {
			return;
		}
		
        if ([responseObject[@"res"] integerValue] == 0) {
            NSError *error;
            NSArray *items = [MTLJSONAdapter modelsOfClass:[MLBHomeItem class] fromJSONArray:responseObject[@"data"] error:&error];
            if (!error) {
                strongSelf.dataSource = items;
                [strongSelf.collectionView reloadData];
            } else {
                [strongSelf.view showHUDModelTransformFailedWithError:error];
            }
        }
    } fail:^(NSError *error) {
		__strong typeof(weakSelf) strongSelf = weakSelf;
		if (!strongSelf) {
			return;
		}
		
        [strongSelf.view showHUDServerError];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:kMLBHomeCCellID forIndexPath:indexPath];
}

#pragma mark - DDCollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(DDCollectionViewFlowLayout *)layout numberOfColumnsInSection:(NSInteger)section {
    return 2;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(6, 6, 6, 6);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [MLBHomeCCell cellSizeWithHomeItem:_dataSource[indexPath.row]];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    MLBHomeCCell *cCell = (MLBHomeCCell *)cell;
    [cCell configureCellWithHomeItem:_dataSource[indexPath.row] atIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    MLBSingleHomeViewController *singleHomeViewController = [[MLBSingleHomeViewController alloc] init];
    singleHomeViewController.homeItem = _dataSource[indexPath.row];
    [self.navigationController pushViewController:singleHomeViewController animated:YES];
}

@end
