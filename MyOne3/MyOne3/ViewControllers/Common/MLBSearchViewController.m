//
//  MLBSearchViewController.m
//  MyOne3
//
//  Created by meilbn on 4/19/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBSearchViewController.h"
#import "DZNSegmentedControl.h"
#import "MLBHomeItem.h"
#import "MLBSearchRead.h"
#import "MLBRelatedMusic.h"
#import "MLBUser.h"
#import "MLBMovieListItem.h"
#import "MLBSearchPictureCell.h"
#import "MLBSearchReadCell.h"
#import "MLBSearchMusicCell.h"
#import "MLBSearchAuthorCell.h"
#import "MLBSearchMovieCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "MLBSingleHomeViewController.h"
#import "MLBMovieDetailsViewController.h"
#import "MLBMusicRelatedViewController.h"

@interface MLBSearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource>

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIImageView *hintView;
@property (strong, nonatomic) DZNSegmentedControl *segmentedControl;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation MLBSearchViewController {
    MLBSearchType searchType;
    NSMutableDictionary *dataSource;
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
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initDatas];
    [self setupViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_searchBar becomeFirstResponder];
}

#pragma mark - Private Method

- (void)initDatas {
    dataSource = [NSMutableDictionary dictionaryWithCapacity:5];
    searchType = MLBSearchTypeHome;
}

- (void)setupViews {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.placeholder = @"输入搜索内容";
    _searchBar.tintColor = MLBLightGrayTextColor;
    _searchBar.returnKeyType = UIReturnKeySearch;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
    
    _segmentedControl = ({
        DZNSegmentedControl *segmentedControl = [[DZNSegmentedControl alloc] initWithItems:@[@"插图", @"阅读", @"音乐", @"影视", @"作者/音乐人"]];
        segmentedControl.backgroundColor = [UIColor whiteColor];
        segmentedControl.frame = CGRectMake(0, 0, SCREEN_WIDTH, 35);
        segmentedControl.showsCount = NO;
        segmentedControl.font = FontWithSize(12);
        [segmentedControl setTitleColor:[UIColor colorWithWhite:127 / 255.0 alpha:1] forState:UIControlStateNormal];
        segmentedControl.tintColor = MLBAppThemeColor;
        segmentedControl.hairlineColor = nil;
        [segmentedControl addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:segmentedControl];
        [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@35);
            make.left.top.right.equalTo(self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
        }];
        
        segmentedControl;
    });
    _segmentedControl.hidden = YES;
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[MLBSearchPictureCell class] forCellReuseIdentifier:kMLBSearchPictureCellID];
        [tableView registerClass:[MLBSearchReadCell class] forCellReuseIdentifier:kMLBSearchReadCellID];
        [tableView registerClass:[MLBSearchMusicCell class] forCellReuseIdentifier:kMLBSearchMusicCellID];
        [tableView registerClass:[MLBSearchMovieCell class] forCellReuseIdentifier:kMLBSearchMovieCellID];
        [tableView registerClass:[MLBSearchAuthorCell class] forCellReuseIdentifier:kMLBSearchAuthorCellID];
        tableView.tableFooterView = [UIView new];
        tableView.emptyDataSetSource = self;
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_segmentedControl.mas_bottom);
            make.left.bottom.right.equalTo(self.view);
        }];
        
        tableView;
    });
    _tableView.hidden = YES;
    
    _hintView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_all"]];
        imageView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(165, 110));
            make.top.equalTo(self.view).offset(114);
            make.centerX.equalTo(self.view);
        }];
        
        imageView;
    });
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:_activityIndicatorView];
    [_activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

- (NSArray *)dataByCurrentSearchType {
    NSArray *datas = dataSource[[@(searchType) stringValue]];
    return datas;
}

#pragma mark - Public Method



#pragma mark - Action

- (void)cancel {
    [_searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)selectedSegment:(DZNSegmentedControl *)control {
    if (control.selectedSegmentIndex == 0) {
        searchType = MLBSearchTypeHome;
    } else if (control.selectedSegmentIndex == 1) {
        searchType = MLBSearchTypeRead;
    } else if (control.selectedSegmentIndex == 2) {
        searchType = MLBSearchTypeMusic;
    } else if (control.selectedSegmentIndex == 3) {
        searchType = MLBSearchTypeMovie;
    } else if (control.selectedSegmentIndex == 4) {
        searchType = MLBSearchTypeAuthor;
    }
    
    [self searching];
}

#pragma mark - Network Request

- (void)searching {
    [_activityIndicatorView startAnimating];
    
    [MLBHTTPRequester searchWithType:[MLBHTTPRequester apiStringForSearchWithSearchType:searchType] keywords:_searchBar.text success:^(id responseObject) {
        [self processWithResponseObject:responseObject];
    } fail:^(NSError *error) {
        [self showHUDServerError];
    }];
}

- (void)processWithResponseObject:(id)responseObject {
    if ([responseObject[@"res"] integerValue] == 0) {
        NSError *error;
        NSArray *results;
        NSArray *data = responseObject[@"data"];
        
        switch (searchType) {
            case MLBSearchTypeHome: {
                results = [MTLJSONAdapter modelsOfClass:[MLBHomeItem class] fromJSONArray:data error:&error];
                break;
            }
            case MLBSearchTypeRead: {
                results = [MTLJSONAdapter modelsOfClass:[MLBSearchRead class] fromJSONArray:data error:&error];
                break;
            }
            case MLBSearchTypeMusic: {
                results = [MTLJSONAdapter modelsOfClass:[MLBRelatedMusic class] fromJSONArray:data error:&error];
                break;
            }
            case MLBSearchTypeMovie: {
                results = [MTLJSONAdapter modelsOfClass:[MLBMovieListItem class] fromJSONArray:data error:&error];
                break;
            }
            case MLBSearchTypeAuthor: {
                results = [MTLJSONAdapter modelsOfClass:[MLBUser class] fromJSONArray:data error:&error];
                break;
            }
        }
        
        if (!error) {
            if (results) {
                [dataSource setObject:results forKey:[@(searchType) stringValue]];
                
                _segmentedControl.hidden = NO;
                _tableView.hidden = NO;
                _hintView.hidden = YES;
                
                [_tableView reloadData];
            } else {
                _hintView.hidden = NO;
            }
            
            [_activityIndicatorView stopAnimating];
        } else {
            [self modelTransformFailedWithError:error];
        }
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
    [self searching];
}

#pragma mark - DZNEmptyDataSetSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"search_null_image"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self dataByCurrentSearchType].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (searchType) {
        case MLBSearchTypeHome:
            return [tableView dequeueReusableCellWithIdentifier:kMLBSearchPictureCellID forIndexPath:indexPath];
        case MLBSearchTypeRead:
            return [tableView dequeueReusableCellWithIdentifier:kMLBSearchReadCellID forIndexPath:indexPath];
        case MLBSearchTypeMusic:
            return [tableView dequeueReusableCellWithIdentifier:kMLBSearchMusicCellID forIndexPath:indexPath];
        case MLBSearchTypeMovie:
            return [tableView dequeueReusableCellWithIdentifier:kMLBSearchMovieCellID forIndexPath:indexPath];
        case MLBSearchTypeAuthor:
            return [tableView dequeueReusableCellWithIdentifier:kMLBSearchAuthorCellID forIndexPath:indexPath];
    }
    
    return nil;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (searchType) {
        case MLBSearchTypeHome:
            return [MLBSearchPictureCell cellHeight];
        case MLBSearchTypeRead:
            return [MLBSearchReadCell cellHeight];
        case MLBSearchTypeMusic:
            return [MLBSearchMusicCell cellHeight];
        case MLBSearchTypeMovie:
            return [MLBSearchMovieCell cellHeight];
        case MLBSearchTypeAuthor:
            return [MLBSearchAuthorCell cellHeight];
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    MLBBaseModel *model = [self dataByCurrentSearchType][indexPath.row];
    
    switch (searchType) {
        case MLBSearchTypeHome:
            [(MLBSearchPictureCell *)cell configureCellWithHomeItem:(MLBHomeItem *)model];
            break;
        case MLBSearchTypeRead:
            [(MLBSearchReadCell *)cell configureCellWithSearchRead:(MLBSearchRead *)model];
            break;
        case MLBSearchTypeMusic:
            [(MLBSearchMusicCell *)cell configureCellWithRelatedMusic:(MLBRelatedMusic *)model];
            break;
        case MLBSearchTypeMovie:
            ((MLBSearchMovieCell *)cell).titleLabel.text = ((MLBMovieListItem *)model).title;
            break;
        case MLBSearchTypeAuthor:
            [(MLBSearchAuthorCell *)cell configureCellWithUser:(MLBUser *)model];
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (searchType) {
        case MLBSearchTypeHome: {
            MLBSingleHomeViewController *singleHomeViewController = [[MLBSingleHomeViewController alloc] init];
            singleHomeViewController.homeItem = [self dataByCurrentSearchType][indexPath.row];
            [self.navigationController pushViewController:singleHomeViewController animated:YES];
            break;
        }
        case MLBSearchTypeRead: {
            break;
        }
        case MLBSearchTypeMusic: {
            MLBMusicRelatedViewController *musicRelatedViewController = [[MLBMusicRelatedViewController alloc] init];
            musicRelatedViewController.relatedMusic = [self dataByCurrentSearchType][indexPath.row];
            [self.navigationController pushViewController:musicRelatedViewController animated:YES];
            break;
        }
        case MLBSearchTypeMovie: {
            MLBMovieDetailsViewController *movieDetailsViewController = [[MLBMovieDetailsViewController alloc] init];
            movieDetailsViewController.movieListItem = [self dataByCurrentSearchType][indexPath.row];
            [self.navigationController pushViewController:movieDetailsViewController animated:YES];
            break;
        }
        case MLBSearchTypeAuthor: {
            
            break;
        }
    }
    
}

@end
