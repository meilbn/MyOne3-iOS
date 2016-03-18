//
//  MLBMusicRelatedViewController.m
//  MyOne3
//
//  Created by meilbn on 3/17/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBMusicRelatedViewController.h"
#import "MLBMusicView.h"
#import "MLBRelatedMusic.h"

@interface MLBMusicRelatedViewController ()

@property (strong, nonatomic) MLBMusicView *musicView;

@end

@implementation MLBMusicRelatedViewController

#pragma mark - Lifecycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavigationBarRightMusicItem];
    
    [self initDatas];
    [self setupViews];
}

#pragma mark - Private Method

- (void)initDatas {
    
}

- (void)setupViews {
    _musicView = [[MLBMusicView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_musicView];
    [_musicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_musicView prepareForReuse];
    [_musicView configureViewWithMusicId:_relatedMusic.musicId atIndex:0 inViewController:self];
}

#pragma mark - Public Method



#pragma mark - Action



#pragma mark - Network Request




@end
