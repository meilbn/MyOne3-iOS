//
//  MLBReadingBaseView.m
//  MyOne3
//
//  Created by meilbn on 2/21/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBReadingBaseView.h"
#import "MLBReadingEssay.h"
#import "MLBReadingSerial.h"
#import "MLBReadingQuestion.h"
#import "MLBReadingBaseCell.h"
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>

NSString *const kMLBReadingBaseViewID = @"MLBReadingBaseViewID";

@interface MLBReadingBaseView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic) MLBReadingEssay *readingEssay;
@property (copy, nonatomic) MLBReadingSerial *readingSerial;
@property (copy, nonatomic) MLBReadingQuestion *readingQuestion;
@property (strong, nonatomic) MASConstraint *tableViewHeightConstraint;

@end

@implementation MLBReadingBaseView {
    NSInteger viewIndex;
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
    if (!_scrollView) {
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
            [tableView registerClass:[MLBReadingBaseCell class] forCellReuseIdentifier:kMLBReadingBaseCellID];
            tableView.tableFooterView = [UIView new];
            tableView.separatorColor = MLBSeparatorColor;
            tableView.separatorInset = UIEdgeInsetsMake(0, 54, 0, 6);
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
}

#pragma mark - Public Method

- (void)configureViewWithReadingEssay:(MLBReadingEssay *)readingEssay readingSerial:(MLBReadingSerial *)readingSerial readingQuestion:(MLBReadingQuestion *)readingQuestion atIndex:(NSInteger)index {
    viewIndex = index;
    _readingEssay = readingEssay;
    _readingSerial = readingSerial;
    _readingQuestion = readingQuestion;
    rowHeights = @[@0, @0, @0].mutableCopy;
    _scrollView.contentOffset = CGPointZero;
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLBReadingBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:kMLBReadingBaseCellID forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(MLBReadingBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [cell configureCellWithReadingEssay:_readingEssay];
    } else if (indexPath.row == 1) {
        [cell configureCellWithReadingSerial:_readingSerial];
    } else {
        [cell configureCellWithReadingQuestion:_readingQuestion];
    }
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = [tableView fd_heightForCellWithIdentifier:kMLBReadingBaseCellID configuration:^(MLBReadingBaseCell *cell) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
