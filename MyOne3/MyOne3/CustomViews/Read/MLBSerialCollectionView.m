//
//  MLBSerialCollectionView.m
//  MyOne3
//
//  Created by meilbn on 3/9/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBSerialCollectionView.h"
#import "MLBSerialCCell.h"
#import "MLBSerialList.h"

@interface MLBSerialCollectionView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) MASConstraint *collectionViewHeightConstraint;

@end

NSString *kCollectionViewReuseHeaderID = @"MLBCollectionViewReuseHeaderID";
NSInteger kCollectionViewHeaderHeight = 50;

@implementation MLBSerialCollectionView {
    MLBSerialList *serialList;
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
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    if (_closeButton) {
        return;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    
    _collectionView = ({
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = [MLBSerialCCell cellSize];
        layout.minimumInteritemSpacing = 13;
        layout.minimumLineSpacing = 10;
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH - 24 * 2, kCollectionViewHeaderHeight);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[MLBSerialCCell class] forCellWithReuseIdentifier:kMLBSerialCCellID];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionViewReuseHeaderID];
        [self addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            _collectionViewHeightConstraint = make.height.equalTo(@(kCollectionViewHeaderHeight));
            make.left.equalTo(self).offset(24);
            make.right.equalTo(self).offset(-24);
        }];
        
        collectionView;
    });
    
    _closeButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"close_normal" highlightImageName:@"close_highlighted" target:self action:@selector(dismiss)];
        button.backgroundColor = [UIColor whiteColor];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.left.equalTo(self).offset(3);
            make.top.equalTo(self).offset(20);
        }];
        
        button;
    });
}

- (void)updateViews {
    NSInteger rowNumber = [MLBUtilities rowWithCount:serialList.list.count colNumber:5];
    NSInteger height = kCollectionViewHeaderHeight + [MLBSerialCCell cellSize].height * rowNumber + ((UICollectionViewFlowLayout *)_collectionView.collectionViewLayout).minimumLineSpacing * (rowNumber - 1);
    _collectionViewHeightConstraint.equalTo(@(height));
    [_collectionView reloadData];
}

#pragma mark - Action

- (void)show {
    self.alpha = 0;
    [kKeyWindow addSubview:self];
    [self requestSerialList];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    [self dismissWithCompleted:NULL];
}

- (void)dismissWithCompleted:(void (^)())completedBlock {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _collectionViewHeightConstraint.equalTo(@(kCollectionViewHeaderHeight));
        serialList = nil;
        if (completedBlock) {
            completedBlock();
        }
    }];
}

#pragma mark - Network Request

- (void)requestSerialList {
    [MLBHTTPRequester requestSerialListById:_serial.serialId success:^(id responseObject) {
        if ([responseObject[@"res"] integerValue] == 0) {
            NSError *error;
            MLBSerialList *list = [MTLJSONAdapter modelOfClass:[MLBSerialList class] fromJSONDictionary:responseObject[@"data"] error:&error];
            if (!error) {
                serialList = list;
                [self updateViews];
            } else {
                
            }
        } else {
            
        }
    } fail:^(NSError *error) {
        // call back
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return serialList.list.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionViewReuseHeaderID forIndexPath:indexPath];
    if (view.subviews.count <= 0) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = _serial.title;
        titleLabel.font = FontWithSize(18);
        titleLabel.textColor = MLBLightBlackTextColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(view);
        }];
        
        UIView *line = [MLBUIFactory separatorLine];
        [view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
            make.left.bottom.right.equalTo(view);
        }];
    }
    
    return view;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MLBSerialCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMLBSerialCCellID forIndexPath:indexPath];
    MLBReadSerial *serial = serialList.list[indexPath.row];
    cell.numberLabel.text = serial.number;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (_didSelectedSerial) {
        _didSelectedSerial(serialList.list[indexPath.row]);
    }
}

@end
