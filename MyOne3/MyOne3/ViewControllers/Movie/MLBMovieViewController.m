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
#import "MLBMovieListItemCell.h"
#import "MLBMovieDetailsViewController.h"

@interface MLBMovieViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MLBMovieViewController {
    NSMutableArray *dataSource;
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
    self.title = MLBMovieTitle;
    
    [self initDatas];
    [self setupViews];
    [self loadCache];
    [self requestMovieListWithOffser:0];
}

#pragma mark - Private Method

- (void)initDatas {
    dataSource = @[].mutableCopy;
}

- (void)setupViews {
    [self addNavigationBarRightItems];
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.backgroundColor = [UIColor colorWithWhite:229 / 255.0 alpha:1];// #E5E5E5
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[MLBMovieListItemCell class] forCellReuseIdentifier:kMLBMovieListItemCellID];
        [MLBUIFactory addMJRefreshTo:tableView target:self refreshAction:nil loadMoreAction:@selector(loadMoreMovieItem)];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        tableView;
    });
}

- (void)loadCache {
    id cacheMovieList = [NSKeyedUnarchiver unarchiveObjectWithFile:MLBCacheMovieListFilePath];
    if (cacheMovieList) {
        dataSource = cacheMovieList;
        [_tableView reloadData];
    }
}

#pragma mark - Action

- (void)loadMoreMovieItem {
    NSInteger offset = dataSource.count + (30 - (dataSource.count % 30));
    [self requestMovieListWithOffser:offset];
}

#pragma mark - Network Request

- (void)requestMovieListWithOffser:(NSInteger)offset {
    [MLBHTTPRequester requestMovieListWithOffer:offset success:^(id responseObject) {
        if ([responseObject[@"res"] integerValue] == 0) {
            if (offset == 0) {
                [dataSource removeAllObjects];
            }
            
            NSError *error;
            NSArray *movies = [MTLJSONAdapter modelsOfClass:[MLBMovieListItem class] fromJSONArray:responseObject[@"data"] error:&error];
            if (!error) {
                [dataSource addObjectsFromArray:movies];
                [_tableView reloadData];
                [self endRefreshingScrollView:_tableView hasMoreData:movies.count >= 30];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [NSKeyedArchiver archiveRootObject:dataSource toFile:MLBCacheMovieListFilePath];
                });
                return;
            } else {
                [self modelTransformFailedWithError:error];
            }
        } else {
            [self showHUDErrorWithText:responseObject[@"msg"]];
        }
        
        [self endRefreshingScrollView:_tableView hasMoreData:YES];
    } fail:^(NSError *error) {
        [self showHUDServerError];
        [self endRefreshingScrollView:_tableView hasMoreData:YES];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:kMLBMovieListItemCellID forIndexPath:indexPath];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MLBMovieListItemCell cellHight];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(MLBMovieListItemCell *)cell configureCellWithMovieListItem:dataSource[indexPath.section] atIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MLBMovieDetailsViewController *movieDetailsViewController = [[MLBMovieDetailsViewController alloc] init];
    movieDetailsViewController.movieListItem = dataSource[indexPath.section];
    [self.navigationController pushViewController:movieDetailsViewController animated:YES];
}

@end
