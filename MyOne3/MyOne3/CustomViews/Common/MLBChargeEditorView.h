//
//  MLBChargeEditorView.h
//  MyOne3
//
//  Created by meilbn on 2/26/16.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBBaseView.h"

@interface MLBChargeEditorView : MLBBaseView

@property (nonatomic, copy) CommonActionBlock praiseClickedBlock;
@property (nonatomic, copy) CommonActionBlock moreClickedBlock;

- (void)configureViewWithEditorText:(NSString *)editorText praiseNum:(NSInteger)praiseNum praiseClickedBlock:(CommonActionBlock)praiseClickedBlock moreClickedBlock:(CommonActionBlock)moreClickedBlock;

@end
