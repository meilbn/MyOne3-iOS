//
//  MLBTabBarController.m
//  MyOne3
//
//  Created by meilbn on 2/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBTabBarController.h"
#import "MLBHomeViewController.h"
#import "MLBReadViewController.h"
#import "MLBMusicViewController.h"
#import "MLBMovieViewController.h"

@interface MLBTabBarController ()

@end

@implementation MLBTabBarController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        MLBHomeViewController *homeViewController = [[MLBHomeViewController alloc] init];
        UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
        homeNavigationController.title = MLBHomeTitle;
        
        MLBReadViewController *readViewController = [[MLBReadViewController alloc] init];
        UINavigationController *readNavigationController = [[UINavigationController alloc] initWithRootViewController:readViewController];
        readNavigationController.title = MLBReadTitle;
        
        MLBMusicViewController *musicViewController = [[MLBMusicViewController alloc] init];
        UINavigationController *musicNavigationController = [[UINavigationController alloc] initWithRootViewController:musicViewController];
        musicNavigationController.title = MLBMusicTitle;
        
        MLBMovieViewController *movieViewController = [[MLBMovieViewController alloc] init];
        UINavigationController *movieNavigationController = [[UINavigationController alloc] initWithRootViewController:movieViewController];
        movieNavigationController.title = MLBMovieTitle;
        
        [self setViewControllers:@[homeNavigationController, readNavigationController, musicNavigationController, movieNavigationController]];
        [self setupTabBar];
        
        [self createCacheFilesFolder];
    }
    
    return self;
}

- (void)setupTabBar {
    NSArray *tabBarItemImageNames = @[@"tab_home", @"tab_read", @"tab_music", @"tab_movie"];
    NSInteger index = 0;
    
    for (UIViewController *vc in self.viewControllers) {
        NSString *normalImageName =  [NSString stringWithFormat:@"%@_normal", [tabBarItemImageNames objectAtIndex:index]];
        NSString *selectedImageName = [NSString stringWithFormat:@"%@_selected", [tabBarItemImageNames objectAtIndex:index]];
        UIImage *normalImage = [UIImage imageNamed:normalImageName];
        UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
        
        vc.tabBarItem.image = normalImage;
        vc.tabBarItem.selectedImage = selectedImage;
        
        index++;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createCacheFilesFolder {
    NSString *cacheFilesFolderPath = [NSString stringWithFormat:@"%@/%@", DocumentsDirectory, MLBCacheFilesFolderName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isDirExist = [fileManager fileExistsAtPath:cacheFilesFolderPath isDirectory:&isDir];
    
    if(!(isDirExist && isDir)) {
        [fileManager createDirectoryAtPath:cacheFilesFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

@end
