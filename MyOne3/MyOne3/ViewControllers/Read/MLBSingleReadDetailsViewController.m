//
//  MLBSingleReadDetailsViewController.m
//  MyOne3
//
//  Created by meilbn on 3/15/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBSingleReadDetailsViewController.h"
#import "MLBReadEssay.h"
#import "MLBReadSerial.h"
#import "MLBReadQuestion.h"
#import "MLBReadDetailsView.h"

@interface MLBSingleReadDetailsViewController ()

@property (strong, nonatomic) MLBReadDetailsView *readDetailsView;

@end

@implementation MLBSingleReadDetailsViewController

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
}

#pragma mark - Private Method

- (void)initDatas {
    
}

- (void)setupViews {
    _readDetailsView = [[MLBReadDetailsView alloc] init];
    [self.view addSubview:_readDetailsView];
    [_readDetailsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_readDetailsView prepareForReuseWithViewType:_readType];
    [_readDetailsView configureViewWithReadModel:_readModel type:_readType atIndex:0 inViewController:self];
}

#pragma mark - Public Method



#pragma mark - Action



#pragma mark - Network Request




@end
