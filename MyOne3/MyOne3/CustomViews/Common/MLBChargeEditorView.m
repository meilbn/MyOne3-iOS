//
//  MLBChargeEditorView.m
//  MyOne3
//
//  Created by meilbn on 2/26/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBChargeEditorView.h"

@interface MLBChargeEditorView ()

@property (strong, nonatomic) UILabel *editorLabel;
@property (strong, nonatomic) UIButton *likeButton;
@property (strong, nonatomic) UILabel *likeNumLabel;
@property (strong, nonatomic) UIButton *moreButton;

@end

@implementation MLBChargeEditorView

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
    if (_editorLabel) {
        return;
    }
    
    _moreButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"more_normal" highlightImageName:@"more_highlighted" target:self action:@selector(moreButtonClicked)];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.right.equalTo(self).offset(-8);
            make.centerY.equalTo(self);
        }];
        
        button;
    });
    
    _likeNumLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = MLBDarkGrayTextColor;
        label.font = FontWithSize(12);
        [label setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
        [self insertSubview:label atIndex:2];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_moreButton.mas_left).offset(-10);
            make.centerY.equalTo(self);
        }];
        
        label;
    });
    
    _likeButton = ({
        UIButton *button = [MLBUIFactory buttonWithImageName:@"like_normal" selectedImageName:@"like_selected" target:self action:@selector(likeButtonClicked)];
        [self insertSubview:button atIndex:3];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.right.equalTo(_likeNumLabel.mas_left);
            make.centerY.equalTo(self);
        }];
        
        button;
    });
    
    _editorLabel = ({
        UILabel *label = [UILabel new];
        label.textColor = MLBDarkGrayTextColor;
        label.font = FontWithSize(12);
        label.numberOfLines = 0;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12);
            make.right.lessThanOrEqualTo(_likeButton.mas_left).offset(8);
            make.centerY.equalTo(self);
        }];
        
        label;
    });
}

#pragma mark - Action

- (void)likeButtonClicked {
    if (_praiseClickedBlock) {
        _praiseClickedBlock();
    }
}

- (void)moreButtonClicked {
    if (_moreClickedBlock) {
        _moreClickedBlock();
    }
}

#pragma mark - Public Method

- (void)configureViewWithEditorText:(NSString *)editorText praiseNum:(NSInteger)praiseNum praiseClickedBlock:(CommonActionBlock)praiseClickedBlock moreClickedBlock:(CommonActionBlock)moreClickedBlock {
    _editorLabel.text = editorText;
    _likeNumLabel.text = [@(praiseNum) stringValue];
    _praiseClickedBlock = praiseClickedBlock;
    _moreClickedBlock = moreClickedBlock;
}

@end
