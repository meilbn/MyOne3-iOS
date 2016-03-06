//
//  MLBReadDetailsView.m
//  MyOne3
//
//  Created by meilbn on 2/26/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadDetailsView.h"
#import "MLBChargeEditorView.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "MLBNoneMessageCell.h"
#import <YYText/YYText.h>
#import "MLBCommentCell.h"
#import "MLBCommentList.h"
#import "MZSelectableLabel.h"
#import "MLBBaseViewController.h"
#import "MLBReadEssay.h"
#import "MLBReadEssayDetails.h"
#import "MLBReadSerial.h"
#import "MLBReadSerialDetails.h"
#import "MLBReadQuestion.h"
#import "MLBReadQuestionDetails.h"
#import "MLBReadBaseCell.h"
#import "MLBCommentListViewController.h"

#define kMLBReadDetailsEditorViewMaxHeight       68

NSString *const kMLBReadDetailsViewID = @"MLBReadDetailsViewID";

@interface MLBReadDetailsView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *questionView;
@property (strong, nonatomic) UILabel *questionTitleLabel;
@property (strong, nonatomic) UILabel *questionContentLabel;
@property (strong, nonatomic) UIView *authorView;
@property (strong, nonatomic) UIImageView *authorAvatarView;
@property (strong, nonatomic) UILabel *authorNameLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *authorDescLabel;
@property (strong, nonatomic) UIView *contentCenterView;
@property (strong, nonatomic) MZSelectableLabel *titleLabel;
@property (strong, nonatomic) UIButton *listenInButton;
@property (strong, nonatomic) YYTextView *contentTextView;
@property (strong, nonatomic) MLBChargeEditorView *editorView;
//@property (strong, nonatomic) UITableView *commentsTableView;
//@property (strong, nonatomic) MLBCommonHeaderView *commentsHeaderView;
//@property (strong, nonatomic) MLBCommonFooterView *commentsFooterView;
@property (strong, nonatomic) MLBCommentListViewController *commentListViewController;
@property (strong, nonatomic) UITableView *relatedsTableView;
@property (strong, nonatomic) MLBCommonHeaderView *relatedsHeaderView;
@property (strong, nonatomic) MLBCommonFooterView *relatedsFooterView;

@property (strong, nonatomic) MASConstraint *questionViewTopConstraint;
@property (strong, nonatomic) MASConstraint *contentTextViewHeightConstraint;
@property (strong, nonatomic) MASConstraint *contentCenterViewTopConstraint;
@property (strong, nonatomic) MASConstraint *chargeEditorHeightConstraint;
@property (strong, nonatomic) MASConstraint *commentsTableViewHeightConstraint;
@property (strong, nonatomic) MASConstraint *relatedsTableViewHeightConstraint;

@end

@implementation MLBReadDetailsView {
    MLBReadType viewType;
    MLBBaseModel *readDetailsModel;
    MLBBaseModel *readModel;
//    MLBCommentList *commentList;
//    NSMutableArray *commentRowsHeight;
    NSArray *relatedList;
    NSMutableArray *relatedRowsHeight;
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
//    commentRowsHeight = @[].mutableCopy;
    relatedRowsHeight = @[].mutableCopy;
}

- (void)setupViews {
    if (_scrollView) {
        return;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    
    _scrollView = ({
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.backgroundColor = MLBViewControllerBGColor;
        [self addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
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
    
    _questionView = ({
        UIView *view = [UIView new];
        view.backgroundColor = _contentView.backgroundColor;
        [_contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_contentView);
            _questionViewTopConstraint = make.top.equalTo(_contentView);
        }];
        
        view;
    });
    
    _questionTitleLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = _questionTitleLabel.backgroundColor;
        label.textColor = MLBLightBlackTextColor;
        label.font = FontWithSize(18);
        label.numberOfLines = 0;
        [_questionView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(_questionView).insets(UIEdgeInsetsMake(17, 12, 0, 12));
        }];
        
        label;
    });
    
    _questionContentLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = _questionView.backgroundColor;
        label.textColor = MLBLightBlackTextColor;
        label.font = FontWithSize(15);
        label.numberOfLines = 0;
        [_questionView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_questionTitleLabel);
            make.top.equalTo(_questionTitleLabel.mas_bottom).offset(12);
            make.bottom.equalTo(_questionView).offset(-20);
        }];
        
        label;
    });
    
    UIView *questionViewBottomLine = [MLBUIFactory separatorLine];
    [_questionView addSubview:questionViewBottomLine];
    [questionViewBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.bottom.right.equalTo(_questionView).insets(UIEdgeInsetsMake(0, 6, 0, 6));
    }];
    
    _authorView = ({
        UIView *view = [UIView new];
        view.backgroundColor = _contentView.backgroundColor;
        [_contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_questionView.mas_bottom);
            make.left.right.equalTo(_contentView);
        }];
        
        view;
    });
    
    _authorAvatarView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 1;
        imageView.layer.cornerRadius = 24;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = _authorView.backgroundColor;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_authorView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@48);
            make.top.equalTo(_authorView).offset(20);
            make.left.equalTo(_authorView).offset(12);
            make.bottom.lessThanOrEqualTo(_authorView).offset(-5);
        }];
        
        imageView;
    });
    
    _authorNameLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = _authorView.backgroundColor;
        label.textColor = MLBAppThemeColor;
        label.font = FontWithSize(12);
        [_authorView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_authorAvatarView).offset(6);
            make.left.equalTo(_authorAvatarView.mas_right).offset(12);
        }];
        
        label;
    });
    
    _dateLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = _authorView.backgroundColor;
        label.textColor = MLBLightGrayTextColor;
        label.font = FontWithSize(12);
        label.textAlignment = NSTextAlignmentRight;
        [label setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
        [_authorView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_authorNameLabel.mas_right);
            make.top.equalTo(_authorNameLabel);
            make.right.equalTo(_authorView).offset(-12);
        }];
        
        label;
    });
    
    _authorDescLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = _authorView.backgroundColor;
        label.textColor = MLBLightGrayTextColor;
        label.font = FontWithSize(12);
        label.numberOfLines = 0;
        [_authorView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_authorNameLabel);
            make.top.equalTo(_authorNameLabel.mas_bottom).offset(4);
            make.bottom.lessThanOrEqualTo(_authorView).offset(-5);
        }];
        
        label;
    });
    
    _contentCenterView = ({
        UIView *view = [UIView new];
        [_contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_contentView);
            _contentCenterViewTopConstraint = make.top.equalTo(_authorView.mas_bottom);
        }];
        
        view;
    });
    
    _titleLabel = ({
        MZSelectableLabel *label = [MZSelectableLabel new];
        label.textColor = MLBLightBlackTextColor;
        label.font = FontWithSize(18);
        label.numberOfLines = 0;
        [_contentCenterView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentCenterView).offset(12);
            make.top.equalTo(_contentCenterView).offset(4);
        }];
        
        label;
    });
    
    _listenInButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"audio_normal" highlightImageName:@"audio_highlighted" target:self action:@selector(listenInButtonClicked)];
        [_contentCenterView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.centerY.equalTo(_titleLabel);
            make.left.equalTo(_titleLabel.mas_right).offset(10);
            make.right.equalTo(_contentCenterView).offset(-6);
        }];
        
        button;
    });
    
    _contentTextView = ({
        YYTextView *textView = [YYTextView new];
        textView.backgroundColor = MLBViewControllerBGColor;
        textView.textColor = MLBDarkBlackTextColor;
        textView.font = FontWithSize(15);
        textView.editable = NO;
        textView.scrollEnabled = NO;
        textView.showsVerticalScrollIndicator = NO;
        textView.showsHorizontalScrollIndicator = NO;
        textView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
        [_contentCenterView addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(20);
            make.left.bottom.right.equalTo(_contentCenterView).insets(UIEdgeInsetsMake(0, 6, 0, 6));
            _contentTextViewHeightConstraint = make.height.equalTo(@0);
        }];
        
        textView;
    });
    
    _editorView = ({
        MLBChargeEditorView *view = [MLBChargeEditorView new];
        view.backgroundColor = MLBViewControllerBGColor;
        view.clipsToBounds = YES;
        [_contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            _chargeEditorHeightConstraint = make.height.equalTo(@(kMLBReadDetailsEditorViewMaxHeight));
            make.top.equalTo(_contentCenterView.mas_bottom);
            make.left.right.equalTo(_contentView);
        }];
        
        view;
    });
    
//    _commentsTableView = ({
//        UITableView *tableView = [UITableView new];
//        tableView.backgroundColor = [UIColor whiteColor];
//        tableView.dataSource = self;
//        tableView.delegate = self;
//        tableView.scrollEnabled = NO;
//        [tableView registerClass:[MLBCommentCell class] forCellReuseIdentifier:kMLBCommentCellID];
//        [tableView registerClass:[MLBNoneMessageCell class] forCellReuseIdentifier:kMLBNoneMessageCellID];
//        tableView.tableFooterView = [UIView new];
//        tableView.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
//        tableView.separatorColor = MLBSeparatorColor;
//        [_contentView addSubview:tableView];
//        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_editorView.mas_bottom);
//            make.left.right.equalTo(_contentView);
//            _commentsTableViewHeightConstraint = make.height.equalTo(@0);
//        }];
//
//        tableView;
//    });
    
    __weak typeof(self) weakSelf = self;
    _commentListViewController = [[MLBCommentListViewController alloc] initWithCommentListType:MLBCommentListTypeReadComments headerViewType:MLBHeaderViewTypeComment footerViewType:MLBFooterViewTypeComment];
    _commentListViewController.finishedCalculateHeight = ^(CGFloat height) {
        weakSelf.commentsTableViewHeightConstraint.equalTo(@(height));
    };
    [_contentView addSubview:_commentListViewController.tableView];
    [_commentListViewController.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_editorView.mas_bottom);
        make.left.right.equalTo(_contentView);
        _commentsTableViewHeightConstraint = make.height.equalTo(@0);
    }];
    
    _relatedsTableView = ({
        UITableView *tableView = [UITableView new];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.scrollEnabled = NO;
        [tableView registerClass:[MLBReadBaseCell class] forCellReuseIdentifier:kMLBReadBaseCellID];
        tableView.tableFooterView = [UIView new];
        tableView.separatorInset = UIEdgeInsetsMake(0, 54, 0, 6);
        tableView.separatorColor = MLBSeparatorColor;
        [_contentView addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_commentListViewController.tableView.mas_bottom).offset(5);
            make.left.right.equalTo(_contentView);
            make.bottom.equalTo(_contentView).offset(-12);
            _relatedsTableViewHeightConstraint = make.height.equalTo(@0);
        }];
        
        tableView;
    });
}

- (void)preUpdateViews {
    if (viewType == MLBReadTypeQuestion) {
        return;
    }
    
    [_questionView setNeedsLayout];
    _questionTitleLabel.text = @"ONE";
    _questionContentLabel.text = @"one";
    [_questionView layoutIfNeeded];
    _questionViewTopConstraint.offset((CGRectGetHeight(_questionView.frame) * -1));
    _questionView.hidden = YES;
    
    MLBAuthor *author;
    NSString *dateString;
    if (viewType == MLBReadTypeEssay) {
        MLBReadEssay *essay = (MLBReadEssay *)readModel;
        author = [essay.authors firstObject];
        dateString = essay.makeTime;
        _titleLabel.text = essay.title;
    } else {
        MLBReadSerial *serial = (MLBReadSerial *)readModel;
        author = serial.author;
        dateString = serial.makeTime;
        NSString *numberString = [NSString stringWithFormat:@"( %@ )", serial.number];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                       initWithString:[NSString stringWithFormat:@"%@%@", serial.title, numberString]
                                                       attributes:@{ NSForegroundColorAttributeName : _titleLabel.textColor,
                                                                     NSFontAttributeName : _titleLabel.font}];
        NSRange numberStringRange = [attributedString.string rangeOfString:numberString];
        [attributedString addAttributes:@{ NSForegroundColorAttributeName : MLBAppThemeColor} range:numberStringRange];
        _titleLabel.attributedText = attributedString;
        [_titleLabel setSelectableRange:numberStringRange hightlightedBackgroundColor:MLBAppThemeColor];
        __weak typeof(self) weakSelf = self;
        _titleLabel.selectionHandler = ^(NSRange range, NSString *string) {
            [weakSelf titleNumberClicked];
        };
    }
    
    [_authorAvatarView mlb_sd_setImageWithURL:author.webURL placeholderImageName:@"personal"];
    _authorNameLabel.text = author.username;
    _authorDescLabel.text = author.desc;
    _dateLabel.text = [MLBUtilities stringDateForMusicDetailsDateString:dateString];
    
    _contentTextViewHeightConstraint.equalTo(@0);
    _chargeEditorHeightConstraint.equalTo(@0);
    _commentsTableViewHeightConstraint.equalTo(@0);
    _relatedsTableViewHeightConstraint.equalTo(@0);
}

//- (NSString *)readType {
//    return (viewType == MLBReadTypeEssay ? MLBApiEssay : (viewType == MLBReadTypeSerial ? MLBApiSerial : MLBApiQuestion));
//}

- (NSString *)contentId {
    return (viewType == MLBReadTypeEssay ? ((MLBReadEssay *)readModel).contentId : (viewType == MLBReadTypeSerial ? ((MLBReadSerial *)readModel).contentId : ((MLBReadQuestion *)readModel).questionId));
}

- (Class)modelClass {
    return (viewType == MLBReadTypeEssay ? [MLBReadEssay class] : (viewType == MLBReadTypeSerial ? [MLBReadSerial class] : [MLBReadQuestion class]));
}

- (void)updateViews {
    NSString *chargeEditor = @"";
    NSInteger praiseNum = 0;
    switch (viewType) {
        case MLBReadTypeEssay: {
            MLBReadEssayDetails *essayDetails = (MLBReadEssayDetails *)readDetailsModel;
            [self updateContentTextViewWithText:essayDetails.content];
            chargeEditor = essayDetails.chargeEditor;
            praiseNum = essayDetails.praiseNum;
            break;
        }
        case MLBReadTypeSerial: {
            MLBReadSerialDetails *serialDetails = (MLBReadSerialDetails *)readDetailsModel;
            [self updateContentTextViewWithText:serialDetails.content];
            chargeEditor = serialDetails.chargeEditor;
            praiseNum = serialDetails.praiseNum;
            break;
        }
        case MLBReadTypeQuestion: {
            MLBReadQuestionDetails *questionDetails = (MLBReadQuestionDetails *)readDetailsModel;
            _questionTitleLabel.text = questionDetails.questionTitle;
            _questionContentLabel.text = questionDetails.questionContent;
            _titleLabel.text = questionDetails.answerTitle;
            _dateLabel.text = [MLBUtilities stringDateForMusicDetailsDateString:((MLBReadQuestion *)readModel).questionMakeTime];
            [self updateContentTextViewWithText:questionDetails.answerContent];
            chargeEditor = questionDetails.chargeEditor;
            praiseNum = questionDetails.praiseNum;
            break;
        }
    }
    
    __weak typeof(self) weakSelf = self;
    _chargeEditorHeightConstraint.equalTo(@(kMLBReadDetailsEditorViewMaxHeight));
    [_editorView configureViewWithEditorText:chargeEditor praiseNum:praiseNum praiseClickedBlock:^{
        DDLogDebug(@"praise");
    } moreClickedBlock:^{
        [weakSelf.parentViewController showPopMenuViewWithMenuSelectedBlock:^(MLBPopMenuType menuType) {
            DDLogDebug(@"menuType = %ld", menuType);
        }];
    }];
    
//    [self requestComment];
    [_commentListViewController configureViewForReadDetailsWithReadType:viewType itemId:[self contentId]];
    [self.parentViewController addChildViewController:_commentListViewController];
    [_commentListViewController requestDatas];
    [self requestRelateds];
}

- (void)updateContentTextViewWithText:(NSString *)text {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                          options:@{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType }
                                                                               documentAttributes:nil
                                                                                            error:nil];
    
    attributedString.yy_font = _contentTextView.font;
    attributedString.yy_color = _contentTextView.textColor;
    attributedString.yy_lineSpacing = 10;
    
    _contentTextView.attributedText = attributedString;
    _contentTextViewHeightConstraint.equalTo(@(_contentTextView.textLayout.textBoundingSize.height));
}

//- (void)updateCommentsTableView {
//    CGFloat tableViewHeight = [MLBCommonHeaderView headerViewHeight] + [MLBCommonFooterView footerViewHeight];// headerView + footerView
//    if (commentList.comments.count > 0) {
//        [commentRowsHeight removeAllObjects];
//        for (MLBComment *comment in commentList.comments) {
//            CGFloat cellHeight = [_commentListViewController.tableView fd_heightForCellWithIdentifier:kMLBCommentCellID configuration:^(MLBCommentCell *cell) {
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
//    [_commentListViewController.tableView reloadData];
//}

- (void)updateRelatedsTableView {
    CGFloat tableViewHeight = 0;
    if (relatedList.count > 0) {
        tableViewHeight = [MLBCommonHeaderView headerViewHeight] + [MLBCommonFooterView footerViewHeightForShadow];// headerView + footerView
        [relatedRowsHeight removeAllObjects];
        for (MLBBaseModel *model in relatedList) {
            CGFloat cellHeight = [_relatedsTableView fd_heightForCellWithIdentifier:kMLBReadBaseCellID configuration:^(MLBReadBaseCell *cell) {
                [self configureRelatedCell:cell withModel:model];
            }];
            [relatedRowsHeight addObject:@(ceil(cellHeight))];
            tableViewHeight += ceil(cellHeight);
        }
    }
    
    _relatedsTableViewHeightConstraint.equalTo(@(ceil(tableViewHeight)));
    [_relatedsTableView reloadData];
}

- (void)configureRelatedCell:(MLBReadBaseCell *)cell withModel:(MLBBaseModel *)model {
    switch (viewType) {
        case MLBReadTypeEssay: {
            [cell configureCellWithreadEssay:(MLBReadEssay *)model];
            break;
        }
        case MLBReadTypeSerial: {
            [cell configureCellWithreadSerial:(MLBReadSerial *)model];
            break;
        }
        case MLBReadTypeQuestion: {
            [cell configureCellWithreadQuestion:(MLBReadQuestion *)model];
            break;
        }
    }
}

#pragma mark - Action

- (void)listenInButtonClicked {
    
}

- (void)titleNumberClicked {
    DDLogDebug(@"%@", NSStringFromSelector(_cmd));
}

//- (void)showAllComments {
//    MLBCommentListViewController *commentListViewController = [[MLBCommentListViewController alloc] initWithCommentListType:MLBCommentListTypeReadComments];
//    [commentListViewController configureViewForReadDetailsWithReadType:viewType itemId:[self contentId]];
//    [self.parentViewController.navigationController pushViewController:commentListViewController animated:YES];
//}

#pragma mark - Network Request

- (void)requestDetails {
    [MLBHTTPRequester requestReadDetailsWithType:[MLBHTTPRequester apiStringForReadDetailsWithReadType:viewType] itemId:[self contentId] success:^(id responseObject) {
        if ([responseObject[@"res"] integerValue] == 0) {
            NSError *error;
            MLBBaseModel *details;
            switch (viewType) {
                case MLBReadTypeEssay: {
                    details = [MTLJSONAdapter modelOfClass:[MLBReadEssayDetails class] fromJSONDictionary:responseObject[@"data"] error:&error];
                    break;
                }
                case MLBReadTypeSerial: {
                    details = [MTLJSONAdapter modelOfClass:[MLBReadSerialDetails class] fromJSONDictionary:responseObject[@"data"] error:&error];
                    break;
                }
                case MLBReadTypeQuestion: {
                    details = [MTLJSONAdapter modelOfClass:[MLBReadQuestionDetails class] fromJSONDictionary:responseObject[@"data"] error:&error];
                    break;
                }
            }
            
            if (!error) {
                readDetailsModel = details;
                [self updateViews];
            } else {
                // callback
            }
        } else {
            // callback
        }
    } fail:^(NSError *error) {
        
    }];
}

//- (void)requestComment {
//    [MLBHTTPRequester requestPraiseCommentsWithType:[MLBHTTPRequester apiStringForReadWithReadType:viewType] itemId:[self contentId] firstItemId:@"0" success:^(id responseObject) {
//        if ([responseObject[@"res"] integerValue] == 0) {
//            NSError *error;
//            MLBCommentList *comments = [MTLJSONAdapter modelOfClass:[MLBCommentList class] fromJSONDictionary:responseObject[@"data"] error:&error];
//            if (!error) {
//                commentList = comments;
//                [self updateCommentsTableView];
//            } else {
//                // callback
//            }
//        } else {
//            // callback
//        }
//    } fail:^(NSError *error) {
//        
//    }];
//}

- (void)requestRelateds {
    [MLBHTTPRequester requestRelatedsWithType:[MLBHTTPRequester apiStringForReadWithReadType:viewType] itemId:[self contentId] success:^(id responseObject) {
        if ([responseObject[@"res"] integerValue] == 0) {
            NSError *error;
            NSArray *relateds = [MTLJSONAdapter modelsOfClass:[self modelClass] fromJSONArray:responseObject[@"data"] error:&error];
            if (!error) {
                relatedList = relateds;
                [self updateRelatedsTableView];
            } else {
                // callback
            }
        } else {
            // callback
        }
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark - Public Method

- (void)prepareForReuseWithViewType:(MLBReadType)type {
    if (type == MLBReadTypeQuestion) {
        _listenInButton.hidden = YES;
        _contentCenterViewTopConstraint.offset(-55);
    } else {
        _authorAvatarView.image = [UIImage imageNamed:@"personal"];
        _authorNameLabel.text = @"";
        _authorDescLabel.text = @"";
        _titleLabel.text = @"";
        _dateLabel.text = @"";
        
        if (type == MLBReadTypeEssay) {
            _listenInButton.hidden = NO;
        } else {
            _listenInButton.hidden = YES;
        }
    }
    
    _contentTextViewHeightConstraint.equalTo(@0);
    _chargeEditorHeightConstraint.equalTo(@0);
    _commentsTableViewHeightConstraint.equalTo(@0);
    _relatedsTableViewHeightConstraint.equalTo(@0);
}

- (void)configureViewWithReadModel:(MLBBaseModel *)model type:(MLBReadType)type atIndex:(NSInteger)index inViewController:(MLBBaseViewController *)parentViewController {
    self.viewIndex = index;
    self.parentViewController = parentViewController;
    viewType = type;
    readModel = model;
    [self preUpdateViews];
    [self requestDetails];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (tableView == _commentsTableView) {
//        return commentList.comments.count;
//    } else if (tableView == _relatedsTableView) {
        return relatedList.count;
//    }
//    
//    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView == _commentsTableView) {
//        if (commentList.comments.count > 0) {
//            return [tableView dequeueReusableCellWithIdentifier:kMLBCommentCellID forIndexPath:indexPath];
//        } else {
//            return [tableView dequeueReusableCellWithIdentifier:kMLBNoneMessageCellID];
//        }
//    } else if (tableView == _relatedsTableView) {
        return [tableView dequeueReusableCellWithIdentifier:kMLBReadBaseCellID forIndexPath:indexPath];
//    }
//    
//    return nil;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [MLBCommonHeaderView headerViewHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (tableView == _commentsTableView) {
//        return [MLBCommonFooterView footerViewHeight];
//    } else if (tableView == _relatedsTableView) {
        return [MLBCommonFooterView footerViewHeightForShadow];
//    }
//    
//    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView == _commentsTableView) {
//        if (commentList.comments.count > 0) {
//            return [commentRowsHeight[indexPath.row] floatValue];
//        } else {
//            return [MLBNoneMessageCell cellHeight];
//        }
//    } else if (tableView == _relatedsTableView) {
        return [relatedRowsHeight[indexPath.row] floatValue];
//    }
//    
//    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (tableView == _commentsTableView) {
//        if (!_commentsHeaderView) {
//            _commentsHeaderView = [[MLBCommonHeaderView alloc] initWithHeaderViewType:MLBHeaderViewTypeComment];
//        }
//        
//        return _commentsHeaderView;
//    } else if (tableView == _relatedsTableView) {
        if (!_relatedsHeaderView) {
            _relatedsHeaderView = [[MLBCommonHeaderView alloc] initWithHeaderViewType:MLBHeaderViewTypeRelatedRec];
        }
        
        return _relatedsHeaderView;
//    }
//    
//    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (tableView == _commentsTableView) {
//        if (!_commentsFooterView) {
//            _commentsFooterView = [[MLBCommonFooterView alloc] initWithFooterViewType:MLBFooterViewTypeComment];
//        }
//        
//        [_commentsFooterView configureViewWithCount:commentList.count];
//        __weak typeof(self) weakSelf = self;
//        _commentsFooterView.showAllItems = ^() {
//            [weakSelf showAllComments];
//        };
//        
//        return _commentsFooterView;
//    } else if (tableView == _relatedsTableView) {
        if (!_relatedsFooterView) {
            _relatedsFooterView = [[MLBCommonFooterView alloc] initWithFooterViewType:MLBFooterViewTypeShadow];
        }
        
        return _relatedsFooterView;
//    }
//    
//    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView == _commentsTableView) {
//        if (commentList.comments.count > 0) {
//            [(MLBCommentCell *)cell configureCellForCommonWithComment:commentList.comments[indexPath.row] atIndexPath:indexPath];
//        }
//    } else if (tableView == _relatedsTableView) {
        [self configureRelatedCell:(MLBReadBaseCell *)cell withModel:relatedList[indexPath.row]];
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
