//
//  DDCollectionViewFlowLayout.m
//  DDCollectionViewFlowLayout
//
//  Created by DeJohn Dong on 15-2-12.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "DDCollectionViewFlowLayout.h"

@interface DDCollectionViewFlowLayout()

/**
 *  The section rects array, to store the collectionView sections's rect.
 */
@property (nonatomic, strong) NSMutableArray *sectionRects;
/**
 *  The column rects in section array, to store the ervery rect of column in collectionView section.
 */
@property (nonatomic, strong) NSMutableArray *columnRectsInSection;
/**
 *  The layoutItemAttributes array, to store all the layoutItemAttributes of UICollectionViewCell in the collectionView.
 */
@property (nonatomic, strong) NSMutableArray *layoutItemAttributes;
/**
 *  The collectionView's header & footer dictionary, to store all the UICollectionElementKindSectionHeader & UICollectionElementKindSectionFooter attributes. There are two arrays in the dictionary.
 */
@property (nonatomic, strong) NSDictionary *headerFooterItemAttributes;
/**
 *  The section insetses array, to store the section insetses ervery collection section.
 */
@property (nonatomic, strong) NSMutableArray *sectionInsetses;
/**
 *  The edge insets variable.
 */
@property (nonatomic) UIEdgeInsets currentEdgeInsets;

@end

@implementation DDCollectionViewFlowLayout

#pragma mark - UISubclassingHooks Category Methods

- (CGSize)collectionViewContentSize {
    // update contentSize in super layout.
    [super collectionViewContentSize];
    
    CGRect lastSectionRect = [[self.sectionRects lastObject] CGRectValue];
    CGSize lastSize = CGSizeMake(CGRectGetWidth(self.collectionView.bounds), CGRectGetMaxY(lastSectionRect));
    return lastSize;
}

- (void)prepareLayout {
    
    NSUInteger numberOfSections = self.collectionView.numberOfSections;
    self.sectionRects = [[NSMutableArray alloc] initWithCapacity:numberOfSections];
    self.columnRectsInSection = [[NSMutableArray alloc] initWithCapacity:numberOfSections];
    self.layoutItemAttributes = [[NSMutableArray alloc] initWithCapacity:numberOfSections];
    self.sectionInsetses = [[NSMutableArray alloc] initWithCapacity:numberOfSections];
    self.headerFooterItemAttributes = @{UICollectionElementKindSectionHeader:[NSMutableArray array], UICollectionElementKindSectionFooter:[NSMutableArray array]};
    
    for (NSUInteger section = 0; section < numberOfSections; ++section) {
        NSUInteger itemsInSection = [self.collectionView numberOfItemsInSection:section];
        [self.layoutItemAttributes addObject:[NSMutableArray array]];
        [self prepareLayoutInSection:section numberOfItems:itemsInSection];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind
                                                                     atIndexPath:(NSIndexPath *)indexPath {
    return self.headerFooterItemAttributes[kind][indexPath.section];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutItemAttributes[indexPath.section][indexPath.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self searchVisibleLayoutAttributesInRect:rect];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return self.enableStickyHeaders;
}

#pragma mark - Private Methods

- (void)prepareLayoutInSection:(NSUInteger)section numberOfItems:(NSUInteger)items {
    UICollectionView *collectionView = self.collectionView;
    
    /**
     *  Initialize the indexPath of the section.
     */
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    
    /**
     *  Get the rectangles of last section.
     */
    CGRect previousSectionRect = [self rectForSectionAtIndex:indexPath.section - 1];
    CGRect sectionRect;
    sectionRect.origin.x = 0;
    sectionRect.origin.y = CGRectGetHeight(previousSectionRect) + CGRectGetMinY(previousSectionRect);
    sectionRect.size.width = collectionView.bounds.size.width;
    
    /**
     *  Begin add the header layout attributes in the section.
     */
    CGFloat headerHeight = 0.0f;
    
    // Check the flow layout if implementation the `collectionView:layout:referenceSizeForHeaderInSection:` protocol method. If not implementation pass the header initilaztion.
    if([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        
        // Initialize the header rectangles.
        CGRect headerFrame;
        headerFrame.origin.x = 0.0f;
        headerFrame.origin.y = sectionRect.origin.y;

        CGSize headerSize = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:indexPath.section];
        headerFrame.size.height = headerSize.height;
        headerFrame.size.width = headerSize.width;
        
        UICollectionViewLayoutAttributes *headerAttributes =
        [UICollectionViewLayoutAttributes
         layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
         withIndexPath:indexPath];
        headerAttributes.frame = headerFrame;
        
        headerHeight = headerFrame.size.height;
        [self.headerFooterItemAttributes[UICollectionElementKindSectionHeader] addObject:headerAttributes];
    }

    /**
     *  Begin add the body items layout attributes in the section.
     */
    UIEdgeInsets sectionInsets = UIEdgeInsetsZero;
    
    // Check the flow layout if implementation the `collectionView:layout:insetForSectionAtIndex:` protocol method. If not implementation use the default insets is zero.
    if([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        sectionInsets = [self.delegate collectionView:collectionView layout:self insetForSectionAtIndex:section];
    }
    
    [self.sectionInsetses addObject:[NSValue valueWithUIEdgeInsets:sectionInsets]];
    
    /**
     *  Set the lineSpacing & interitemSpacing between the cells, default values is 0.0f.
     */
    CGFloat lineSpacing = 0.0f;
    CGFloat interitemSpacing = 0.0f;

    // Check the flow layout if implementation the `collectionView:layout:minimumInteritemSpacingForSectionAtIndex:` & `collectionView:layout:minimumLineSpacingForSectionAtIndex:` protocol methods. If implementation set the lineSpacing & interitemSpacing value from the protocol methods.
    if([self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        interitemSpacing = [self.delegate collectionView:collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    
    if([self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        lineSpacing = [self.delegate collectionView:collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    
    CGRect itemsContentRect;
    itemsContentRect.origin.x = sectionInsets.left;
    itemsContentRect.origin.y = headerHeight + sectionInsets.top;
    
    NSUInteger numberOfColumns = [self.delegate collectionView:collectionView layout:self numberOfColumnsInSection:section];
    itemsContentRect.size.width = CGRectGetWidth(collectionView.frame) - (sectionInsets.left + sectionInsets.right);
    
    CGFloat columnSpace = itemsContentRect.size.width - (interitemSpacing * (numberOfColumns - 1));
    CGFloat columnWidth = (columnSpace/numberOfColumns);
    
    // Initialize an empty mutable array earch column.
    [self.columnRectsInSection addObject:[NSMutableArray arrayWithCapacity:numberOfColumns]];
    for (NSUInteger colIdx = 0; colIdx < numberOfColumns; ++colIdx)
        [self.columnRectsInSection[section] addObject:[NSMutableArray array]];
    
    // Calculate every cell's rectangles.
    for (NSInteger itemIdx = 0; itemIdx < items; ++itemIdx) {
        NSIndexPath *itemPath = [NSIndexPath indexPathForItem:itemIdx inSection:section];
        NSInteger destColumnIdx = [self preferredColumnIndexInSection:section];
        NSInteger destRowInColumn = [self numberOfItemsForColumn:destColumnIdx inSection:section];
        CGFloat lastItemInColumnOffsetY = [self lastItemOffsetYForColumn:destColumnIdx inSection:section];
        
        if (destRowInColumn == 0) {
            lastItemInColumnOffsetY += sectionRect.origin.y;
        }
        
        /**
         *  Default item's rectangles is a square.
         */
        CGRect itemRect;
        itemRect.origin.x = itemsContentRect.origin.x + destColumnIdx * (interitemSpacing + columnWidth);
        itemRect.origin.y = lastItemInColumnOffsetY + (destRowInColumn > 0 ? lineSpacing: sectionInsets.top);
        itemRect.size.width = columnWidth;
        itemRect.size.height = columnWidth;
        
        // Check the flow layout if implementation the `collectionView:layout:sizeForItemAtIndexPath:` protocol methods. If implementation set the itemRect size's height is the protocol return size's height.
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
            CGSize itemSize = [self.delegate collectionView:collectionView layout:self sizeForItemAtIndexPath:itemPath];
            itemRect.size.height = itemSize.height;
        }
                
        UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemPath];
        itemAttributes.frame = itemRect;
        [self.layoutItemAttributes[section] addObject:itemAttributes];
        [self.columnRectsInSection[section][destColumnIdx] addObject:[NSValue valueWithCGRect:itemRect]];
    }
    
    itemsContentRect.size.height = [self heightOfItemsInSection:indexPath.section] + sectionInsets.bottom;
    
    /**
     *  Begin add the footer layout attributes in the section.
     */
    CGFloat footerHeight = 0.0f;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        CGRect footerFrame;
        footerFrame.origin.x = 0;
        footerFrame.origin.y = itemsContentRect.size.height;
        
        CGSize footerSize = [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:indexPath.section];
        footerFrame.size.height = footerSize.height;
        footerFrame.size.width = footerSize.width;
        
        UICollectionViewLayoutAttributes *footerAttributes = [UICollectionViewLayoutAttributes
                                                              layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                              withIndexPath:indexPath];
        footerAttributes.frame = footerFrame;
        
        footerHeight = footerFrame.size.height;
        
        [self.headerFooterItemAttributes[UICollectionElementKindSectionFooter] addObject:footerAttributes];
    }
    
    if (section > 0) {
        itemsContentRect.size.height -= sectionRect.origin.y;
    }
    
    sectionRect.size.height = itemsContentRect.size.height + footerHeight;

    [self.sectionRects addObject:[NSValue valueWithCGRect:sectionRect]];
}

/**
 *  Get the Max height between columns as the height of the section.
 *
 *  @param sectionIdx The section index
 *
 *  @return The Max height of the section.
 */
- (CGFloat)heightOfItemsInSection:(NSUInteger)sectionIdx {
    CGFloat maxHeightBetweenColumns = 0.0f;
    NSArray *columnsInSection = self.columnRectsInSection[sectionIdx];
    for (NSUInteger columnIdx = 0; columnIdx < columnsInSection.count; ++columnIdx) {
        CGFloat heightOfColumn = [self lastItemOffsetYForColumn:columnIdx inSection:sectionIdx];
        maxHeightBetweenColumns = MAX(maxHeightBetweenColumns, heightOfColumn);
    }
    return maxHeightBetweenColumns;
}

/**
 *  Get the number of items for column in section.
 *
 *  @param columnIdx  The column index.
 *  @param sectionIdx The section index.
 *
 *  @return The number of items.
 */
- (NSInteger)numberOfItemsForColumn:(NSInteger)columnIdx inSection:(NSInteger)sectionIdx {
    return [self.columnRectsInSection[sectionIdx][columnIdx] count];
}

/**
 *  Get the last item offset y for column in section.
 *
 *  @param columnIdx  The column index.
 *  @param sectionIdx The section index.
 *
 *  @return The last item offset y point value.
 */
- (CGFloat)lastItemOffsetYForColumn:(NSInteger)columnIdx inSection:(NSInteger)sectionIdx {
    NSArray *itemsInColumn = self.columnRectsInSection[sectionIdx][columnIdx];
    if (itemsInColumn.count == 0) {
        if([self.headerFooterItemAttributes[UICollectionElementKindSectionHeader] count] > sectionIdx) {
            CGRect headerFrame = [self.headerFooterItemAttributes[UICollectionElementKindSectionHeader][sectionIdx] frame];
            return headerFrame.size.height;
        }
        return 0.0f;
    } else {
        CGRect lastItemRect = [[itemsInColumn lastObject] CGRectValue];
        return CGRectGetMaxY(lastItemRect);
    }
}

/**
 *  Get the preferred column cell index in the section. It's preferred which cell is shortest column height.
 *
 *  @param sectionIdx The section index.
 *
 *  @return The preferred column cell index.
 */
- (NSInteger)preferredColumnIndexInSection:(NSInteger)sectionIdx {
    NSUInteger shortestColumnIdx = 0;
    CGFloat heightOfShortestColumn = CGFLOAT_MAX;
    for (NSUInteger columnIdx = 0; columnIdx < [self.columnRectsInSection[sectionIdx] count]; ++columnIdx) {
        CGFloat columnHeight = [self lastItemOffsetYForColumn:columnIdx inSection:sectionIdx];
        if (columnHeight < heightOfShortestColumn) {
            shortestColumnIdx = columnIdx;
            heightOfShortestColumn = columnHeight;
        }
    }
    return shortestColumnIdx;
}

/**
 *  Get the rectangles of the section.
 *
 *  @param sectionIdx The section index.
 *
 *  @return The rectangles of the section.
 */
- (CGRect)rectForSectionAtIndex:(NSInteger)sectionIdx {
    if (sectionIdx < 0 || sectionIdx >= self.sectionRects.count)
        return CGRectZero;
    return [self.sectionRects[sectionIdx] CGRectValue];
}

#pragma mark - Show Attributes Methods
/**
 *  Get the visible cells's layout attributes in collectionView's visible rectangles on the screen.
 *
 *  @param rect The collectionView's visible rectangles on the screen.
 *
 *  @return The visible layout attributes array.
 */
- (NSArray *)searchVisibleLayoutAttributesInRect:(CGRect)rect {
    NSMutableArray *itemAttrs = [[NSMutableArray alloc] init];
    NSIndexSet *visibleSections = [self sectionIndexesInRect:rect];
    [visibleSections enumerateIndexesUsingBlock:^(NSUInteger sectionIdx, BOOL *stop) {
        
        // Check item layout attributes's rectangles if intersectes the collectionView's rectangles.
        for (UICollectionViewLayoutAttributes *itemAttr in self.layoutItemAttributes[sectionIdx]) {
            CGRect itemRect = itemAttr.frame;
            itemAttr.zIndex = 1;
            BOOL isVisible = CGRectIntersectsRect(rect, itemRect);
            if (isVisible)
                [itemAttrs addObject:itemAttr];
        }
        
        // Check footer layout attributes's rectangles if intersectes the collectionView's rectangles.
        if ([self.headerFooterItemAttributes[UICollectionElementKindSectionFooter] count] > sectionIdx) {
            UICollectionViewLayoutAttributes *footerAttribute = self.headerFooterItemAttributes[UICollectionElementKindSectionFooter][sectionIdx];
            BOOL isVisible = CGRectIntersectsRect(rect, footerAttribute.frame);
            if (isVisible && footerAttribute)
                [itemAttrs addObject:footerAttribute];
            self.currentEdgeInsets = UIEdgeInsetsZero;
        } else {
            self.currentEdgeInsets = [self.sectionInsetses[sectionIdx] UIEdgeInsetsValue];
        }
        
        // Check header layout attributes's rectangles if intersectes the collectionView's rectangles.
        if([self.headerFooterItemAttributes[UICollectionElementKindSectionHeader] count] > sectionIdx) {
            UICollectionViewLayoutAttributes *headerAttribute = self.headerFooterItemAttributes[UICollectionElementKindSectionHeader][sectionIdx];
            
            if (!self.enableStickyHeaders) {
                BOOL isVisibleHeader = CGRectIntersectsRect(rect, headerAttribute.frame);
                
                if (isVisibleHeader && headerAttribute)
                    [itemAttrs addObject:headerAttribute];
            } else {
                UICollectionViewLayoutAttributes *lastCell = [itemAttrs lastObject];
                
                if(headerAttribute)
                   [itemAttrs addObject:headerAttribute];
                
                [self updateHeaderAttributes:headerAttribute lastCellAttributes:lastCell];
            }
        }
    }];
    return itemAttrs;
}

/**
 *  Get the indexes of section in collectionView's visible rectangles on the screen.
 *
 *  @param rect The collectionView's visible rectangles on the screen.
 *
 *  @return The index set.
 */
- (NSIndexSet *)sectionIndexesInRect:(CGRect)rect {
    CGRect theRect = rect;
    NSMutableIndexSet *visibleIndexes = [[NSMutableIndexSet alloc] init];
    NSUInteger numberOfSections = self.collectionView.numberOfSections;
    for (NSUInteger sectionIdx = 0; sectionIdx < numberOfSections; ++sectionIdx) {
        CGRect sectionRect = [self.sectionRects[sectionIdx] CGRectValue];
        BOOL isVisible = CGRectIntersectsRect(theRect, sectionRect);
        if (isVisible)
            [visibleIndexes addIndex:sectionIdx];
    }
    return visibleIndexes;
}

#pragma mark - Sticky Header implementation methods

/**
 *  Update the header layout attributes if set the sticky header property is YES.
 *
 *  @param attributes         The header layout atrributes
 *  @param lastCellAttributes The last cell layout attributes
 */
- (void)updateHeaderAttributes:(UICollectionViewLayoutAttributes *)attributes
            lastCellAttributes:(UICollectionViewLayoutAttributes *)lastCellAttributes
{
    CGRect currentBounds = self.collectionView.bounds;
    attributes.zIndex = 1024;
    attributes.hidden = NO;
    
    CGPoint origin = attributes.frame.origin;
    
    CGFloat sectionMaxY = CGRectGetMaxY(lastCellAttributes.frame) - attributes.frame.size.height + self.currentEdgeInsets.bottom;
    
    CGFloat y = CGRectGetMaxY(currentBounds) - currentBounds.size.height + self.collectionView.contentInset.top;
    
    CGFloat maxY = MIN(MAX(y, attributes.frame.origin.y), sectionMaxY);
    
    origin.y = maxY;
    
    attributes.frame = (CGRect){
        origin,
        attributes.frame.size
    };
}

@end
