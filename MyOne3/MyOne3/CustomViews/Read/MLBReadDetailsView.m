//
//  MLBReadDetailsView.m
//  MyOne3
//
//  Created by meilbn on 2/26/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadDetailsView.h"

#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "MLBReadDetailsAuthorCell.h"
#import "MLBReadDetailsTitleAndOperationCell.h"
#import "MLBReadDetailsContentCell.h"
#import "MLBReadDetailsAuthorInfoCell.h"
#import "MLBReadBaseCell.h"
#import "MLBCommentCell.h"
#import "MLBReadDetailsQuestionTitleCell.h"
#import "MLBReadDetailsQuestionAnswerCell.h"

#import "MLBCommonHeaderFooterView.h"

#import "MLBReadEssay.h"
#import "MLBReadEssayDetails.h"
#import "MLBReadSerial.h"
#import "MLBReadSerialDetails.h"
#import "MLBReadQuestion.h"
#import "MLBReadQuestionDetails.h"

#import "MLBCommentList.h"

#import "MLBSerialCollectionView.h"

#import <MJRefresh/MJRefresh.h>

#import "MLBSingleReadDetailsViewController.h"

NSString *const kMLBReadDetailsViewID = @"MLBReadDetailsViewID";

@interface MLBReadDetailsView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) MLBReadDetailsContentCell *contentCell;

@property (strong, nonatomic) UIButton *praiseButton;
@property (strong, nonatomic) UIButton *commentButton;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UILabel *praiseCountLabel;
@property (strong, nonatomic) UIButton *commentCountButton;
@property (strong, nonatomic) UIToolbar *bottomBar;

@property (strong, nonatomic) MLBSerialCollectionView *serialCollectionView;

@property (assign, nonatomic) MLBReadType viewType;
@property (strong, nonatomic) MLBBaseModel *readModel;
@property (strong, nonatomic) MLBBaseModel *readDetailsModel;
@property (strong, nonatomic) NSArray *relatedList;

@property (strong, nonatomic) MASConstraint *bottomBarBottomOffsetConstraint;

@property (strong, nonatomic) MLBCommentList *commentList;

@property (strong, nonatomic) NSOperationQueue *operationQueue;

@end

@implementation MLBReadDetailsView {
	BOOL _shownBottomBar;
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

#pragma mark - Getter

- (MLBSerialCollectionView *)serialCollectionView {
	if (!_serialCollectionView) {
		_serialCollectionView = [[MLBSerialCollectionView alloc] init];
		__weak typeof(self) weakSelf = self;
		_serialCollectionView.didSelectedSerial = ^(MLBReadSerial *serial) {
			__strong typeof(weakSelf) strongSelf = weakSelf;
			[strongSelf.serialCollectionView dismissWithCompleted:^{
				[strongSelf showSingleReadDetailsWithReadModel:serial];
			}];
		};
	}
	
	return _serialCollectionView;
}

- (NSOperationQueue *)operationQueue {
	if (!_operationQueue) {
		_operationQueue = [NSOperationQueue mainQueue];
		_operationQueue.maxConcurrentOperationCount = 1;
	}
	
	return _operationQueue;
}

#pragma mark - Private Method

- (void)configure {
    [self initDatas];
    [self setupViews];
}

- (void)initDatas {
	self.viewIndex = -1;
}

- (void)setupViews {
    if (_tableView) {
        return;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.dataSource = self;
        tableView.delegate = self;
		[tableView registerClass:[MLBCommonHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kMLBCommonHeaderFooterViewIDForTypeHeader];
        [tableView registerClass:[MLBReadDetailsAuthorCell class] forCellReuseIdentifier:kMLBReadDetailsAuthorCellID];
		[tableView registerClass:[MLBReadDetailsTitleAndOperationCell class] forCellReuseIdentifier:kMLBReadDetailsTitleAndOperationCellID];
		[tableView registerClass:[MLBReadDetailsContentCell class] forCellReuseIdentifier:kMLBReadDetailsContentCellID];
		[tableView registerClass:[MLBReadDetailsAuthorInfoCell class] forCellReuseIdentifier:kMLBReadDetailsAuthorInfoCellID];
		[tableView registerClass:[MLBReadBaseCell class] forCellReuseIdentifier:kMLBReadBaseCellID];
		[tableView registerClass:[MLBCommentCell class] forCellReuseIdentifier:kMLBCommentCellID];
		[tableView registerClass:[MLBReadDetailsQuestionTitleCell class] forCellReuseIdentifier:kMLBReadDetailsQuestionTitleCellID];
		[tableView registerClass:[MLBReadDetailsQuestionAnswerCell class] forCellReuseIdentifier:kMLBReadDetailsQuestionAnswerCellID];
        tableView.tableFooterView = [UIView new];
		tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
		tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 44, 0);
        [self addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self);
        }];
        
        tableView;
    });
	
	self.bottomBar = ({
		UIToolbar *toolbar = [UIToolbar new];
		[self addSubview:toolbar];
		[toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
			make.height.equalTo(@44);
			make.left.right.equalTo(self);
			_bottomBarBottomOffsetConstraint = make.bottom.equalTo(self).offset(44);
		}];
		
		toolbar;
	});
	
	self.praiseButton = ({
		UIButton *button = [MLBUIFactory buttonWithImageName:@"like_normal" selectedImageName:@"like_selected" target:self action:@selector(praiseButtonSelected)];
		button.backgroundColor = [UIColor clearColor];
		[_bottomBar addSubview:button];
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.equalTo(button.mas_height).multipliedBy(1.0);
			make.top.left.bottom.equalTo(_bottomBar);
		}];
		
		button;
	});
	
	self.commentButton = ({
		UIButton *button = [MLBUIFactory buttonWithImageName:@"icon_toolbar_comment" selectedImageName:nil target:self action:@selector(commentButtonClicked)];
		button.backgroundColor = [UIColor clearColor];
		[_bottomBar addSubview:button];
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.bottom.equalTo(_praiseButton);
			make.width.equalTo(_praiseButton);
			make.left.equalTo(_praiseButton.mas_right);
		}];
		
		button;
	});
	
	self.shareButton = ({
		UIButton *button = [MLBUIFactory buttonWithImageName:@"share_image" selectedImageName:nil target:self action:@selector(shareButtonClicked)];
		button.backgroundColor = [UIColor clearColor];
		[_bottomBar addSubview:button];
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.bottom.equalTo(_praiseButton);
			make.width.equalTo(_praiseButton);
			make.left.equalTo(_commentButton.mas_right);
		}];
		
		button;
	});
	
	self.praiseCountLabel = ({
		UILabel *label = [MLBUIFactory labelWithTextColor:MLBDarkGrayTextColor font:FontWithSize(13)];
		label.backgroundColor = [UIColor clearColor];
		[_bottomBar addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.bottom.equalTo(_bottomBar);
		}];
		
		label;
	});
	
	self.commentCountButton = ({
		UIButton *button = [MLBUIFactory buttonWithTitle:@"" titleColor:MLBDarkGrayTextColor fontSize:13 target:self action:@selector(commentCountButtonClicked)];
		button.backgroundColor = [UIColor clearColor];
		[_bottomBar addSubview:button];
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.right.bottom.equalTo(_bottomBar).insets(UIEdgeInsetsMake(0, 0, 0, 15));
			make.left.equalTo(_praiseCountLabel.mas_right);
		}];
		
		button;
	});
}

- (void)updatePraiseCount:(NSInteger)praiseCount {
	_praiseCountLabel.text = [NSString stringWithFormat:@"%ld 赞 ・ ", praiseCount];
}

- (void)updateCommentCount:(NSInteger)commentCount {
	[_commentCountButton setTitle:[NSString stringWithFormat:@"%ld 评论", commentCount] forState:UIControlStateNormal];
}

- (void)preUpdateViews {
	[self updatePraiseCount:0];
	[self updateCommentCount:0];
	
	[_tableView reloadData];
}

- (void)updateViewsAfterRequestDetails {
	[_tableView reloadData];
	
	switch (_viewType) {
		case MLBReadTypeEssay: {
			[self updatePraiseCount:((MLBReadEssayDetails *)_readDetailsModel).praiseNum];
			[self updateCommentCount:((MLBReadEssayDetails *)_readDetailsModel).commentNum];
			break;
		}
		case MLBReadTypeSerial: {
			[self updatePraiseCount:((MLBReadSerialDetails *)_readDetailsModel).praiseNum];
			[self updateCommentCount:((MLBReadSerialDetails *)_readDetailsModel).commentNum];
			break;
		}
		case MLBReadTypeQuestion: {
			[self updatePraiseCount:((MLBReadQuestionDetails *)_readDetailsModel).praiseNum];
			[self updateCommentCount:((MLBReadQuestionDetails *)_readDetailsModel).commentNum];
			break;
		}
	}
	
	if (!_shownBottomBar) {
		_shownBottomBar = YES;
		
		_bottomBarBottomOffsetConstraint.offset(0);
		[_bottomBar setNeedsLayout];
		[UIView animateWithDuration:0.5 animations:^{
			[_bottomBar layoutIfNeeded];
		}];
	}
	
	if (!_tableView.mj_header) {
		[_tableView mlb_addRefreshingWithTarget:self refreshingAction:nil loadMoreDatasAction:@selector(requestComments)];
	}
	
	[self requestRelateds];
	[self requestComments];
}

- (NSString *)contentId {
    return (_viewType == MLBReadTypeEssay ? ((MLBReadEssay *)_readModel).contentId : (_viewType == MLBReadTypeSerial ? ((MLBReadSerial *)_readModel).contentId : ((MLBReadQuestion *)_readModel).questionId));
}

- (Class)modelClass {
    return (_viewType == MLBReadTypeEssay ? [MLBReadEssay class] : (_viewType == MLBReadTypeSerial ? [MLBReadSerial class] : [MLBReadQuestion class]));
}

- (Class)detailsModelClass {
	return (_viewType == MLBReadTypeEssay ? [MLBReadEssayDetails class] : (_viewType == MLBReadTypeSerial ? [MLBReadSerialDetails class] : [MLBReadQuestionDetails class]));
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

#pragma mark - Public Method

- (void)prepareForReuseWithViewType:(MLBReadType)type {
	_readDetailsModel = nil;
	_relatedList = nil;
	[_commentList.hotComments removeAllObjects];
	[_commentList.comments removeAllObjects];
	_commentList = nil;
	_contentCell = nil;
	
	[self preUpdateViews];
}

- (void)configureViewWithReadModel:(MLBBaseModel *)model type:(MLBReadType)type atIndex:(NSInteger)index inViewController:(MLBBaseViewController *)parentViewController {
	self.viewIndex = index;
	self.parentViewController = parentViewController;
	_viewType = type;
	_readModel = model;
	[self requestDetails];
}

#pragma mark - Action

- (void)listenInButtonClicked {
    
}

- (void)praiseButtonSelected {
	
}

- (void)commentButtonClicked {
	
}

- (void)shareButtonClicked {
	
}

- (void)commentCountButtonClicked {
	if (_commentList) {
		if (_commentList.hotComments.count > 0) {
			[_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:YES];
		} else if (_commentList.comments.count > 0) {
			[_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionTop animated:YES];
		}
	}
}

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

- (void)showSingleReadDetailsWithReadModel:(MLBBaseModel *)model {
	MLBSingleReadDetailsViewController *singleReadDetailsViewController = [[MLBSingleReadDetailsViewController alloc] init];
	singleReadDetailsViewController.readType = _viewType;
	singleReadDetailsViewController.readModel = model;
	[self.parentViewController.navigationController pushViewController:singleReadDetailsViewController animated:YES];
}

#pragma mark - Network Request

- (void)requestDetails {
    __weak typeof(self) weakSelf = self;
    [MLBHTTPRequester requestReadDetailsWithType:[MLBHTTPRequester apiStringForReadDetailsWithReadType:_viewType] itemId:[self contentId] success:^(id responseObject) {
		__strong typeof(weakSelf) strongSelf = weakSelf;
		if (!strongSelf) {
			return;
		}
		
		[strongSelf processingForDetailsWithResponseObject:responseObject];
    } fail:^(NSError *error) {
		__strong typeof(weakSelf) strongSelf = weakSelf;
		[strongSelf showHUDServerError];
    }];
}

- (void)requestRelateds {
    __weak typeof(self) weakSelf = self;
    [MLBHTTPRequester requestRelatedsWithType:[MLBHTTPRequester apiStringForReadWithReadType:_viewType] itemId:[self contentId] success:^(id responseObject) {
		__strong typeof(weakSelf) strongSelf = weakSelf;
		if (!strongSelf) {
			return;
		}
		
		[strongSelf processingForRelatedsWithResponseObject:responseObject];
    } fail:^(NSError *error) {
		__strong typeof(weakSelf) strongSelf = weakSelf;
		[strongSelf showHUDServerError];
    }];
}

- (void)requestComments {
	NSString *commentId = @"0";
	if (_commentList && _commentList.comments.count > 0) {
		commentId = ((MLBComment *)[_commentList.comments lastObject]).commentId;
	}
	
	__weak typeof(self) weakSelf = self;
	[MLBHTTPRequester requestPraiseAndTimeCommentsWithType:_viewType itemId:[self contentId] lastCommentId:commentId success:^(id responseObject) {
		__strong typeof(weakSelf) strongSelf = weakSelf;
		if (!strongSelf) {
			return;
		}
		
		[strongSelf processingForCommentsWithResponseObject:responseObject];
	} fail:^(NSError *error) {
		__strong typeof(weakSelf) strongSelf = weakSelf;
		[strongSelf showHUDServerError];
	}];
}

#pragma mark - Data Processing

- (void)processingForDetailsWithResponseObject:(id)responseObject {
	if ([responseObject[@"res"] integerValue] == 0) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			NSError *error;
			MLBBaseModel *details = [MTLJSONAdapter modelOfClass:[self detailsModelClass] fromJSONDictionary:responseObject[@"data"] error:&error];
			
			if (!error) {
				self.readDetailsModel = details;
				
				dispatch_async(dispatch_get_main_queue(), ^{
					DDLogDebug(@"%@ finished, viewIndex = %ld", NSStringFromSelector(_cmd), self.viewIndex);
					[self updateViewsAfterRequestDetails];
				});
			} else {
				DDLogDebug(@"readDetailsModel error = %@", error);
				dispatch_async(dispatch_get_main_queue(), ^{
					[self showHUDErrorWithText:@"数据解析失败"];
				});
			}
		});
	} else {
		[self showHUDErrorWithText:@"数据获取失败"];
	}
}

- (void)processingForRelatedsWithResponseObject:(id)responseObject {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		if ([responseObject[@"res"] integerValue] == 0) {
			NSArray *data = responseObject[@"data"];
			if (data && [data isKindOfClass:[NSArray class]] && data.count > 0) {
				NSError *error;
				NSArray *relateds = [MTLJSONAdapter modelsOfClass:[self modelClass] fromJSONArray:data error:&error];
				if (!error) {
					self.relatedList = relateds;
					
					DDLogDebug(@"%@ finished, viewIndex = %ld", NSStringFromSelector(_cmd), self.viewIndex);
					
					if (self.readDetailsModel) {
						dispatch_async(dispatch_get_main_queue(), ^{
							[self.operationQueue cancelAllOperations];
							[self.operationQueue addOperationWithBlock:^{
								[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
							}];
						});
					}
					
					return;
				}
			}
		}
	});
}

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
				
				if (self.readDetailsModel) {
					dispatch_async(dispatch_get_main_queue(), ^{
						[self.tableView mlb_endRefreshingHasMoreData:(self.commentList.comments.count != self.commentList.count || cmList.comments.count >= 20)];
						
						if (cmList.comments.count > 0) {
							[self.operationQueue cancelAllOperations];
							[self.operationQueue addOperationWithBlock:^{
								if (lastHotComment) {
									[self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 2)] withRowAnimation:UITableViewRowAnimationNone];
								} else {
									if (indexPaths && indexPaths.count > 0) {
										[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
									}
								}
							}];
						}
					});
				}
			}
		}
	});
}

#pragma mark - Configure Cells

- (void)configureAuthorCell:(MLBReadDetailsAuthorCell *)cell {
	if (_viewType == MLBReadTypeEssay) {
		[cell configureCellWithEssayDetails:(MLBReadEssayDetails *)_readDetailsModel];
	} else if (_viewType == MLBReadTypeSerial) {
		[cell configureCellWithSerialDetails:(MLBReadSerialDetails *)_readDetailsModel];
	}
}

- (void)configureTitleCell:(MLBReadDetailsTitleAndOperationCell *)cell {
	if (_viewType == MLBReadTypeEssay) {
		cell.titleLabel.text = ((MLBReadEssay *)_readModel).title;
		cell.serialsButton.hidden = YES;
	} else if (_viewType == MLBReadTypeSerial) {
		cell.titleLabel.text = ((MLBReadSerial *)_readModel).title;
		cell.serialsButton.hidden = NO;
	}
}

- (void)configureContentCell:(MLBReadDetailsContentCell *)cell {
	switch (_viewType) {
		case MLBReadTypeEssay: {
			[cell configureCellWithContent:((MLBReadEssayDetails *)_readDetailsModel).content editor:((MLBReadEssayDetails *)_readDetailsModel).chargeEditor];
			break;
		}
		case MLBReadTypeSerial: {
			[cell configureCellWithContent:((MLBReadSerialDetails *)_readDetailsModel).content editor:((MLBReadSerialDetails *)_readDetailsModel).chargeEditor];
			break;
		}
		case MLBReadTypeQuestion: {
			[cell configureCellWithContent:((MLBReadQuestionDetails *)_readDetailsModel).answerContent editor:((MLBReadQuestionDetails *)_readDetailsModel).chargeEditor];
			break;
		}
	}
}

- (void)configureAuthorInfoCell:(MLBReadDetailsAuthorInfoCell *)cell {
	switch (_viewType) {
		case MLBReadTypeEssay: {
			[cell configureCellWithAuthor:[((MLBReadEssayDetails *)_readDetailsModel).authors firstObject]];
			break;
		}
		case MLBReadTypeSerial: {
			[cell configureCellWithAuthor:((MLBReadSerialDetails *)_readDetailsModel).author];
			break;
		}
		case MLBReadTypeQuestion: {
			break;
		}
	}
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (!_readDetailsModel) {
		return 0;
	}
	
	return 4; // 内容 + 推荐 + 热门评论 + 普通评论
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		switch (_viewType) {
			case MLBReadTypeEssay:
			case MLBReadTypeSerial: {
				return 4; // 作者信息 + 标题 + 内容 + 作者介绍
			}
			case MLBReadTypeQuestion: {
				return 3; // 问题 + 回答作者及时间 + 回答内容
			}
		}
	} else if (section == 1 && _relatedList) {
		return _relatedList.count;
	} else if (section == 2 && _commentList) {
		return _commentList.hotComments.count;
	} else if (section == 3 && _commentList) {
		return _commentList.comments.count;
	}
	
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (_viewType) {
		case MLBReadTypeEssay:
		case MLBReadTypeSerial: {
			if (indexPath.section == 0) {
				if (indexPath.row == 0) { // 作者信息
					MLBReadDetailsAuthorCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLBReadDetailsAuthorCellID forIndexPath:indexPath];
					[self configureAuthorCell:cell];
					
					return cell;
				} else if (indexPath.row == 1) { // 标题
					MLBReadDetailsTitleAndOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLBReadDetailsTitleAndOperationCellID forIndexPath:indexPath];
					[self configureTitleCell:cell];
					if (!cell.serialsClicked) {
						__weak typeof(self) weakSelf = self;
						cell.serialsClicked = ^() {
							__strong typeof(weakSelf) strongSelf = weakSelf;
							strongSelf.serialCollectionView.serial = (MLBReadSerial *)strongSelf.readModel;
							[strongSelf.serialCollectionView show];
						};
					}
					
					return cell;
				} else if (indexPath.row == 2) { // 内容
					if (!_contentCell) {
						_contentCell = [tableView dequeueReusableCellWithIdentifier:kMLBReadDetailsContentCellID forIndexPath:indexPath];
						[self configureContentCell:_contentCell];
					}
					
					return _contentCell;
				} else if (indexPath.row == 3) { // 作者介绍
					MLBReadDetailsAuthorInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLBReadDetailsAuthorInfoCellID forIndexPath:indexPath];
					[self configureAuthorInfoCell:cell];
					
					return cell;
				}
			}
		}
			break;
		case MLBReadTypeQuestion: {
			if (indexPath.section == 0) {
				if (indexPath.row == 0) { // 问题
					MLBReadDetailsQuestionTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLBReadDetailsQuestionTitleCellID forIndexPath:indexPath];
					[cell configureCellWithQuestionDetails:(MLBReadQuestionDetails *)_readDetailsModel];
					
					return cell;
				} else if (indexPath.row == 1) { // 回答作者及时间
					MLBReadDetailsQuestionAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLBReadDetailsQuestionAnswerCellID forIndexPath:indexPath];
					[cell configureCellWithQuestionDetails:(MLBReadQuestionDetails *)_readDetailsModel];
					
					return cell;
				} else if (indexPath.row == 2) { // 回答内容
					if (!_contentCell) {
						_contentCell = [tableView dequeueReusableCellWithIdentifier:kMLBReadDetailsContentCellID forIndexPath:indexPath];
						[self configureContentCell:_contentCell];
					}
					
					return _contentCell;
				}
			}
		}
			break;
	}
	
	if (indexPath.section == 1) {
		MLBReadBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLBReadBaseCellID forIndexPath:indexPath];
		[cell configureCellWithBaseModel:_relatedList[indexPath.row]];
		
		return cell;
	} else if (indexPath.section == 2 || indexPath.section == 3) {
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
	if (section == 1 && _relatedList && _relatedList.count > 0) { // 相关推荐
		return [MLBCommonHeaderFooterView viewHeight];
	} else if (section == 2 && [self hasComments]) { // 评论列表
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
	switch (_viewType) {
		case MLBReadTypeEssay:
		case MLBReadTypeSerial: {
			if (indexPath.section == 0) {
				if (indexPath.row == 0) { // 作者信息
					__weak typeof(self) weakSelf = self;
					return [tableView fd_heightForCellWithIdentifier:kMLBReadDetailsAuthorCellID cacheByIndexPath:indexPath configuration:^(MLBReadDetailsAuthorCell *cell) {
						__strong typeof(weakSelf) strongSelf = weakSelf;
						[strongSelf configureAuthorCell:cell];
					}];
				} else if (indexPath.row == 1) { // 标题
					__weak typeof(self) weakSelf = self;
					return [tableView fd_heightForCellWithIdentifier:kMLBReadDetailsTitleAndOperationCellID cacheByIndexPath:indexPath configuration:^(MLBReadDetailsTitleAndOperationCell *cell) {
						__strong typeof(weakSelf) strongSelf = weakSelf;
						[strongSelf configureTitleCell:cell];
					}];
				} else if (indexPath.row == 2) { // 内容
					if (!_readDetailsModel) {
						return 0;
					}
					
					__weak typeof(self) weakSelf = self;
					return [tableView fd_heightForCellWithIdentifier:kMLBReadDetailsContentCellID cacheByIndexPath:indexPath configuration:^(MLBReadDetailsContentCell *cell) {
						__strong typeof(weakSelf) strongSelf = weakSelf;
						[strongSelf configureContentCell:cell];
					}];
				} else if (indexPath.row == 3) { // 作者介绍
					__weak typeof(self) weakSelf = self;
					return [tableView fd_heightForCellWithIdentifier:kMLBReadDetailsAuthorInfoCellID cacheByIndexPath:indexPath configuration:^(MLBReadDetailsAuthorInfoCell *cell) {
						__strong typeof(weakSelf) strongSelf = weakSelf;
						[strongSelf configureAuthorInfoCell:cell];
					}];
				}
			}
		}
			break;
		case MLBReadTypeQuestion: {
			if (indexPath.section == 0) {
				if (indexPath.row == 0) { // 问题
					__weak typeof(self) weakSelf = self;
					return [tableView fd_heightForCellWithIdentifier:kMLBReadDetailsQuestionTitleCellID cacheByIndexPath:indexPath configuration:^(MLBReadDetailsQuestionTitleCell *cell) {
						__strong typeof(weakSelf) strongSelf = weakSelf;
						[cell configureCellWithQuestionDetails:(MLBReadQuestionDetails *)strongSelf.readDetailsModel];
					}];
				} else if (indexPath.row == 1) { // 回答作者及时间
					__weak typeof(self) weakSelf = self;
					return [tableView fd_heightForCellWithIdentifier:kMLBReadDetailsQuestionAnswerCellID cacheByIndexPath:indexPath configuration:^(MLBReadDetailsQuestionAnswerCell *cell) {
						__strong typeof(weakSelf) strongSelf = weakSelf;
						[cell configureCellWithQuestionDetails:(MLBReadQuestionDetails *)strongSelf.readDetailsModel];
					}];
				} else if (indexPath.row == 2) { // 回答内容
					if (!_readDetailsModel) {
						return 0;
					}
					
					__weak typeof(self) weakSelf = self;
					return [tableView fd_heightForCellWithIdentifier:kMLBReadDetailsContentCellID cacheByIndexPath:indexPath configuration:^(MLBReadDetailsContentCell *cell) {
						__strong typeof(weakSelf) strongSelf = weakSelf;
						[strongSelf configureContentCell:cell];
					}];
				}
			}
		}
			break;
	}
	
	if (indexPath.section == 1) {
		__weak typeof(self) weakSelf = self;
		return [tableView fd_heightForCellWithIdentifier:kMLBReadBaseCellID cacheByIndexPath:indexPath configuration:^(MLBReadBaseCell *cell) {
			__strong typeof(weakSelf) strongSelf = weakSelf;
			[cell configureCellWithBaseModel:strongSelf.relatedList[indexPath.row]];
		}];
	} else if (indexPath.section == 2 || indexPath.section == 3) {
		__weak typeof(self) weakSelf = self;
		return [tableView fd_heightForCellWithIdentifier:kMLBCommentCellID cacheByIndexPath:indexPath configuration:^(MLBCommentCell *cell) {
			__strong typeof(weakSelf) strongSelf = weakSelf;
			[cell configureCellForCommonWithComment:[strongSelf commentAtIndexPath:indexPath] atIndexPath:indexPath];
		}];
	}
	
	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 1 && _relatedList && _relatedList.count > 0) { // 相关推荐
		MLBCommonHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kMLBCommonHeaderFooterViewIDForTypeHeader];
		view.viewType = MLBCommonHeaderFooterViewTypeRelatedRec;
		
		return view;
	} else if (section == 2 && [self hasComments]) { // 评论列表
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
	
	if (indexPath.section == 1) { // 相关推荐
		[self showSingleReadDetailsWithReadModel:_relatedList[indexPath.row]];
	}
}

@end
