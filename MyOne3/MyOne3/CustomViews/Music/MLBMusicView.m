//
//  MLBMusicView.m
//  MyOne3
//
//  Created by meilbn on 2/22/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBMusicView.h"

#import "MLBMusicDetails.h"
#import "MLBCommentList.h"
#import "MLBRelatedMusic.h"

#import "MLBMusicContentCell.h"
#import "MLBRelatedMusicCollectionCell.h"
#import "MLBCommentCell.h"
#import "MLBNoneMessageCell.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "MLBCommonHeaderFooterView.h"

NSString *const kMLBMusicViewID = @"MLBMusicViewID";

@interface MLBMusicView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSString *musicId;
@property (strong, nonatomic) MLBMusicDetails *musicDetails;
@property (strong, nonatomic) MLBCommentList *commentList;
@property (strong, nonatomic) NSArray *relatedMusics;

@property (strong, nonatomic) MLBMusicContentCell *contentCell;
@property (strong, nonatomic) MLBRelatedMusicCollectionCell *collectionCell;

@end

@implementation MLBMusicView {
    NSInteger initStatusContentOffsetY;
}

#pragma mark - LifeCycle

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configure];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self configure];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self configure];
    }
    
    return self;
}

#pragma mark - Private Method

- (void)configure {
    [self initDatas];
    [self setupViews];
}

- (void)initDatas {
    initStatusContentOffsetY = [@(ceil(SCREEN_WIDTH * 0.6)) integerValue];
}

- (void)setupViews {
    if (_tableView) {
        return;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.dataSource = self;
        tableView.delegate = self;
		[tableView registerClass:[MLBCommonHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kMLBCommonHeaderFooterViewIDForTypeHeader];
		[tableView registerClass:[MLBMusicContentCell class] forCellReuseIdentifier:kMLBMusicContentCellID];
		[tableView registerClass:[MLBRelatedMusicCollectionCell class] forCellReuseIdentifier:kMLBRelatedMusicCollectionCellID];
		[tableView registerClass:[MLBNoneMessageCell class] forCellReuseIdentifier:kMLBNoneMessageCellID];
        [tableView registerClass:[MLBCommentCell class] forCellReuseIdentifier:kMLBCommentCellID];
        tableView.tableFooterView = [UIView new];
		tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[tableView mlb_addRefreshingWithTarget:self refreshingAction:nil loadMoreDatasAction:@selector(requestMusicComments)];
        [self addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        tableView;
    });
}

- (BOOL)hasComments {
	return _commentList && (_commentList.hotComments.count > 0 || _commentList.comments.count > 0);
}

- (MLBComment *)commentAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 2 && indexPath.row < _commentList.hotComments.count) { // 热门评论
		return _commentList.hotComments[indexPath.row];
	} else if (indexPath.section == 3 && indexPath.row < _commentList.comments.count) { // 普通评论
		return _commentList.comments[indexPath.row];
	}
	
	return nil;
}

#pragma mark - Action

- (void)commentCellButtonClickedWithType:(MLBCommentCellButtonType)type indexPath:(NSIndexPath *)indexPath {
	switch (type) {
		case MLBCommentCellButtonTypeUserAvatar: {
			break;
		}
		case MLBCommentCellButtonTypePraise: {
			break;
		}
		case MLBCommentCellButtonTypeUnfold: {
			MLBComment *comment = [self commentAtIndexPath:indexPath];
			if (!comment.isUnfolded) {
				comment.unfolded = YES;
				[_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
			}
			break;
		}
	}
}

#pragma mark - Public Method

- (void)prepareForReuse {
	_musicDetails = nil;
	_relatedMusics = nil;
	_commentList = nil;
	[_tableView reloadData];
}

- (void)configureViewWithMusicId:(NSString *)musicId atIndex:(NSInteger)index {
    [self configureViewWithMusicId:musicId atIndex:index inViewController:nil];
}

- (void)configureViewWithMusicId:(NSString *)musicId atIndex:(NSInteger)index inViewController:(MLBBaseViewController *)parentViewController {
    self.viewIndex = index;
    _musicId = musicId;
    self.parentViewController = parentViewController;
	
	self.tableView.contentOffset = (CGPoint){0, initStatusContentOffsetY};
    [self requestMusicDetails];
}

#pragma mark - Network Request

- (void)requestMusicDetails {
    __weak typeof(self) weakSelf = self;
    [MLBHTTPRequester requestMusicDetailsById:_musicId success:^(id responseObject) {
		__strong typeof(weakSelf) strongSelf = weakSelf;
		if (!strongSelf) {
			return;
		}
		
        if ([responseObject[@"res"] integerValue] == 0) {
            NSError *error;
            MLBMusicDetails *details = [MTLJSONAdapter modelOfClass:[MLBMusicDetails class] fromJSONDictionary:responseObject[@"data"] error:&error];
            if (!error) {
				strongSelf.musicDetails = details;
				[strongSelf.tableView reloadData];
				[strongSelf requestMusicRelatedMusics];
				[strongSelf requestMusicComments];
            } else {
                // callback
            }
        } else {
            // callback
        }
    } fail:^(NSError *error) {
        // callback
    }];
}

// 看返回结果应该最多是3首
- (void)requestMusicRelatedMusics {
    __weak typeof(self) weakSelf = self;
    [MLBHTTPRequester requestMusicDetailsRelatedMusicsById:_musicId success:^(id responseObject) {
		__strong typeof(weakSelf) strongSelf = weakSelf;
		if (!strongSelf) {
			return;
		}
		
        if ([responseObject[@"res"] integerValue] == 0) {
            NSError *error;
            NSArray *musics = [MTLJSONAdapter modelsOfClass:[MLBRelatedMusic class] fromJSONArray:responseObject[@"data"] error:&error];
            if (!error) {
                strongSelf.relatedMusics = musics;
				DDLogDebug(@"%@ finished", NSStringFromSelector(_cmd));
				if (strongSelf.musicDetails) {
					[strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
				}
            } else {
                // callback
            }
        } else {
            // callback
        }
    } fail:^(NSError *error) {
        // callback
    }];
}

- (void)requestMusicComments {
	NSString *commentId = @"0";
	if (_commentList && _commentList.comments.count > 0) {
		commentId = ((MLBComment *)[_commentList.comments lastObject]).commentId;
	}
	
	__weak typeof(self) weakSelf = self;
	[MLBHTTPRequester requestMusicPraiseAndTimeCommentsWithItemId:_musicId lastCommentId:commentId success:^(id responseObject) {
		__strong typeof(weakSelf) strongSelf = weakSelf;
		if (!strongSelf) {
			return;
		}
		
		[strongSelf processingForCommentsWithResponseObject:responseObject];
	} fail:^(NSError *error) {
		
	}];
}

#pragma mark - Data Processing

- (void)processingForCommentsWithResponseObject:(id)responseObject {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		if ([responseObject[@"res"] integerValue] == 0) {
			NSError *error;
			MLBCommentList *cmList = [MTLJSONAdapter modelOfClass:[MLBCommentList class] fromJSONDictionary:responseObject[@"data"] error:&error];
			if (!error) {
				if (!self.commentList) {
					self.commentList = [[MLBCommentList alloc] init];
					self.commentList.count = cmList.count;
					self.commentList.comments = @[].mutableCopy;
					self.commentList.hotComments = @[].mutableCopy;
				}
				
				MLBComment *lastHotComment;
				for (MLBComment *comment in cmList.comments) {
					if (comment.commentType == MLBCommentTypeHot) {
						lastHotComment = comment;
						[self.commentList.hotComments addObject:comment];
					} else {
						[self.commentList.comments addObject:comment];
					}
				}
				
				NSMutableArray *indexPaths;
				
				if (lastHotComment) {
					lastHotComment.lastHotComment = YES;
				} else {
					indexPaths = [NSMutableArray arrayWithCapacity:cmList.comments.count];
					for (NSInteger i = (_commentList.comments.count - cmList.comments.count); i < _commentList.comments.count; i++) {
						[indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:3]];
					}
				}
				
				DDLogDebug(@"%@ finished, viewIndex = %ld, tabelView = %p", NSStringFromSelector(_cmd), self.viewIndex, self.tableView);
				
				if (self.musicDetails) {
					dispatch_async(dispatch_get_main_queue(), ^{
						[self.tableView mlb_endRefreshingHasMoreData:(self.commentList.comments.count != self.commentList.count || cmList.comments.count >= 20)];
						
						if (cmList.comments.count > 0) {
//							[self.operationQueue cancelAllOperations];
//							[self.operationQueue addOperationWithBlock:^{
								if (lastHotComment) {
									[self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 2)] withRowAnimation:UITableViewRowAnimationNone];
								} else {
									if (indexPaths && indexPaths.count > 0) {
										[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
									}
								}
//							}];
						}
					});
				}
			}
		}
	});
}

#pragma mark - UIScrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGPoint contentOffset = scrollView.contentOffset;
//    if (contentOffset.y >= 0 && contentOffset.y <= initStatusContentOffsetY) {
//        CGFloat distanceRatio = contentOffset.y / initStatusContentOffsetY;
//        CGFloat topOffset = (distanceRatio * -(12 + 12)) + 12;
//        _authorViewTopConstraint.offset(topOffset);
//    }
//}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 4; // 内容 + 相似歌曲 + 热门评论 + 普通评论
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 1;
	} else if (section == 1) {
		return _relatedMusics && _relatedMusics.count > 0 ? 1 : 0;
	} else if (section == 2) { // 热门评论
		return _commentList ? _commentList.hotComments.count : 0;
	} else if (section == 3) {
		return _commentList ? _commentList.comments.count : 1; // no comment cell
	}
	
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		if (!_contentCell) {
			_contentCell = [tableView dequeueReusableCellWithIdentifier:kMLBMusicContentCellID forIndexPath:indexPath];
		}
		
		[_contentCell configureCellWithMusicDetails:_musicDetails];
		
		if (!_contentCell.contentTypeButtonSelected) {
			__weak typeof(self) weakSelf = self;
			_contentCell.contentTypeButtonSelected = ^(MLBMusicDetailsType type) {
				__strong typeof(weakSelf) strongSelf = weakSelf;
				[strongSelf.tableView reloadData];
			};
		}
		
		return _contentCell;
	} else if (indexPath.section == 1) {
		if (!_collectionCell) {
			_collectionCell = [tableView dequeueReusableCellWithIdentifier:kMLBRelatedMusicCollectionCellID forIndexPath:indexPath];
		}
		
		[_collectionCell configureCellWithRelatedMusics:_relatedMusics];
		
		return _collectionCell;
	} else if (indexPath.section == 2 || indexPath.section == 3) {
		if (indexPath.section == 3 && (!_commentList || _commentList.comments.count <= 0)) {
			return [tableView dequeueReusableCellWithIdentifier:kMLBNoneMessageCellID forIndexPath:indexPath];
		}
		
		MLBCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLBCommentCellID forIndexPath:indexPath];
		[cell configureCellForCommonWithComment:[self commentAtIndexPath:indexPath] atIndexPath:indexPath];
		if (!cell.cellButtonClicked) {
			__weak typeof(self) weakSelf = self;
			cell.cellButtonClicked = ^(MLBCommentCellButtonType type, NSIndexPath *indexPath) {
				__strong typeof(weakSelf) strongSelf = weakSelf;
				[strongSelf commentCellButtonClickedWithType:type indexPath:indexPath];
			};
		}
		
		return cell;
	}
	
	return nil;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 1 && _relatedMusics && _relatedMusics.count > 0) { // 相似歌曲
		return [MLBCommonHeaderFooterView viewHeight];
	} else if (section == 2) { // 评论列表		// && [self hasComments]
		return [MLBCommonHeaderFooterView viewHeight];
	}
	
	return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (section == 2 && _commentList && _commentList.hotComments.count > 0) { // 以上是热门评论
		return [MLBCommonHeaderFooterView viewHeight];
	}
	
	return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		__weak typeof(self) weakSelf = self;
		return [tableView fd_heightForCellWithIdentifier:kMLBMusicContentCellID cacheByIndexPath:indexPath configuration:^(MLBMusicContentCell *cell) {
			__strong typeof(weakSelf) strongSelf = weakSelf;
			[cell configureCellWithMusicDetails:strongSelf.musicDetails];
		}];
	} else if (indexPath.section == 1) {
		return [MLBRelatedMusicCollectionCell cellHeight];
	} else if (indexPath.section == 2 || indexPath.section == 3) {
		if (indexPath.section == 3 && (!_commentList || _commentList.comments.count <= 0)) {
			return [MLBNoneMessageCell cellHeight];
		}
		
		__weak typeof(self) weakSelf = self;
		return [tableView fd_heightForCellWithIdentifier:kMLBCommentCellID cacheByIndexPath:indexPath configuration:^(MLBCommentCell *cell) {
			__strong typeof(weakSelf) strongSelf = weakSelf;
			[cell configureCellForCommonWithComment:[strongSelf commentAtIndexPath:indexPath] atIndexPath:indexPath];
		}];
	}
	
	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 1 && _relatedMusics && _relatedMusics.count > 0) { // 相似歌曲
		MLBCommonHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kMLBCommonHeaderFooterViewIDForTypeHeader];
		view.viewType = MLBCommonHeaderFooterViewTypeRelatedMusic;
		
		return view;
	} else if (section == 2) { // 评论列表	// && [self hasComments]
		MLBCommonHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kMLBCommonHeaderFooterViewIDForTypeHeader];
		view.viewType = MLBCommonHeaderFooterViewTypeComment;
		
		return view;
	}
	
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	if (section == 2 && _commentList && _commentList.hotComments.count > 0) { // 以上是热门评论
		MLBCommonHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kMLBCommonHeaderFooterViewIDForTypeHeader];
		view.viewType = MLBCommonHeaderFooterViewTypeAboveIsHotComments;
		
		return view;
	}
	
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
