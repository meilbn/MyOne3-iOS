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

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = MLBViewControllerBGColor;
    // 设置标题栏不能覆盖下面 ViewController 的内容
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationController.navigationBar.hidden = _hideNavigationBar;
    
    [self initDatas];
    [self setupViews];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = _hideNavigationBar;
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBar.hidden = _hideNavigationBar;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self == [self.navigationController.viewControllers firstObject]) {
        self.hidesBottomBarWhenPushed = NO;
    }
}

#pragma mark - Private Method

- (void)initDatas {
    
}

- (void)setupViews {
    
}

#pragma mark - HUD

- (void)showHUDWithText:(NSString *)text delay:(NSTimeInterval)delay {
    if (!HUD.isHidden) {
        [HUD hide:NO];
    }
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Configure for text only and offset down
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = text;
    HUD.margin = 10.f;
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:delay];
}

- (void)showHUDDone {
    [self showHUDDoneWithText:@"Completed"];
}

- (void)showHUDDoneWithText:(NSString *)text {
    if (!HUD.isHidden) {
        [HUD hide:NO];
    }
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_right"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = text;
    [HUD show:YES];
    [HUD hide:YES afterDelay:HUD_DELAY];
}

- (void)showHUDErrorWithText : (NSString *)text {
    if (!HUD.isHidden) {
        [HUD hide:NO];
    }
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_error"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = text;
    [HUD show:YES];
    [HUD hide:YES afterDelay:HUD_DELAY];
}

- (void)showHUDNetError {
    [self showHUDErrorWithText:BAD_NETWORK];
}

- (void)showHUDServerError {
    [self showHUDErrorWithText:SERVER_ERROR];
}

- (void)showWithLabelText:(NSString *)showText executing:(SEL)method {
    if (!HUD.isHidden) {
        [HUD hide:NO];
    }
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = showText;
    [HUD showWhileExecuting:method onTarget:self withObject:nil animated:YES];
}

- (void)showHUDWithText:(NSString *)text {
    [self hideHud];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Configure for text only and offset down
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = text;
    HUD.margin = 10.f;
    HUD.removeFromSuperViewOnHide = YES;
}

- (void)modelTransformFailedWithError:(NSError *)error {
    [self showHUDErrorWithText:@"JSON 转 Model 失败"];
    DDLogDebug(@"error = %@", error);
}

- (void)hideHud {
    if (HUD && !HUD.isHidden) {
        [HUD hide:NO];
    }
}

#pragma mark - UI

- (void)addNavigationBarRightItems {
    UIButton *plantButton = [MLBUIFactory buttonWithImageName:@"nav_me_normal" highlightImageName:@"nav_me_highlighted" target:self action:@selector(plantButtonClicked)];
    plantButton.frame = (CGRect){{0, 0}, CGSizeMake(20, 28)};
    UIBarButtonItem *plantItem = [[UIBarButtonItem alloc] initWithCustomView:plantButton];
    
    _playerView = [[YLImageView alloc] initWithFrame:(CGRect){{0, 0}, CGSizeMake(44, 18)}];
    _playerView.contentMode = UIViewContentModeScaleAspectFit;
    _playerView.image = [YLGIFImage imageNamed:@"my_player_stop.gif"];
    UIBarButtonItem *playerItem = [[UIBarButtonItem alloc] initWithCustomView:_playerView];
    
    self.navigationItem.rightBarButtonItems = @[plantItem, playerItem];
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

- (void)plantButtonClicked {
    
}

- (void)presentLoginOptsViewController {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[MLBLiginOptsViewController alloc] init]];
//    nav.navigationBar.hidden = YES;
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
