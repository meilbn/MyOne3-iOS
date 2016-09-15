//
//  MLBBaseViewController.m
//  MyOne3
//
//  Created by meilbn on 2/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseViewController.h"
#import "MLBLiginOptsViewController.h"
#import "MLBMusicControlView.h"
#import "MLBUserHomeViewController.h"
#import "MLBSearchViewController.h"

@interface MLBBaseViewController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) YLImageView *playerView;

@end

@implementation MLBBaseViewController

#pragma mark - Lifecycle

- (void)dealloc {
	DDLogDebug(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)init {
	self = [super init];
	
	if (self) {
		self.hidesBottomBarWhenPushed = YES;
	}
	
	return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置标题栏不能覆盖下面 ViewController 的内容
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = _hideNavigationBar;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	if (self.navigationController.viewControllers.count == 1) {// 关闭主界面的右滑返回
		return NO;
	} else {
		return YES;
	}
}

#pragma mark - Public Methods

- (CGFloat)navigationBarHeight {
	return CGRectGetHeight(self.navigationController.navigationBar.bounds) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
}

#pragma mark - UI

- (void)addNavigationBarLeftSearchItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_search"] style:UIBarButtonItemStylePlain target:self action:@selector(showSearchingViewController)];
}

- (void)addNavigationBarRightMeItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_me_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(pushMeViewController)];
}

//- (void)addNavigationBarRightItems {
//    UIBarButtonItem *plantItem = [self rightPlantItem];
//    UIBarButtonItem *playerItem = [self rightMusicItem];
//    
//    self.navigationItem.rightBarButtonItems = @[plantItem, playerItem];
//}
//
//- (void)addNavigationBarRightMusicItem {
//    self.navigationItem.rightBarButtonItem = [self rightMusicItem];
//}
//
//- (UIBarButtonItem *)rightPlantItem {
//    UIButton *plantButton = [MLBUIFactory buttonWithImageName:@"nav_me_normal" highlightImageName:@"nav_me_highlighted" target:self action:@selector(plantButtonClicked)];
//    plantButton.frame = (CGRect){{0, 0}, CGSizeMake(20, 28)};
//	
//    return [[UIBarButtonItem alloc] initWithCustomView:plantButton];
//}
//
//- (UIBarButtonItem *)rightMusicItem {
//    _playerView = [[YLImageView alloc] initWithFrame:(CGRect){{0, 0}, CGSizeMake(44, 18)}];
//    _playerView.contentMode = UIViewContentModeScaleAspectFit;
//    _playerView.image = [YLGIFImage imageNamed:@"my_player_stop.gif"];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMusicControlView)];
//    [_playerView addGestureRecognizer:tap];
//	
//    return [[UIBarButtonItem alloc] initWithCustomView:_playerView];
//}

#pragma mark - Action

- (void)pushMeViewController {
	[UIView beginAnimations:@"pushUserHome" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.75];
	[self.navigationController pushViewController:[[MLBUserHomeViewController alloc] init] animated:NO];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[UIApplication sharedApplication].keyWindow cache:NO];
	[UIView commitAnimations];
}

- (void)showSearchingViewController {
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:[[MLBSearchViewController alloc] init]] animated:YES completion:NULL];
}

//- (void)plantButtonClicked {
//	
//}
//
//- (void)showMusicControlView {
//    [[MLBMusicControlView sharedInstance] show];
//}

#pragma mark - Public Action

- (void)presentLoginOptsViewController {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[MLBLiginOptsViewController alloc] init]];
    [self presentViewController:nav animated:YES completion:NULL];
}

@end
