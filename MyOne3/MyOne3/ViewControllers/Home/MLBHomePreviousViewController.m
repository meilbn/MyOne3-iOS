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

@end

@implementation MLBHomePreviousViewController {
    NSArray *dataSource;
}

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
    self.view.backgroundColor = [UIColor colorWithWhite:229 / 255.0 alpha:1];
    
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
        collectionView.backgroundColor = [UIColor colorWithWhite:229 / 255.0 alpha:1];
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
    [MLBHTTPRequester requestHomeByMonthWithPeriod:_period success:^(id responseObject) {
        if ([responseObject[@"res"] integerValue] == 0) {
            NSError *error;
            NSArray *items = [MTLJSONAdapter modelsOfClass:[MLBHomeItem class] fromJSONArray:responseObject[@"data"] error:&error];
            if (!error) {
                dataSource = items;
                [_collectionView reloadData];
            } else {
                [self modelTransformFailedWithError:error];
            }
        }
    } fail:^(NSError *error) {
        [self showHUDServerError];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataSource.count;
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
    return [MLBHomeCCell cellSizeWithHomeItem:dataSource[indexPath.row]];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    MLBHomeCCell *cCell = (MLBHomeCCell *)cell;
    [cCell configureCellWithHomeItem:dataSource[indexPath.row] atIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    MLBSingleHomeViewController *singleHomeViewController = [[MLBSingleHomeViewController alloc] init];
    singleHomeViewController.homeItem = dataSource[indexPath.row];
    [self.navigationController pushViewController:singleHomeViewController animated:YES];
}

@end
