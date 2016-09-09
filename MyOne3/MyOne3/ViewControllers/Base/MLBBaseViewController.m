//
//  MLBBaseViewController.m
//  MyOne3
//
//  Created by meilbn on 2/20/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <MJRefresh/MJRefresh.h>
#import "PopMenu.h"
#import "MenuButton.h"
#import "MLBLiginOptsViewController.h"
#import "MLBMusicControlView.h"
#import "MLBUserHomeViewController.h"
#import "MLBSearchViewController.h"

@interface MLBBaseViewController ()

@property (strong, nonatomic) YLImageView *playerView;
@property (strong, nonatomic) PopMenu *popMenu;

@end

@implementation MLBBaseViewController {
    MBProgressHUD *HUD;
}

#pragma mark - Lifecycle

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
    self.view.backgroundColor = MLBViewControllerBGColor;
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

#pragma mark - Private Method



#pragma mark - UI

- (void)addNavigationBarLeftSearchItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_search"] style:UIBarButtonItemStylePlain target:self action:@selector(showSearchingViewController)];
}

- (void)addNavigationBarRightMeItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_me_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(pushMeViewController)];
}

- (void)addNavigationBarRightItems {
    UIBarButtonItem *plantItem = [self rightPlantItem];
    UIBarButtonItem *playerItem = [self rightMusicItem];
    
    self.navigationItem.rightBarButtonItems = @[plantItem, playerItem];
}

- (void)addNavigationBarRightMusicItem {
    self.navigationItem.rightBarButtonItem = [self rightMusicItem];
}

- (UIBarButtonItem *)rightPlantItem {
    UIButton *plantButton = [MLBUIFactory buttonWithImageName:@"nav_me_normal" highlightImageName:@"nav_me_highlighted" target:self action:@selector(plantButtonClicked)];
    plantButton.frame = (CGRect){{0, 0}, CGSizeMake(20, 28)};
    return [[UIBarButtonItem alloc] initWithCustomView:plantButton];
}

- (UIBarButtonItem *)rightMusicItem {
    _playerView = [[YLImageView alloc] initWithFrame:(CGRect){{0, 0}, CGSizeMake(44, 18)}];
    _playerView.contentMode = UIViewContentModeScaleAspectFit;
    _playerView.image = [YLGIFImage imageNamed:@"my_player_stop.gif"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMusicControlView)];
    [_playerView addGestureRecognizer:tap];
    return [[UIBarButtonItem alloc] initWithCustomView:_playerView];
}

- (void)endRefreshingScrollView:(UIScrollView *)scrollView hasMoreData:(BOOL)hasMoreData {
    if (scrollView.mj_header && scrollView.mj_header.isRefreshing) {
        [scrollView.mj_header endRefreshing];
        [scrollView.mj_footer resetNoMoreData];
    }
    
    if (hasMoreData) {
        [scrollView.mj_footer endRefreshing];
    } else {
        [scrollView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)showPopMenuViewWithMenuSelectedBlock:(MenuSelectedBlock)block {
    if (!_popMenu) {
        NSArray *imgNames = @[@"more_wechat", @"more_moments", @"more_sina", @"more_qq", @"more_link", @"more_collection"];
        NSArray *titles = @[@"微信好友", @"朋友圈", @"微博", @"QQ", @"复制链接", @"收藏"];
        NSArray *colors = @[[UIColor colorWithRGBHex:0x70E08D],
                            [UIColor colorWithRGBHex:0x70E08D],
                            [UIColor colorWithRGBHex:0xFF8467],
                            [UIColor colorWithRGBHex:0x49AFD6],
                            [UIColor colorWithRGBHex:0x659AD9],
                            [UIColor colorWithRGBHex:0xF6CC41]];
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:imgNames.count];
        for (NSInteger i = 0; i < imgNames.count; i++) {
            MenuItem *item = [[MenuItem alloc] initWithTitle:titles[i] iconName:imgNames[i] glowColor:colors[i] index:i];
            [items addObject:item];
        }
        
        _popMenu = [[PopMenu alloc] initWithFrame:kKeyWindow.bounds items:items];
        _popMenu.menuAnimationType = kPopMenuAnimationTypeSina;
        _popMenu.perRowItemCount = 1;
        _popMenu.didSelectedItemCompletion = ^(MenuItem *selectedItem) {
            if (block) {
                block((MLBPopMenuType)selectedItem.index);
            }
        };
    }
    
    [_popMenu showMenuAtView:kKeyWindow];
}

#pragma mark - Action

- (void)pushMeViewController {
    
}

- (void)showSearchingViewController {
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:[[MLBSearchViewController alloc] init]] animated:YES completion:NULL];
}

- (void)plantButtonClicked {
    [self.navigationController pushViewController:[[MLBUserHomeViewController alloc] init] animated:YES];
}

- (void)showMusicControlView {
    [[MLBMusicControlView sharedInstance] show];
}

- (void)presentLoginOptsViewController {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[MLBLiginOptsViewController alloc] init]];
    [self presentViewController:nav animated:YES completion:NULL];
}

- (void)blowUpImage:(UIImage *)image referenceRect:(CGRect)referenceRect referenceView:(UIView *)referenceView {
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = image;
    imageInfo.referenceRect = referenceRect;
    imageInfo.referenceView = referenceView;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc] initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    
    // Present the view controller.
    [imageViewer showFromViewController:kKeyWindow.rootViewController transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

@end
