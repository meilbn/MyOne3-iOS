//
//  MLBPoilcyViewController.m
//  MyOne3
//
//  Created by meilbn on 2/25/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBPoilcyViewController.h"

@interface MLBPoilcyViewController ()

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation MLBPoilcyViewController

#pragma mark - Lifecycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"用户协议";
    self.hideNavigationBar = NO;
    
    [self initDatas];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

#pragma mark - Private Method

- (void)initDatas {
    
}

- (void)setupViews {
    _webView = ({
        UIWebView *webView = [UIWebView new];
        webView.backgroundColor = self.view.backgroundColor;
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.wufazhuce.com/policy?from=ONEApp"]]];
        [self.view addSubview:webView];
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        webView;
    });
}

@end
