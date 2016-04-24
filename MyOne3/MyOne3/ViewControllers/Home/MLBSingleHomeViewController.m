//
//  MLBSingleHomeViewController.m
//  MyOne3
//
//  Created by meilbn on 4/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBSingleHomeViewController.h"
#import "MLBHomeItem.h"
#import "MLBHomeView.h"

@interface MLBSingleHomeViewController ()

@property (strong, nonatomic) MLBHomeView *homeView;

@end

@implementation MLBSingleHomeViewController

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
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_home_title"]];
    self.navigationItem.titleView = titleView;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initDatas];
    [self setupViews];
}

#pragma mark - Private Method

- (void)initDatas {
    
}

- (void)setupViews {
    _homeView = [[MLBHomeView alloc] initWithFrame:self.view.bounds];
    [_homeView configureViewWithHomeItem:_homeItem atIndex:-1 inViewController:self];
    [self.view addSubview:_homeView];
    [_homeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(-64, 0, 0, 0));
    }];
}

#pragma mark - Public Method



#pragma mark - Action



#pragma mark - Network Request




@end
