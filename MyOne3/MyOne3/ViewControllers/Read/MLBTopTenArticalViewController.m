//
//  MLBTopTenArticalViewController.m
//  MyOne3
//
//  Created by meilbn on 2/27/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBTopTenArticalViewController.h"
#import "MLBReadCarouselItem.h"
#import "MLBTopTenArtical.h"
#import "MLBTopTenArticalCell.h"

@interface MLBTopTenArticalViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *bottomLabel;
@property (strong, nonatomic) UIImageView *coverView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *footerView;

@end

@implementation MLBTopTenArticalViewController {
    NSArray *dataSource;
    NSInteger tableViewWrapperViewHeight;
    NSInteger bottomTextLabelHeight;
    NSInteger coverViewHeight;
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
    
    [self initDatas];
    [self setupViews];
    [self requestTopTenArtical];
}

#pragma mark - Private Method

- (void)initDatas {
    coverViewHeight = 168;
    bottomTextLabelHeight = SCREEN_HEIGHT - coverViewHeight;
}

- (void)setupViews {
    if (_tableView) {
        return;
    }
    
    self.view.backgroundColor = [UIColor colorWithHexString:[_carouselItem.bgColor substringFromIndex:1]];
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        tableView.backgroundColor = self.view.backgroundColor;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[MLBTopTenArticalCell class] forCellReuseIdentifier:kMLBTopTenArticalCellID];
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        tableView;
    });
    
    _closeButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"close_normal_white" highlightImageName:@"close_normal" target:self action:@selector(close)];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.top.equalTo(self.view).offset(24);
            make.left.equalTo(self.view);
        }];
        
        button;
    });
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    _headerView.backgroundColor = _tableView.backgroundColor;
    
    _titleLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.font = FontWithSize(18);
        label.text = _carouselItem.title;
        label.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_headerView).insets(UIEdgeInsetsMake(-5, 0, 5, 0));
        }];
        
        label;
    });
    
    _tableView.tableHeaderView = _headerView;
    
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _footerView.backgroundColor = _tableView.backgroundColor;
    
    _bottomLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, bottomTextLabelHeight)];
        label.backgroundColor = _footerView.backgroundColor;
        label.textColor = [UIColor whiteColor];
        label.font = FontWithSize(28);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = _carouselItem.bottomText;
        label.numberOfLines = 0;
        [_footerView addSubview:label];
        
        label;
    });
    
    _coverView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, bottomTextLabelHeight, SCREEN_WIDTH, coverViewHeight)];
        imageView.backgroundColor = _footerView.backgroundColor;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView mlb_sd_setImageWithURL:_carouselItem.cover placeholderImageName:nil];
        [_footerView addSubview:imageView];
        
        imageView;
    });
}

#pragma mark - Action

- (void)close {
    [self dismissViewControllerAnimated:NO completion:NULL];
}

#pragma mark - Network Request

- (void)requestTopTenArtical {
    [MLBHTTPRequester requestReadCarouselDetailsById:_carouselItem.itemId success:^(id responseObject) {
        if ([responseObject[@"res"] integerValue] == 0) {
            NSError *error;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[MLBTopTenArtical class] fromJSONArray:responseObject[@"data"] error:&error];
            if (!error) {
                dataSource = array;
                [_tableView reloadData];
                _tableView.tableFooterView = _footerView;
                tableViewWrapperViewHeight = CGRectGetHeight(_headerView.frame) + dataSource.count * [MLBTopTenArticalCell cellHeight] + CGRectGetHeight(_footerView.frame);
            } else {
                [self modelTransformFailedWithError:error];
            }
        } else {
            [self showHUDErrorWithText:responseObject[@"msg"]];
        }
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ((scrollView.contentOffset.y + SCREEN_HEIGHT) > tableViewWrapperViewHeight) {
        CGFloat diff = scrollView.contentOffset.y + SCREEN_HEIGHT - tableViewWrapperViewHeight;
        CGFloat height = (diff + coverViewHeight / 2.0) * 2.0;
        CGFloat transformRatio = height / coverViewHeight;
        CGAffineTransform transform = CGAffineTransformMake(transformRatio, 0, 0, transformRatio, 0, 0);
        _coverView.y = bottomTextLabelHeight;
        [UIView animateWithDuration:0.1
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _coverView.transform = transform;
                         }
                         completion:NULL];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLBTopTenArticalCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLBTopTenArticalCellID forIndexPath:indexPath];
    [cell configureCellWithTopTenArtical:dataSource[indexPath.row]];
    cell.backgroundColor = _tableView.backgroundColor;
    cell.contentView.backgroundColor = _tableView.backgroundColor;
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MLBTopTenArticalCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
