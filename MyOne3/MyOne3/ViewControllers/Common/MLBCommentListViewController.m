//
//  MLBCommentListViewController.m
//  MyOne3
//
//  Created by meilbn on 3/6/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBCommentListViewController.h"
#import "MLBCommentCell.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "MLBCommentList.h"
#import "MLBMovieStoryList.h"
#import "MLBMovieReviewList.h"
#import "MLBNoneMessageCell.h"
#import <MJRefresh/MJRefresh.h>

@interface MLBCommentListViewController () {
    NSString *_itemId;
    
    MLBReadType _readType;
}

@property (strong, nonatomic) MLBCommonHeaderView *headerView;
@property (strong, nonatomic) MLBCommonFooterView *footerView;

@property (assign, nonatomic) MLBCommentListType commentListType;
@property (assign, nonatomic) MLBHeaderViewType headerViewType;
@property (assign, nonatomic) MLBFooterViewType footerViewType;

@property (strong, nonatomic) NSMutableArray *rowHeights;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (assign, nonatomic) NSInteger dataCount;

@end

@implementation MLBCommentListViewController

#pragma mark - Lifecycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DDLogDebug(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _headerViewType = MLBHeaderViewTypeNone;
        _footerViewType = MLBFooterViewTypeNone;
    }
    
    return self;
}

- (instancetype)initWithCommentListType:(MLBCommentListType)commentListType {
    return [self initWithCommentListType:commentListType headerViewType:MLBHeaderViewTypeNone footerViewType:MLBFooterViewTypeNone];
}

- (instancetype)initWithCommentListType:(MLBCommentListType)commentListType headerViewType:(MLBHeaderViewType)headerViewType footerViewType:(MLBFooterViewType)footerViewType {
    self = [super init];
    
    if (self) {
        _commentListType = commentListType;
        _headerViewType = headerViewType;
        _footerViewType = footerViewType;
    }
    
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initDatas];
    [self setupViews];
    
    if ([self isCommentListNotInDetails]) {
        switch (_commentListType) {
            case MLBCommentListTypeReadComments:
            case MLBCommentListTypeMusicComments:
            case MLBCommentListTypeMovieComments: {
                self.title = @"评论列表";
                break;
            }
            case MLBCommentListTypeMovieStories: {
                self.title = @"电影故事";
                break;
            }
            case MLBCommentListTypeMovieReviews: {
                self.title = @"评审团短评";
                break;
            }
            default:
                break;
        }
        
        [MLBUIFactory myOne_addMJRefreshTo:self.tableView target:self refreshAction:@selector(refresh) loadMoreAction:@selector(loadMore)];
        
        [self requestDatas];
    }
}

#pragma mark - Private Method

- (void)initDatas {
    _rowHeights = @[].mutableCopy;
    _dataSource = @[].mutableCopy;
}

- (void)setupViews {
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
    self.tableView.separatorColor = MLBSeparatorColor;
    [self.tableView registerClass:[MLBCommentCell class] forCellReuseIdentifier:kMLBCommentCellID];
    [self.tableView registerClass:[MLBNoneMessageCell class] forCellReuseIdentifier:kMLBNoneMessageCellID];
    self.tableView.tableFooterView = [UIView new];
    
    if (![self isCommentListNotInDetails]) {
        __weak typeof(self) weakSelf = self;
        
        _headerView = [[MLBCommonHeaderView alloc] initWithHeaderViewType:_headerViewType];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MLBCommonHeaderView headerViewHeight]);
        _footerView = [[MLBCommonFooterView alloc] initWithFooterViewType:_footerViewType];
        _footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [MLBCommonFooterView footerViewHeight]);
        _footerView.showAllItems = ^() {
            [weakSelf showAllItems];
        };
        self.tableView.tableHeaderView = _headerView;
        self.tableView.tableFooterView = _footerView;
        
        self.tableView.scrollsToTop = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
    } else {
        self.tableView.scrollsToTop = YES;
        self.tableView.showsVerticalScrollIndicator = YES;
    }
}

- (void)configureCell:(MLBCommentCell *)cell withModel:(id)model atIndexPath:(NSIndexPath *)indexPath {
    switch (_commentListType) {
        case MLBCommentListTypeReadComments:
        case MLBCommentListTypeMusicComments:
        case MLBCommentListTypeMovieComments: {
            [cell configureCellForCommonWithComment:(MLBComment *)model atIndexPath:indexPath];
            break;
        }
        case MLBCommentListTypeMovieStories: {
            [cell configureCellForMovieWithStory:(MLBMovieStory *)model atIndexPath:indexPath];
            break;
        }
        case MLBCommentListTypeMovieReviews: {
            [cell configureCellForMovieWithReview:(MLBMovieReview *)model atIndexPath:indexPath];
            break;
        }
        default:
            break;
    }
}

- (BOOL)isCommentListNotInDetails {
    return (_headerViewType == MLBHeaderViewTypeNone && _footerViewType == MLBFooterViewTypeNone);
}

- (void)calculateHeight {
    CGFloat tableViewHeight = 0;
    
    if (_dataSource.count > 0) {
        [_rowHeights removeAllObjects];
        
        for (id model in _dataSource) {
            CGFloat cellHeight = [self.tableView fd_heightForCellWithIdentifier:kMLBCommentCellID configuration:^(MLBCommentCell *cell) {
                [self configureCell:cell withModel:model atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            }];
            [_rowHeights addObject:@(ceil(cellHeight))];
            tableViewHeight += ceil(cellHeight);
        }
    } else {
        tableViewHeight += [MLBNoneMessageCell cellHeight];
    }
    
    if (_headerViewType != MLBHeaderViewTypeNone) {
        tableViewHeight += [MLBCommonHeaderView headerViewHeight];
    }
    
    if (_footerViewType != MLBFooterViewTypeNone) {
        tableViewHeight += _footerViewType != MLBFooterViewTypeShadow ? [MLBCommonFooterView footerViewHeight] : [MLBCommonFooterView footerViewHeightForShadow];
    }
    
    if (_finishedCalculateHeight && self.parentViewController) {
        _finishedCalculateHeight(tableViewHeight);
    }
}

- (NSString *)lastItemIdInDataSource {
    if (_dataSource.count > 0) {
        switch (_commentListType) {
            case MLBCommentListTypeReadComments:
            case MLBCommentListTypeMusicComments:
            case MLBCommentListTypeMovieComments: {
                return ((MLBComment *)[_dataSource lastObject]).commentId;
            }
            case MLBCommentListTypeMovieStories: {
                return ((MLBMovieStory *)[_dataSource lastObject]).storyId;
            }
            case MLBCommentListTypeMovieReviews: {
                return ((MLBMovieReview *)[_dataSource lastObject]).reviewId;
            }
            default:
                return @"0";
        }
    } else {
        return @"0";
    }
}

- (void)updateViews {
    if (![self isCommentListNotInDetails]) {
        [self calculateHeight];
        [_footerView configureViewWithCount:_dataCount];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Public Method

- (void)configureViewForReadDetailsWithReadType:(MLBReadType)readType itemId:(NSString *)itemId {
    _itemId = itemId;
    _readType = readType;
}

- (void)configureViewForMusicDetailsWithItemId:(NSString *)itemId {
    _itemId = itemId;
}

- (void)configureViewForMovieDetailsWithItemId:(NSString *)itemId {
    _itemId = itemId;
}

- (void)requestDatas {
    [self reuqestDatasWithFirstItemId:@"0"];
}

- (void)reuqestDatasWithFirstItemId:(NSString *)firstItemId {
    switch (_commentListType) {
        case MLBCommentListTypeReadComments:
        case MLBCommentListTypeMusicComments:
        case MLBCommentListTypeMovieComments: {
            [self requestCommentWithFirstItemId:firstItemId];
            break;
        }
        case MLBCommentListTypeMovieStories: {
            [self requestMovieStoriesWithFirstItemId:firstItemId];
            break;
        }
        case MLBCommentListTypeMovieReviews: {
            [self requestMovieReviewsWithFirstItemId:firstItemId];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Action

- (void)refresh {
    [self requestDatas];
}

- (void)loadMore {
    [self reuqestDatasWithFirstItemId:[self lastItemIdInDataSource]];
}

- (void)endRefreshingWithHasMoreData:(BOOL)hasMoreData {
    if (self.tableView.mj_header && self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
    }
    
    if (hasMoreData) {
        [self.tableView.mj_footer endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)showAllItems {
    MLBCommentListViewController *commentListViewController = [[MLBCommentListViewController alloc] initWithCommentListType:_commentListType headerViewType:MLBHeaderViewTypeNone footerViewType:MLBFooterViewTypeNone];
    switch (_commentListType) {
        case MLBCommentListTypeNone: {
            break;
        }
        case MLBCommentListTypeReadComments: {
            [commentListViewController configureViewForReadDetailsWithReadType:_readType itemId:_itemId];
            break;
        }
        case MLBCommentListTypeMusicComments: {
            [commentListViewController configureViewForMusicDetailsWithItemId:_itemId];
            break;
        }
        case MLBCommentListTypeMovieStories:
        case MLBCommentListTypeMovieReviews:
        case MLBCommentListTypeMovieComments: {
            [commentListViewController configureViewForMovieDetailsWithItemId:_itemId];
            break;
        }
    }
    
    [self.navigationController pushViewController:commentListViewController animated:YES];
}

#pragma mark - Network Request

- (void)requestCommentWithFirstItemId:(NSString *)firstItemId {
    NSString *apiString;
    if (_commentListType == MLBCommentListTypeReadComments) {
        apiString = [MLBHTTPRequester apiStringForReadWithReadType:_readType];
    } else if (_commentListType == MLBCommentListTypeMusicComments) {
        apiString = [MLBHTTPRequester apiStringForMusic];
    } else if (_commentListType == MLBCommentListTypeMovieComments) {
        apiString = [MLBHTTPRequester apiStringForMovie];
    }
    
    if (IsStringEmpty(apiString)) {
        return;
    }
    
    if ([self isCommentListNotInDetails]) {
        [MLBHTTPRequester requestTimeCommentsWithType:apiString itemId:_itemId firstItemId:firstItemId success:^(id responseObject) {
            [self processCommentsResponseObject:responseObject firstItemId:firstItemId];
        } fail:^(NSError *error) {
            
        }];
    } else {
        [MLBHTTPRequester requestPraiseCommentsWithType:apiString itemId:_itemId firstItemId:firstItemId success:^(id responseObject) {
            [self processCommentsResponseObject:responseObject firstItemId:firstItemId];
        } fail:^(NSError *error) {
            
        }];
    }
}

- (void)processCommentsResponseObject:(id)responseObject firstItemId:(NSString *)firstItemId {
    if ([responseObject[@"res"] integerValue] == 0) {
        NSError *error;
        MLBCommentList *commentList = [MTLJSONAdapter modelOfClass:[MLBCommentList class] fromJSONDictionary:responseObject[@"data"] error:&error];
        if (!error) {
            _dataCount = commentList.count;
            if ([firstItemId isEqualToString:@"0"]) {
                [_dataSource removeAllObjects];
            }
            
            [_dataSource addObjectsFromArray:commentList.comments];
            
            if ([self isCommentListNotInDetails]) {
                [self endRefreshingWithHasMoreData:commentList.comments.count >= 20];
            }
            
            [self updateViews];
        } else {
            // callback
        }
    } else {
        // callback
    }
}

- (void)requestMovieStoriesWithFirstItemId:(NSString *)firstItemId {
    [MLBHTTPRequester requestMovieStoriesById:_itemId firstItemId:firstItemId forDetails:![self isCommentListNotInDetails] success:^(id responseObject) {
        if ([responseObject[@"res"] integerValue] == 0) {
            NSError *error;
            MLBMovieStoryList *storyList = [MTLJSONAdapter modelOfClass:[MLBMovieStoryList class] fromJSONDictionary:responseObject[@"data"] error:&error];
            if (!error) {
                _dataCount = storyList.count;
                if ([firstItemId isEqualToString:@"0"]) {
                    [_dataSource removeAllObjects];
                }
                
                [_dataSource addObjectsFromArray:storyList.stories];
                
                if ([self isCommentListNotInDetails]) {
                    [self endRefreshingWithHasMoreData:storyList.stories.count >= 10];
                }
                
                [self updateViews];
            } else {
                
            }
        } else {
            
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)requestMovieReviewsWithFirstItemId:(NSString *)firstItemId {
    [MLBHTTPRequester requestMovieReviewsById:_itemId firstItemId:firstItemId forDetails:![self isCommentListNotInDetails] success:^(id responseObject) {
        if ([responseObject[@"res"] integerValue] == 0) {
            NSError *error;
            MLBMovieReviewList *reviewList = [MTLJSONAdapter modelOfClass:[MLBMovieReviewList class] fromJSONDictionary:responseObject[@"data"] error:&error];
            if (!error) {
                _dataCount = reviewList.count;
                if ([firstItemId isEqualToString:@"0"]) {
                    [_dataSource removeAllObjects];
                }
                
                [_dataSource addObjectsFromArray:reviewList.reviews];
                
                if ([self isCommentListNotInDetails]) {
                    [self endRefreshingWithHasMoreData:reviewList.reviews.count >= 20];
                }
                
                [self updateViews];
            } else {
                
            }
        } else {
            
        }
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count == 0 ? 1 : _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataSource.count == 0) {
        return [tableView dequeueReusableCellWithIdentifier:kMLBNoneMessageCellID];
    }
    
    return [tableView dequeueReusableCellWithIdentifier:kMLBCommentCellID forIndexPath:indexPath];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataSource.count == 0) {
        return [MLBNoneMessageCell cellHeight];
    }
    
    if ([self isCommentListNotInDetails]) {
        return [tableView fd_heightForCellWithIdentifier:kMLBCommentCellID cacheByIndexPath:indexPath configuration:^(MLBCommentCell *cell) {
            [self configureCell:cell withModel:_dataSource[indexPath.row] atIndexPath:indexPath];
        }];
    } else {
        return [_rowHeights[indexPath.row] floatValue];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataSource.count == 0) {
        return;
    }
    
    [self configureCell:(MLBCommentCell *)cell withModel:_dataSource[indexPath.row] atIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
