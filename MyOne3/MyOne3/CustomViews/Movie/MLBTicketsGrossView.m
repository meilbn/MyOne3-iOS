//
//  MLBTicketsGrossView.m
//  MyOne3
//
//  Created by meilbn on 3/7/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBTicketsGrossView.h"

@interface MLBTicketsGrossView ()

@property (strong, nonatomic) UILabel *label0;
@property (strong, nonatomic) UILabel *label1;
@property (strong, nonatomic) UILabel *label2;
@property (strong, nonatomic) UILabel *label3;
@property (strong, nonatomic) UILabel *label4;

@end

@implementation MLBTicketsGrossView {
    NSArray *labels;
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
    if (_label0) {
        return;
    }
    
    _label0 = ({
        UILabel *label = [self labelForCommonInit];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self);
        }];
        
        label;
    });
    
    _label1 = ({
        UILabel *label = [self labelForCommonInit];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(_label0.mas_right);
            make.bottom.equalTo(_label0);
        }];
        
        label;
    });
    
    _label2 = ({
        UILabel *label = [self labelForCommonInit];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self);
            make.left.equalTo(_label1.mas_right);
            make.bottom.equalTo(_label1);
            make.width.equalTo(@[_label0, _label1]);
        }];
        
        label;
    });
    
    _label3 = ({
        UILabel *label = [self labelForCommonInit];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label0.mas_bottom);
            make.left.bottom.equalTo(self);
            make.height.equalTo(_label0);
        }];
        
        label;
    });
    
    _label4 = ({
        UILabel *label = [self labelForCommonInit];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label3);
            make.left.equalTo(_label3.mas_right);
            make.right.bottom.equalTo(self);
            make.width.equalTo(_label3);
        }];
        
        label;
    });
    
    labels = @[_label0, _label1, _label2, _label3, _label4];
}

- (UILabel *)labelForCommonInit {
    UILabel *label = [UILabel new];
    label.font = FontWithSize(13);
    label.textColor = [UIColor colorWithWhite:127 / 255.0 alpha:1];// #7F7F7F
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

#pragma mark - Public Method

- (void)configureViewWithKeywords:(NSArray<NSString *> *)keywords {
    [keywords enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = labels[idx];
        label.text = (NSString *)obj;
    }];
}

@end
