//
//  MLBMusicViewController.m
//  MyOne3
//
//  Created by meilbn on 2/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBMusicViewController.h"

@interface MLBMusicViewController ()

@end

@implementation MLBMusicViewController

#pragma mark - Lifecycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = MLBMusicTitle;
    
    [self initDatas];
    [self setupViews];
}

#pragma mark - Private Method

- (void)initDatas {
    
}

- (void)setupViews {
    [self addNavigationBarRightItems];
    
    UIButton *librariesButton = [MLBUIFactory buttonWithImageName:@"nav_music_libraries_normal" highlightImageName:@"nav_music_libraries_highlighted" target:self action:@selector(librariesButtonClicked)];
    librariesButton.frame = (CGRect){{0, 0}, CGSizeMake(20, 28)};
    UIBarButtonItem *librariesItem = [[UIBarButtonItem alloc] initWithCustomView:librariesButton];
    self.navigationItem.leftBarButtonItem = librariesItem;
}

#pragma mark - Action

- (void)librariesButtonClicked {
    
}

#pragma mark - Network Request




@end
