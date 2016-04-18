//
//  MLBMovieDetailsViewController.m
//  MyOne3
//
//  Created by meilbn on 2/28/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBMovieDetailsViewController.h"
#import "MLBMovieDetailsHeaderView.h"
#import "MLBNoneMessageCell.h"
#import "MLBMovieListItem.h"
#import "MLBMovieDetails.h"
#import "MLBCommentListViewController.h"
#import "MLBTicketsGrossView.h"
#import "MLBMoviePosterCCell.h"
#import <NYTPhotoViewer/NYTPhoto.h>
#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import "MLBMoviePoster.h"

typedef NS_ENUM(NSUInteger, MLBMovieDetailsType) {
    MLBMovieDetailsTypeNone,
    MLBMovieDetailsTypeTable,
    MLBMovieDetailsTypeStills,
    MLBMovieDetailsTypeCast,
};

@interface MLBMovieDetailsViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) MLBMovieDetailsHeaderView *headerView;
@property (strong, nonatomic) UIView *toolView;
@property (strong, nonatomic) UIButton *ticketButton;
@property (strong, nonatomic) UIButton *gradeButton;
@property (strong, nonatomic) UIButton *moreButton;
@property (strong, nonatomic) UIView *shareView;
@property (strong, nonatomic) UIButton *scoreShareButton;
@property (strong, nonatomic) UIButton *otherShareButton;
@property (strong, nonatomic) MLBCommentListViewController *storyListViewController;
@property (strong, nonatomic) MLBCommentListViewController *reviewListViewController;
@property (strong, nonatomic) MLBCommentListViewController *commentListViewController;
@property (strong, nonatomic) UIView *infoView;
@property (strong, nonatomic) UILabel *infoTypeLabel;
@property (strong, nonatomic) UIButton *movieTableButton;
@property (strong, nonatomic) UIButton *stillsButton;
@property (strong, nonatomic) UIButton *castButton;
@property (strong, nonatomic) MLBTicketsGrossView *grossView;
@property (strong, nonatomic) UICollectionView *moviePosterView;
@property (strong, nonatomic) UITextView *castTextView;
@property (strong, nonatomic) MLBCommonHeaderView *scoreHeaderView;
@property (strong, nonatomic) UILabel *scoreRatioLabel;

@property (strong, nonatomic) MASConstraint *moreButtonWidthConstraint;
@property (strong, nonatomic) MASConstraint *shareViewRightConstraint;
@property (strong, nonatomic) MASConstraint *storiesTableViewHeightConstraint;
@property (strong, nonatomic) MASConstraint *reviewsTableViewHeightConstraint;
@property (strong, nonatomic) MASConstraint *commentsTableViewHeightConstraint;

@end

@implementation MLBMovieDetailsViewController {
    NSNumber *tableViewInitHeight;
    MLBMovieDetails *movieDetails;
    NSArray *infoButtons;
    NSArray *keywordsLabels;
    NSMutableArray <MLBMoviePoster *> *posters;
}

#pragma mark - Lifecycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DDLogDebug(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [_storyListViewController removeFromParentViewController];
    [_reviewListViewController removeFromParentViewController];
    [_commentListViewController removeFromParentViewController];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _movieListItem.title;
    
    [self initDatas];
    [self setupViews];
    [self prepareForDisplay];
    [self requestMovieDetails];
}

#pragma mark - Private Method

- (void)initDatas {
    tableViewInitHeight = @([MLBCommonHeaderView headerViewHeight] + [MLBCommonFooterView footerViewHeight] + [MLBNoneMessageCell cellHeight] + 1);
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollView = ({
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.backgroundColor = self.view.backgroundColor;
        scrollView.delegate = self;
        [self.view addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        scrollView;
    });
    
    _contentView = ({
        UIView *view = [UIView new];
        view.backgroundColor = _scrollView.backgroundColor;
        [_scrollView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_scrollView);
            make.width.equalTo(@(SCREEN_WIDTH));
        }];
        
        view;
    });
    
    _headerView = ({
        MLBMovieDetailsHeaderView *headerView = [MLBMovieDetailsHeaderView new];
        headerView.backgroundColor = _contentView.backgroundColor;
        [_contentView addSubview:headerView];
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(_contentView);
            make.height.equalTo(headerView.mas_width).dividedBy(1.808);
        }];
        
        headerView;
    });
    
    _toolView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@48);
            make.top.equalTo(_headerView.mas_bottom);
            make.left.right.equalTo(_contentView);
        }];
        
        view;
    });
    
    _ticketButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"movie_ticket_normal" highlightImageName:@"movie_ticket_highlighted" target:self action:@selector(ticketButtonClicked)];
        [button setTitle:@"购票" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:170 / 255.0 alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = FontWithSize(12);
        [_toolView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(_toolView);
        }];
        
        button;
    });
    
    _shareView = ({
        UIView *view = [UIView new];
        [_toolView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@150);
            make.top.bottom.equalTo(_toolView);
            _shareViewRightConstraint = make.right.equalTo(_toolView).offset(150);
        }];
        
        view;
    });
    
    _scoreShareButton = ({
        UIButton *button = [MLBUIFactory buttonWithTitle:@"成绩单分享" titleColor:[UIColor colorWithWhite:170 / 255.0 alpha:1] fontSize:12 target:self action:@selector(scoreShare)];
        [_shareView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@80);
            make.top.left.bottom.equalTo(_shareView);
        }];
        
        button;
    });
    
    _otherShareButton = ({
        UIButton *button = [MLBUIFactory buttonWithTitle:@"其他分享" titleColor:[UIColor colorWithWhite:170 / 255.0 alpha:1] fontSize:12 target:self action:@selector(otherShare)];
        [_shareView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_scoreShareButton.mas_right);
            make.top.right.bottom.equalTo(_shareView);
        }];
        
        button;
    });
    
    _moreButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"more_normal" highlightImageName:@"more_highlighted" target:self action:@selector(moreButtonClicked)];
        [_toolView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            _moreButtonWidthConstraint = make.width.equalTo(@48);
            make.right.equalTo(_shareView.mas_left);
            make.top.bottom.equalTo(_toolView);
        }];
        
        button;
    });
    
    _gradeButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"not_score_normal" selectedImageName:@"not_score_highlighted" target:self action:@selector(gradeButtonClicked)];
        [button setTitle:@"评分" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:170 / 255.0 alpha:1] forState:UIControlStateNormal];
        button.titleLabel.font = FontWithSize(12);
        [_toolView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@105);
            make.top.bottom.equalTo(_toolView);
            make.right.equalTo(_moreButton.mas_left);
        }];
        
        button;
    });
    
    __weak typeof(self) weakSelf = self;
    _storyListViewController = [[MLBCommentListViewController alloc] initWithCommentListType:MLBCommentListTypeMovieStories headerViewType:MLBHeaderViewTypeMovieStory footerViewType:MLBFooterViewTypeMovieStory];
    _storyListViewController.finishedCalculateHeight = ^(CGFloat height) {
        weakSelf.storiesTableViewHeightConstraint.equalTo(@(height));
    };
    [_contentView addSubview:_storyListViewController.tableView];
    [_storyListViewController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_toolView.mas_bottom);
        make.left.right.equalTo(_contentView);
        _storiesTableViewHeightConstraint = make.height.equalTo(@0);
    }];
    
    _reviewListViewController = [[MLBCommentListViewController alloc] initWithCommentListType:MLBCommentListTypeMovieReviews headerViewType:MLBHeaderViewTypeMovieReview footerViewType:MLBFooterViewTypeMovieReview];
    _reviewListViewController.finishedCalculateHeight = ^(CGFloat height) {
        weakSelf.reviewsTableViewHeightConstraint.equalTo(@(height));
    };
    [_contentView addSubview:_reviewListViewController.tableView];
    [_reviewListViewController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_storyListViewController.tableView.mas_bottom).offset(12);
        make.left.right.equalTo(_contentView);
        _reviewsTableViewHeightConstraint = make.height.equalTo(@0);
    }];
    
    _commentListViewController = [[MLBCommentListViewController alloc] initWithCommentListType:MLBCommentListTypeMovieComments headerViewType:MLBHeaderViewTypeMovieComment footerViewType:MLBFooterViewTypeComment];
    _commentListViewController.finishedCalculateHeight = ^(CGFloat height) {
        weakSelf.commentsTableViewHeightConstraint.equalTo(@(height));
    };
    [_contentView addSubview:_commentListViewController.tableView];
    [_commentListViewController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_reviewListViewController.tableView.mas_bottom).offset(12);
        make.left.right.equalTo(_contentView);
        _commentsTableViewHeightConstraint = make.height.equalTo(@0);
    }];
    
    _infoView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@180);
            make.top.equalTo(_commentListViewController.tableView.mas_bottom).offset(12);
            make.left.right.equalTo(_contentView);
        }];
        
        view;
    });
    
    _castButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"actor_normal" selectedImageName:@"actor_selected" target:self action:@selector(infoButtonClicked:)];
        button.backgroundColor = [UIColor whiteColor];
        button.tag = MLBMovieDetailsTypeCast;
        [_infoView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.sizeOffset(CGSizeMake(44, 44));
            make.right.equalTo(_infoView);
            make.top.equalTo(_infoView).offset(4);
        }];
        
        button;
    });
    
    _stillsButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"still_normal" selectedImageName:@"still_selected" target:self action:@selector(infoButtonClicked:)];
        button.backgroundColor = [UIColor whiteColor];
        button.tag = MLBMovieDetailsTypeStills;
        [_infoView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(_castButton);
            make.right.equalTo(_castButton.mas_left).offset(-20);
            make.bottom.equalTo(_castButton);
        }];
        
        button;
    });
    
    _movieTableButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"plot_normal" selectedImageName:@"plot_selected" target:self action:@selector(infoButtonClicked:)];
        button.backgroundColor = [UIColor whiteColor];
        button.tag = MLBMovieDetailsTypeTable;
        [_infoView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(_castButton);
            make.right.equalTo(_stillsButton.mas_left).offset(-20);
            make.bottom.equalTo(_castButton);
        }];
        
        button;
    });
    
    infoButtons = @[_movieTableButton, _stillsButton, _castButton];
    
    _infoTypeLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor colorWithWhite:127 / 255.0 alpha:1];// #7F7F7F
        label.font = FontWithSize(12);
        [_infoView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_movieTableButton);
            make.left.equalTo(_infoView).offset(12);
        }];
        
        label;
    });
    
    UIView *infoContainer = [UIView new];
    infoContainer.backgroundColor = [UIColor whiteColor];
    [_infoView addSubview:infoContainer];
    [infoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_movieTableButton.mas_bottom).offset(2);
        make.left.bottom.right.equalTo(_infoView);
    }];
    
    UIImageView *infoBGView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gross_border"]];
        imageView.backgroundColor = [UIColor whiteColor];
        [infoContainer addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(infoContainer);
        }];
        
        imageView;
    });
    
    _grossView = ({
        MLBTicketsGrossView *view = [MLBTicketsGrossView new];
        [infoBGView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(infoBGView).insets(UIEdgeInsetsMake(6, 6, 6, 6));
        }];
        
        view;
    });
    
    _moviePosterView = ({
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(130, 130);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 2;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.scrollsToTop = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:[MLBMoviePosterCCell class] forCellWithReuseIdentifier:kMLBMoviePosterCCellID];
        [infoContainer addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(infoContainer);
        }];
        
        collectionView;
    });
    
    _castTextView = ({
        UITextView *textView = [UITextView new];
        textView.backgroundColor = [UIColor whiteColor];
        textView.scrollsToTop = NO;
        textView.selectable = NO;
        textView.editable = NO;
        textView.font = FontWithSize(12);
        [infoContainer addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(infoContainer);
        }];
        
        textView;
    });
    
    _scoreHeaderView = ({
        MLBCommonHeaderView *headerView = [[MLBCommonHeaderView alloc] initWithHeaderViewType:MLBHeaderViewTypeScoreRatio];
        [_contentView addSubview:headerView];
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@([MLBCommonHeaderView headerViewHeight]));
            make.top.equalTo(_infoView.mas_bottom).offset(12);
            make.left.right.equalTo(_contentView);
        }];
        
        headerView;
    });
    
    _scoreRatioLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor colorWithWhite:127 / 255.0 alpha:1];// #F7F7F7
        label.font = FontWithSize(14);
        label.numberOfLines = 0;
        [_contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_scoreHeaderView.mas_bottom).offset(8);
            make.left.bottom.right.equalTo(_contentView).insets(UIEdgeInsetsMake(0, 12, 8, 12));
        }];
        
        label;
    });
}

- (void)prepareForDisplay {
    _storiesTableViewHeightConstraint.equalTo(tableViewInitHeight);
    _reviewsTableViewHeightConstraint.equalTo(tableViewInitHeight);
    _commentsTableViewHeightConstraint.equalTo(tableViewInitHeight);
    [self switchInfoWithType:MLBMovieDetailsTypeTable];
}

- (void)updateViews {
    [_headerView configureViewWithMovieDetails:movieDetails];
    
    [_grossView configureViewWithKeywords:[movieDetails.keywords componentsSeparatedByString:@";"]];
    _castTextView.text = movieDetails.info;
    
    _scoreHeaderView.hidden = IsStringEmpty(movieDetails.score);
    _scoreRatioLabel.text = movieDetails.review;
    
    [_storyListViewController configureViewForMovieDetailsWithItemId:_movieListItem.movieId];
    [self addChildViewController:_storyListViewController];
    [_storyListViewController requestDatas];
    
    [_reviewListViewController configureViewForMovieDetailsWithItemId:_movieListItem.movieId];
    [self addChildViewController:_reviewListViewController];
    [_reviewListViewController requestDatas];
    
    [_commentListViewController configureViewForMovieDetailsWithItemId:_movieListItem.movieId];
    [self addChildViewController:_commentListViewController];
    [_commentListViewController requestDatas];
}

- (void)switchInfoWithType:(MLBMovieDetailsType)type {
    for (UIButton *button in infoButtons) {
        button.selected = button.tag == type;
    }
    
    _grossView.hidden = !_movieTableButton.isSelected;
    _moviePosterView.hidden = !_stillsButton.isSelected;
    _castTextView.hidden = !_castButton.isSelected;
    
    switch (type) {
        case MLBMovieDetailsTypeNone: {
            _infoTypeLabel.text = @"";
            break;
        }
        case MLBMovieDetailsTypeTable: {
            _infoTypeLabel.text = @"一个·电影表";
            
            break;
        }
        case MLBMovieDetailsTypeStills: {
            _infoTypeLabel.text = @"剧照";
            if (!posters || posters.count != movieDetails.photos.count) {
                [self configurePhotos];
            }
            [_moviePosterView reloadData];
            break;
        }
        case MLBMovieDetailsTypeCast: {
            _infoTypeLabel.text = @"演职人员";
            break;
        }
    }
}

- (void)configurePhotos {
    posters = @[].mutableCopy;
    
    for (NSString *url in movieDetails.photos) {
        MLBMoviePoster *poster = [[MLBMoviePoster alloc] init];
        poster.imageData = [NSData dataWithContentsOfURL:[url mlb_encodedURL]];
        [posters addObject:poster];
    }
}

#pragma mark - Action

- (void)ticketButtonClicked {
    
}

- (void)gradeButtonClicked {
    
}

- (void)moreButtonClicked {
    _moreButtonWidthConstraint.equalTo(@0);
    _shareViewRightConstraint.equalTo(@0);
    [_toolView setNeedsUpdateConstraints];
    [_toolView updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_toolView layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)scoreShare {
    
}

- (void)otherShare {
    [self showPopMenuViewWithMenuSelectedBlock:^(MLBPopMenuType menuType) {
        DDLogDebug(@"menuType = %ld", menuType);
    }];
}

- (void)infoButtonClicked:(UIButton *)sender {
    if (!sender.selected) {
        [self switchInfoWithType:(MLBMovieDetailsType)sender.tag];
    }
}

#pragma mark - Network Request

- (void)requestMovieDetails {
    [MLBHTTPRequester requestMovieDetailsById:_movieListItem.movieId success:^(id responseObject) {
        if ([responseObject[@"res"] integerValue] == 0) {
            NSError *error;
            MLBMovieDetails *details = [MTLJSONAdapter modelOfClass:[MLBMovieDetails class] fromJSONDictionary:responseObject[@"data"] error:&error];
            if (!error) {
                movieDetails = details;
                [self updateViews];
            } else {
                [self modelTransformFailedWithError:error];
            }
        } else {
            [self showHUDErrorWithText:responseObject[@"msg"]];
        }
    } fail:^(NSError *error) {
        [self showHUDServerError];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return movieDetails.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:kMLBMoviePosterCCellID forIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(MLBMoviePosterCCell *)cell configureCellWithPostURL:movieDetails.photos[indexPath.row]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:posters initialPhoto:posters[indexPath.row]];
    [self presentViewController:photosViewController animated:NO completion:NULL];
}

@end
