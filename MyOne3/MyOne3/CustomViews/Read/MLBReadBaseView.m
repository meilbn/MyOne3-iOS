//
//  MLBReadBaseView.m
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadBaseView.h"
#import "MLBReadEssay.h"
#import "MLBReadSerial.h"
#import "MLBReadQuestion.h"
#import "MLBReadBaseCell.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>

NSString *const kMLBReadBaseViewID = @"MLBReadBaseViewID";

@interface MLBReadBaseView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic) MLBReadEssay *readEssay;
@property (copy, nonatomic) MLBReadSerial *readSerial;
@property (copy, nonatomic) MLBReadQuestion *readQuestion;
@property (strong, nonatomic) MASConstraint *tableViewHeightConstraint;

@end

@implementation MLBReadBaseView {
    NSMutableArray *rowHeights;
}

#pragma mark - LifeCycle

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

#pragma mark - Private Method

- (void)setupViews {
    if (_scrollView) {
        return;
    }
    
    self.backgroundColor = MLBViewControllerBGColor;
    
    _scrollView = ({
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.backgroundColor = MLBViewControllerBGColor;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        scrollView;
    });
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(12, 12, SCREEN_WIDTH, 450)];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[MLBReadBaseCell class] forCellReuseIdentifier:kMLBReadBaseCellID];
        tableView.tableFooterView = [UIView new];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = NO;
        tableView.scrollsToTop = NO;
        tableView.translatesAutoresizingMaskIntoConstraints = YES;
        tableView.layer.masksToBounds = NO;
        tableView.layer.shadowColor = MLBShadowColor.CGColor;// #666666
        tableView.layer.shadowRadius = 2;
        tableView.layer.shadowOffset = CGSizeZero;
        tableView.layer.shadowOpacity = 0.5;
        tableView.layer.cornerRadius = 5;
        [_scrollView addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_scrollView).insets(UIEdgeInsetsMake(12, 12, 12, 12));
            make.width.equalTo(@(SCREEN_WIDTH - 24));
            _tableViewHeightConstraint = make.height.equalTo(@450);
        }];
        
        tableView;
    });
}

#pragma mark - Public Method

- (void)configureViewWithReadEssay:(MLBReadEssay *)readEssay readSerial:(MLBReadSerial *)readSerial readQuestion:(MLBReadQuestion *)readQuestion atIndex:(NSInteger)index {
    [self configureViewWithReadEssay:readEssay readSerial:readSerial readQuestion:readQuestion atIndex:index inViewController:nil];
}

- (void)configureViewWithReadEssay:(MLBReadEssay *)readEssay readSerial:(MLBReadSerial *)readSerial readQuestion:(MLBReadQuestion *)readQuestion atIndex:(NSInteger)index inViewController:(MLBBaseViewController *)parentViewController {
    self.viewIndex = index;
    self.parentViewController = parentViewController;
    _readEssay = readEssay;
    _readSerial = readSerial;
    _readQuestion = readQuestion;
    rowHeights = @[@0, @0, @0].mutableCopy;
    _scrollView.contentOffset = CGPointZero;
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLBReadBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLBReadBaseCellID forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(MLBReadBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [cell configureCellWithReadEssay:_readEssay];
    } else if (indexPath.row == 1) {
        [cell configureCellWithReadSerial:_readSerial];
    } else {
        [cell configureCellWithReadQuestion:_readQuestion];
    }
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = [tableView fd_heightForCellWithIdentifier:kMLBReadBaseCellID configuration:^(MLBReadBaseCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
    rowHeights[indexPath.row] = @(ceil(rowHeight));
    if (indexPath.row == rowHeights.count - 1) {
        NSInteger tableViewHeight = 0;
        for (NSNumber *height in rowHeights) {
            tableViewHeight += [height integerValue];
        }
        _tableViewHeightConstraint.equalTo(@(tableViewHeight));
    }
    
    return ceil(rowHeight);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_readSelected) {
        _readSelected(indexPath.row == 0 ? MLBReadTypeEssay : (indexPath.row == 1 ? MLBReadTypeSerial : MLBReadTypeQuestion));
    }
}

@end
