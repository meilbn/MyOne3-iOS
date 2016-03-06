//
//  MLBMovieDetailsViewController.m
//  MyOne3
//
//  Created by meilbn on 2/28/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBMovieDetailsViewController.h"
#import "MLBMovieDetailsHeaderView.h"
#import "MLBCommentCell.h"
#import "MLBNoneMessageCell.h"
#import "MLBMovieListItem.h"
#import "MLBMovieDetails.h"
#import "MLBMovieStoryList.h"
#import "MLBMovieReviewList.h"
#import "MLBCommentList.h"
//#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "MLBCommentListViewController.h"

typedef NS_ENUM(NSUInteger, MLBMovieDetailsType) {
    MLBMovieDetailsTypeNone,
    MLBMovieDetailsTypeTable,
    MLBMovieDetailsTypeStills,
    MLBMovieDetailsTypeCast,
};

@interface MLBMovieDetailsViewController () <UIScrollViewDelegate>// <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) MLBMovieDetailsHeaderView *headerView;
@property (strong, nonatomic) UIView *toolView;
@property (strong, nonatomic) UIButton *ticketButton;
//@property (strong, nonatomic) UILabel *ticketLabel;
@property (strong, nonatomic) UIButton *gradeButton;
@property (strong, nonatomic) UIButton *moreButton;
@property (strong, nonatomic) UIView *shareView;
@property (strong, nonatomic) UIButton *scoreShareButton;
@property (strong, nonatomic) UIButton *otherShareButton;
//@property (strong, nonatomic) UITableView *storiesTableView;
//@property (strong, nonatomic) MLBCommonHeaderView *storiesHeaderView;
//@property (strong, nonatomic) MLBCommonFooterView *storiesFooterView;
@property (strong, nonatomic) MLBCommentListViewController *storyListViewController;
//@property (strong, nonatomic) UITableView *reviewsTableView;
//@property (strong, nonatomic) MLBCommonHeaderView *reviewsHeaderView;
//@property (strong, nonatomic) MLBCommonFooterView *reviewsFooterView;
@property (strong, nonatomic) MLBCommentListViewController *reviewListViewController;
//@property (strong, nonatomic) UITableView *commentsTableView;
//@property (strong, nonatomic) MLBCommonHeaderView *commentsHeaderView;
//@property (strong, nonatomic) MLBCommonFooterView *commentsFooterView;
@property (strong, nonatomic) MLBCommentListViewController *commentListViewController;
@property (strong, nonatomic) UIView *infoView;
@property (strong, nonatomic) UILabel *infoTypeLabel;
@property (strong, nonatomic) UIButton *movieTableButton;
@property (strong, nonatomic) UIButton *stillsButton;
@property (strong, nonatomic) UIButton *castButton;
@property (strong, nonatomic) MLBCommonHeaderView *scoreHeaderView;
@property (strong, nonatomic) UILabel *scoreRatioLabel;

@property (strong, nonatomic) MASConstraint *shareViewRightConstraint;
@property (strong, nonatomic) MASConstraint *storiesTableViewHeightConstraint;
@property (strong, nonatomic) MASConstraint *reviewsTableViewHeightConstraint;
@property (strong, nonatomic) MASConstraint *commentsTableViewHeightConstraint;

@end

@implementation MLBMovieDetailsViewController {
    NSNumber *tableViewInitHeight;
    MLBMovieDetails *movieDetials;
//    MLBMovieStoryList *storyList;
//    NSMutableArray *storyRowsHeight;
//    MLBMovieReviewList *reviewList;
//    NSMutableArray *reviewRowsHeight;
//    MLBCommentList *commentList;
//    NSMutableArray *commentRowsHeight;
    NSArray *infoButtons;
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
    self.title = _movieListItem.title;
    
    [self initDatas];
    [self setupViews];
    [self prepareForDisplay];
    [self requestMovieDetails];
}

#pragma mark - Private Method

- (void)initDatas {
    tableViewInitHeight = @([MLBCommonHeaderView headerViewHeight] + [MLBCommonFooterView footerViewHeight] + 1);
//    storyRowsHeight = @[].mutableCopy;
//    reviewRowsHeight = @[].mutableCopy;
//    commentRowsHeight = @[].mutableCopy;
}

- (void)setupViews {
    if (_scrollView) {
        return;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollView = ({
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.backgroundColor = self.view.backgroundColor;
        scrollView.showsVerticalScrollIndicator = NO;
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
            make.width.equalTo(button.mas_height).multipliedBy(1);
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
    
//    _storiesTableView = ({
//        UITableView *tableView = [self tableView];
//        
//        _storiesHeaderView = [[MLBCommonHeaderView alloc] initWithHeaderViewType:MLBHeaderViewTypeMovieStory];
//        _storiesHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MLBCommonHeaderView headerViewHeight]);
//        tableView.tableHeaderView = _storiesHeaderView;
//        _storiesFooterView = [[MLBCommonFooterView alloc] initWithFooterViewType:MLBFooterViewTypeMovieStory];
//        _storiesFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MLBCommonFooterView footerViewHeight]);
//        tableView.tableFooterView = _storiesFooterView;
//        
//        [_contentView addSubview:tableView];
//        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_toolView.mas_bottom);
//            make.left.right.equalTo(_contentView);
//            _storiesTableViewHeightConstraint = make.height.equalTo(@0);
//        }];
//        
//        tableView;
//    });
    
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
    
//    _reviewsTableView = ({
//        UITableView *tableView = [self tableView];
//        
//        _reviewsHeaderView = [[MLBCommonHeaderView alloc] initWithHeaderViewType:MLBHeaderViewTypeMovieReview];
//        _reviewsHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MLBCommonHeaderView headerViewHeight]);
//        tableView.tableHeaderView = _reviewsHeaderView;
//        _reviewsFooterView = [[MLBCommonFooterView alloc] initWithFooterViewType:MLBFooterViewTypeMovieReview];
//        _reviewsFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MLBCommonFooterView footerViewHeight]);
//        tableView.tableFooterView = _reviewsFooterView;
//        
//        [_contentView addSubview:tableView];
//        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_storiesTableView.mas_bottom).offset(12);
//            make.left.right.equalTo(_contentView);
//            _reviewsTableViewHeightConstraint = make.height.equalTo(@0);
//        }];
//        
//        tableView;
//    });
    
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
    
//    _commentsTableView = ({
//        UITableView *tableView = [self tableView];
//        
//        _commentsHeaderView = [[MLBCommonHeaderView alloc] initWithHeaderViewType:MLBHeaderViewTypeMovieComment];
//        _commentsHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MLBCommonHeaderView headerViewHeight]);
//        tableView.tableHeaderView = _commentsHeaderView;
//        _commentsFooterView = [[MLBCommonFooterView alloc] initWithFooterViewType:MLBFooterViewTypeComment];
//        _commentsFooterView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MLBCommonFooterView footerViewHeight]);
//        tableView.tableFooterView = _commentsFooterView;
//        
//        [_contentView addSubview:tableView];
//        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_reviewsTableView.mas_bottom).offset(12);
//            make.left.right.equalTo(_contentView);
//            _commentsTableViewHeightConstraint = make.height.equalTo(@0);
//        }];
//        
//        tableView;
//    });
    
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
        label.textColor = [UIColor colorWithWhite:127 / 255.0 alpha:1];// #7F7F7F
        label.font = FontWithSize(12);
        [_infoView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_movieTableButton);
            make.left.equalTo(_infoView).offset(12);
        }];
        
        label;
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

//- (UITableView *)tableView {
//    UITableView *tableView = [UITableView new];
//    tableView.backgroundColor = [UIColor whiteColor];
//    tableView.dataSource = self;
//    tableView.delegate = self;
//    tableView.separatorColor = MLBSeparatorColor;
//    tableView.showsVerticalScrollIndicator = NO;
//    tableView.showsHorizontalScrollIndicator = NO;
//    tableView.scrollsToTop = NO;
//    tableView.scrollEnabled = NO;
//    [tableView registerClass:[MLBCommentCell class] forCellReuseIdentifier:kMLBCommentCellID];
//    [tableView registerClass:[MLBNoneMessageCell class] forCellReuseIdentifier:kMLBNoneMessageCellID];
//    
//    return tableView;
//}

- (void)prepareForDisplay {
    _storiesTableViewHeightConstraint.equalTo(tableViewInitHeight);
    _reviewsTableViewHeightConstraint.equalTo(tableViewInitHeight);
    _commentsTableViewHeightConstraint.equalTo(tableViewInitHeight);
    [self switchInfoWithType:MLBMovieDetailsTypeTable];
}

- (void)updateViews {
    [_headerView configureViewWithMovieDetails:movieDetials];
    
    _scoreRatioLabel.text = movieDetials.review;
    
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

//- (void)updateStoriesTableView {
//    CGFloat tableViewHeight = tableViewInitHeight.integerValue;
//    if (storyList.stories.count > 0) {
//        [storyRowsHeight removeAllObjects];
//        for (MLBMovieStory*story in storyList.stories) {
//            CGFloat cellHeight = [_storiesTableView fd_heightForCellWithIdentifier:kMLBCommentCellID configuration:^(MLBCommentCell *cell) {
//                [cell configureCellForMovieWithStory:story atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            }];
//            [storyRowsHeight addObject:@(ceil(cellHeight))];
//            tableViewHeight += ceil(cellHeight);
//        }
//    } else {
//        tableViewHeight += [MLBNoneMessageCell cellHeight];// add none message cell height
//    }
//    
//    _storiesTableViewHeightConstraint.equalTo(@(ceil(tableViewHeight)));
//    [_storiesTableView reloadData];
//}
//
//- (void)updateReviewsTableView {
//    CGFloat tableViewHeight = tableViewInitHeight.integerValue;
//    if (reviewList.reviews.count > 0) {
//        [reviewRowsHeight removeAllObjects];
//        for (MLBMovieReview *review in reviewList.reviews) {
//            CGFloat cellHeight = [_reviewsTableView fd_heightForCellWithIdentifier:kMLBCommentCellID configuration:^(MLBCommentCell *cell) {
//                [cell configureCellForMovieWithReview:review atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            }];
//            [reviewRowsHeight addObject:@(ceil(cellHeight))];
//            tableViewHeight += ceil(cellHeight);
//        }
//    } else {
//        tableViewHeight += [MLBNoneMessageCell cellHeight];// add none message cell height
//    }
//    
//    _reviewsTableViewHeightConstraint.equalTo(@(ceil(tableViewHeight)));
//    [_reviewsTableView reloadData];
//}
//
//- (void)updateCommentsTableView {
//    CGFloat tableViewHeight = tableViewInitHeight.integerValue;
//    if (commentList.comments.count > 0) {
//        [commentRowsHeight removeAllObjects];
//        for (MLBComment *comment in commentList.comments) {
//            CGFloat cellHeight = [_commentsTableView fd_heightForCellWithIdentifier:kMLBCommentCellID configuration:^(MLBCommentCell *cell) {
//                [cell configureCellForCommonWithComment:comment atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            }];
//            [commentRowsHeight addObject:@(ceil(cellHeight))];
//            tableViewHeight += ceil(cellHeight);
//        }
//    } else {
//        tableViewHeight += [MLBNoneMessageCell cellHeight];// add none message cell height
//    }
//    
//    _commentsTableViewHeightConstraint.equalTo(@(ceil(tableViewHeight)));
//    [_commentsTableView reloadData];
//}

- (void)switchInfoWithType:(MLBMovieDetailsType)type {
    for (UIButton *button in infoButtons) {
        button.selected = button.tag == type;
    }
    
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
            break;
        }
        case MLBMovieDetailsTypeCast: {
            _infoTypeLabel.text = @"演职人员";
            break;
        }
    }
}

#pragma mark - Action

- (void)ticketButtonClicked {
    
}

- (void)gradeButtonClicked {
    
}

- (void)moreButtonClicked {
    
}

- (void)scoreShare {
    
}

- (void)otherShare {
    
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
                movieDetials = details;
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

//- (void)requestMovieStories {
//    [MLBHTTPRequester requestMovieDetailsMovieStoriesById:_movieListItem.movieId success:^(id responseObject) {
//        if ([responseObject[@"res"] integerValue] == 0) {
//            NSError *error;
//            MLBMovieStoryList *stories = [MTLJSONAdapter modelOfClass:[MLBMovieStoryList class] fromJSONDictionary:responseObject[@"data"] error:&error];
//            if (!error) {
//                storyList = stories;
//                [self updateStoriesTableView];
//            } else {
//                [self modelTransformFailedWithError:error];
//            }
//        } else {
//            [self showHUDErrorWithText:responseObject[@"msg"]];
//        }
//    } fail:^(NSError *error) {
//        [self showHUDServerError];
//    }];
//}
//
//- (void)requestMovieReviews {
//    [MLBHTTPRequester requestMovieDetailsMovieReviewsById:_movieListItem.movieId success:^(id responseObject) {
//        if ([responseObject[@"res"] integerValue] == 0) {
//            NSError *error;
//            MLBMovieReviewList *reviews = [MTLJSONAdapter modelOfClass:[MLBMovieReviewList class] fromJSONDictionary:responseObject[@"data"] error:&error];
//            if (!error) {
//                reviewList = reviews;
//                [self updateReviewsTableView];
//            } else {
//                [self modelTransformFailedWithError:error];
//            }
//        } else {
//            [self showHUDErrorWithText:responseObject[@"msg"]];
//        }
//    } fail:^(NSError *error) {
//        [self showHUDServerError];
//    }];
//}
//
//- (void)requestComments {
//    [MLBHTTPRequester requestMovieDetailsPraiseCommentsById:_movieListItem.movieId success:^(id responseObject) {
//        if ([responseObject[@"res"] integerValue] == 0) {
//            NSError *error;
//            MLBCommentList *comments = [MTLJSONAdapter modelOfClass:[MLBCommentList class] fromJSONDictionary:responseObject[@"data"] error:&error];
//            if (!error) {
//                commentList = comments;
//                [self updateCommentsTableView];
//            } else {
//                [self modelTransformFailedWithError:error];
//            }
//        } else {
//            [self showHUDErrorWithText:responseObject[@"msg"]];
//        }
//    } fail:^(NSError *error) {
//        [self showHUDServerError];
//    }];
//}

//#pragma mark - UITableViewDataSource
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return nil;
//}
//
//#pragma mark UITableViewDelegate
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 0;
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

@end
