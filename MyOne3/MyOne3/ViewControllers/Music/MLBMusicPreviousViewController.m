//
//  MLBMusicPreviousViewController.m
//  MyOne3
//
//  Created by meilbn on 4/19/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBMusicPreviousViewController.h"
#import "MLBRelatedMusic.h"
#import "MLBRelatedMusicCell.h"

@interface MLBMusicPreviousViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MLBMusicPreviousViewController {
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initDatas];
    [self setupViews];
    [self requestPeriodList];
}

#pragma mark - Private Method

- (void)initDatas {
    
}

- (void)setupViews {    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[MLBRelatedMusicCell class] forCellReuseIdentifier:kMLBRelatedMusicCellID];
        tableView.tableFooterView = [UIView new];
        tableView.separatorColor = MLBSeparatorColor;
        tableView.separatorInset = UIEdgeInsetsMake(0, 65, 0, 0);
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        tableView;
    });
}

#pragma mark - Public Method



#pragma mark - Action



#pragma mark - Network Request

- (void)requestPeriodList {
    [MLBHTTPRequester requestMusicByMonthWithPeriod:_period success:^(id responseObject) {
        if ([responseObject[@"res"] integerValue] == 0) {
            NSError *error;
            NSArray *musics = [MTLJSONAdapter modelsOfClass:[MLBRelatedMusic class] fromJSONArray:responseObject[@"data"] error:&error];
            if (!error) {
                dataSource = musics;
                [_tableView reloadData];
            } else {
                [self modelTransformFailedWithError:error];
            }
        }
    } fail:^(NSError *error) {
        [self showHUDServerError];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:kMLBRelatedMusicCellID forIndexPath:indexPath];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MLBRelatedMusicCell cellHeight];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(MLBRelatedMusicCell *)cell configureCellWithRelatedMusic:dataSource[indexPath.row] atIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
