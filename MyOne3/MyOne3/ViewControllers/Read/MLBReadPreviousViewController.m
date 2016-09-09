//
//  MLBReadPreviousViewController.m
//  MyOne3
//
//  Created by meilbn on 4/19/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadPreviousViewController.h"
#import "MLBReadPreviousCell.h"
#import "MLBReadEssay.h"
#import "MLBReadSerial.h"
#import "MLBReadQuestion.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>

@interface MLBReadPreviousViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation MLBReadPreviousViewController

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
        [tableView registerClass:[MLBReadPreviousCell class] forCellReuseIdentifier:kMLBReadPreviousCellID];
        tableView.tableFooterView = [UIView new];
        tableView.separatorColor = MLBSeparatorColor;
        tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
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
    switch (_readType) {
        case MLBReadTypeEssay: {
            __weak typeof(self) weakSelf = self;
			[MLBHTTPRequester requestEssayByMonthWithPeriod:_period success:^(id responseObject) {
				__strong typeof(weakSelf) strongSelf = weakSelf;
				if (!strongSelf) {
					return;
				}
				
                [strongSelf processResponseObject:responseObject];
            } fail:^(NSError *error) {
				__strong typeof(weakSelf) strongSelf = weakSelf;
				if (!strongSelf) {
					return;
				}
				
                [strongSelf.view showHUDServerError];
            }];
            break;
        }
        case MLBReadTypeSerial: {
            __weak typeof(self) weakSelf = self;
			[MLBHTTPRequester requestSerialByMonthWithPeriod:_period success:^(id responseObject) {
				__strong typeof(weakSelf) strongSelf = weakSelf;
				if (!strongSelf) {
					return;
				}
				
                [strongSelf processResponseObject:responseObject];
            } fail:^(NSError *error) {
				__strong typeof(weakSelf) strongSelf = weakSelf;
				if (!strongSelf) {
					return;
				}
				
                [strongSelf.view showHUDServerError];
            }];
            break;
        }
        case MLBReadTypeQuestion: {
            __weak typeof(self) weakSelf = self;
			[MLBHTTPRequester requestQuestionByMonthWithPeriod:_period success:^(id responseObject) {
				__strong typeof(weakSelf) strongSelf = weakSelf;
				if (!strongSelf) {
					return;
				}
				
                [strongSelf processResponseObject:responseObject];
            } fail:^(NSError *error) {
				__strong typeof(weakSelf) strongSelf = weakSelf;
				if (!strongSelf) {
					return;
				}
				
                [strongSelf.view showHUDServerError];
            }];
            break;
        }
    }
}

- (void)processResponseObject:(id)responseObject {
    if ([responseObject[@"res"] integerValue] == 0) {
        NSError *error;
        NSArray *datas;
        switch (_readType) {
            case MLBReadTypeEssay: {
                datas = [MTLJSONAdapter modelsOfClass:[MLBReadEssay class] fromJSONArray:responseObject[@"data"] error:&error];
                break;
            }
            case MLBReadTypeSerial: {
                datas = [MTLJSONAdapter modelsOfClass:[MLBReadSerial class] fromJSONArray:responseObject[@"data"] error:&error];
                break;
            }
            case MLBReadTypeQuestion: {
                datas = [MTLJSONAdapter modelsOfClass:[MLBReadQuestion class] fromJSONArray:responseObject[@"data"] error:&error];
                break;
            }
        }
        
        if (!error) {
            _dataSource = datas;
            [_tableView reloadData];
        } else {
            [self.view showHUDModelTransformFailedWithError:error];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:kMLBReadPreviousCellID forIndexPath:indexPath];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:kMLBReadPreviousCellID cacheByIndexPath:indexPath configuration:^(MLBReadPreviousCell *cell) {
        [cell configureViewWithReadModel:_dataSource[indexPath.row] type:_readType atIndexPath:indexPath];
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(MLBReadPreviousCell *)cell configureViewWithReadModel:_dataSource[indexPath.row] type:_readType atIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
