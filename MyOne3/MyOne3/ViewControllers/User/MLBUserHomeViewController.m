//
//  MLBUserHomeViewController.m
//  MyOne3
//
//  Created by meilbn on 3/16/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBUserHomeViewController.h"
#import "ParallaxHeaderView.h"
#import "MLBUserHomeCell.h"
#import "MLBUserHomeHeaderView.h"
#import "MLBSettingsSectionHeaderView.h"
#import "MLBSettingsViewController.h"
#import "UINavigationController+MLBNavigationShouldPopExtention.h"

@interface MLBUserHomeViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerShouldPop>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) MLBUserHomeHeaderView *headerView;

@end

@implementation MLBUserHomeViewController {
    NSArray *sectionTitles;
    NSArray *rowTitles;
    NSArray *rowImageNames;
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
	
    [self initDatas];
    [self setupViews];
}

#pragma mark - Private Method

- (void)initDatas {
    sectionTitles = @[@"设置"];
    rowTitles = @[@[@"其他设置"]];
    rowImageNames = @[@[@"center_setting"]];
}

- (void)setupViews {
    _headerView = [[MLBUserHomeHeaderView alloc] initWithUserType:MLBUserTypeMe];
    [_headerView configureHeaderViewForTestMe];
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.backgroundColor = MLBViewControllerBGColor;
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[MLBUserHomeCell class] forCellReuseIdentifier:kUserHomeCellID];
        [tableView registerClass:[MLBSettingsSectionHeaderView class] forHeaderFooterViewReuseIdentifier:kSettingsSectionHeaderViewID];
		tableView.sectionFooterHeight = 10;
        tableView.rowHeight = [MLBUserHomeCell cellHeight];
        
        UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage mlb_imageWithName:@"personalBackgroundImage" cached:NO]];
        headerImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 206);
        headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        ParallaxHeaderView *parallaxHeaderView = [ParallaxHeaderView parallaxHeaderViewWithSubView:headerImageView];
        
        UIImageView *shadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"movie_shadow"]];
        [parallaxHeaderView addSubview:shadowView];
        [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
            make.left.bottom.right.equalTo(parallaxHeaderView);
        }];
        
        [parallaxHeaderView addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@([_headerView viewHeight]));
            make.left.bottom.right.equalTo(parallaxHeaderView);
        }];
        
        tableView.tableHeaderView = parallaxHeaderView;
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        tableView;
    });
}

#pragma mark - UINavigationControllerShouldPop

- (BOOL)navigationControllerShouldPop:(UINavigationController *)navigationController {
	[self popViewControllerWithAnimation];
	return NO;
}

#pragma mark - Action

- (void)popViewControllerWithAnimation {
	[UIView beginAnimations:@"popUserHome" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.75];
	[self.navigationController popViewControllerAnimated:NO];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[UIApplication sharedApplication].keyWindow cache:NO];
	[UIView commitAnimations];
}

#pragma mark - Network Request



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [(ParallaxHeaderView *)_tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rows = rowTitles[section];
    return rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLBUserHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserHomeCellID forIndexPath:indexPath];
    [cell configureCellWithTitle:rowTitles[indexPath.section][indexPath.row] imageName:rowImageNames[indexPath.section][indexPath.row] atIndexPath:indexPath];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [MLBSettingsSectionHeaderView viewHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MLBSettingsSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSettingsSectionHeaderViewID];
    view.titleLabel.text = sectionTitles[section];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[[MLBSettingsViewController alloc] init] animated:YES];
}

@end
