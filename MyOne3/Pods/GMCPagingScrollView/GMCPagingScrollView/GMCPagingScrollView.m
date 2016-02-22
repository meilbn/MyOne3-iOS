// GMCPagingScrollView.m
//
// Copyright (c) 2013 Hilton Campbell
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "GMCPagingScrollView.h"
#import <objc/runtime.h>

static const CGFloat kDefaultInterpageSpacing = 40;



typedef void(^GMCPagingInternalScrollViewLayoutSubviewsBlock)();

@interface GMCPagingInternalScrollView : UIScrollView

@property (nonatomic, copy) GMCPagingInternalScrollViewLayoutSubviewsBlock layoutSubviewsBlock;

@end

@implementation GMCPagingInternalScrollView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.layoutSubviewsBlock) {
        self.layoutSubviewsBlock();
    }
}

@end



@interface UIView (GMCPagingScrollView)

@property (nonatomic, copy) NSString *pagingScrollViewReuseIdentifier;
@property (nonatomic, assign) NSUInteger pagingScrollViewPageIndex;

@end

@implementation UIView (GMCPagingScrollView)

static char pagingScrollViewReuseIdentifierKey;
static char pagingScrollViewPageIndexKey;

- (void)setPagingScrollViewReuseIdentifier:(NSString *)pagingScrollViewReuseIdentifier {
    objc_setAssociatedObject(self, &pagingScrollViewReuseIdentifierKey, pagingScrollViewReuseIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)pagingScrollViewReuseIdentifier {
    return objc_getAssociatedObject(self, &pagingScrollViewReuseIdentifierKey);
}

- (void)setPagingScrollViewPageIndex:(NSUInteger)pagingScrollViewPageIndex {
    objc_setAssociatedObject(self, &pagingScrollViewPageIndexKey, @(pagingScrollViewPageIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)pagingScrollViewPageIndex {
    return [objc_getAssociatedObject(self, &pagingScrollViewPageIndexKey) unsignedIntegerValue];
}

@end



@interface GMCPagingScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong, readwrite) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableSet *visiblePageSet;

@property (nonatomic, strong) NSMutableDictionary *classByReuseIdentifier;
@property (nonatomic, strong) NSMutableDictionary *reusablePageSetByReuseIdentifier;

@property (nonatomic, assign) BOOL inLayoutSubviews;

@end

@implementation GMCPagingScrollView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.interpageSpacing = kDefaultInterpageSpacing;
    self.clipsToBounds = YES;
    
    self.scrollView = [[GMCPagingInternalScrollView alloc] initWithFrame:[self frameForScrollView]];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = NO;
    [self addSubview:self.scrollView];
    
    __weak GMCPagingScrollView *weakSelf = self;
    ((GMCPagingInternalScrollView *)self.scrollView).layoutSubviewsBlock = ^() {
        [weakSelf performInfiniteScrollJumpIfNecessary];
    };
    
    self.visiblePageSet = [[NSMutableSet alloc] init];
    
    self.classByReuseIdentifier = [NSMutableDictionary dictionary];
    self.reusablePageSetByReuseIdentifier = [NSMutableDictionary dictionary];
}

- (void)setInterpageSpacing:(CGFloat)interpageSpacing {
	_interpageSpacing = interpageSpacing;
	[self setNeedsLayout];
}

- (CGRect)frameForScrollView {
    CGRect frame = self.bounds;
    frame.origin.x += self.pageInsets.left - self.interpageSpacing / 2;
    frame.size.width += self.interpageSpacing - self.pageInsets.left - self.pageInsets.right;
    return frame;
}

- (CGRect)frameForPageAtActualIndex:(NSUInteger)index {
    CGRect pageFrame = UIEdgeInsetsInsetRect(self.bounds, self.pageInsets);
    pageFrame.origin.x = ([self frameForScrollView].size.width * index) + self.interpageSpacing / 2;
    return pageFrame;
}

- (void)layoutSubviews {
    self.inLayoutSubviews = YES;
    
    [super layoutSubviews];
    
    CGRect frameForScrollView = [self frameForScrollView];
    if (!CGRectEqualToRect(self.scrollView.frame, frameForScrollView)) {
        NSUInteger currentPageIndex = self.currentPageIndex;
        
        NSUInteger numberOfPages = [self.dataSource numberOfPagesInPagingScrollView:self];
        NSUInteger numberOfActualPages = numberOfPages + [self numberOfInfiniteScrollPages];
        
        self.scrollView.frame = frameForScrollView;
        self.scrollView.contentSize = CGSizeMake(frameForScrollView.size.width * numberOfActualPages, frameForScrollView.size.height);
        self.scrollView.contentOffset = CGPointMake(frameForScrollView.size.width * currentPageIndex, 0);
        
        for (UIView *page in self.visiblePageSet) {
            NSUInteger index = [self indexOfPage:page];
            page.frame = [self frameForPageAtActualIndex:index];
            if ([self.delegate respondsToSelector:@selector(pagingScrollView:layoutPageAtIndex:)]) {
                [self.delegate pagingScrollView:self layoutPageAtIndex:index];
            }
        }
    }
    
    self.inLayoutSubviews = NO;
}

- (void)performInfiniteScrollJumpIfNecessary {
    if (self.infiniteScroll) {
        NSUInteger numberOfPages = [self.dataSource numberOfPagesInPagingScrollView:self];
        NSUInteger numberOfActualPages = numberOfPages + [self numberOfInfiniteScrollPages];
        
        NSUInteger currentPageIndex = roundf(self.scrollView.contentOffset.x / self.scrollView.bounds.size.width);
        if (currentPageIndex < [self numberOfInfiniteScrollPages] / 2) {
            // Perform an "infinite scroll" jump
            NSInteger pageIndex = [self.dataSource numberOfPagesInPagingScrollView:self] + currentPageIndex % [self.dataSource numberOfPagesInPagingScrollView:self];
            NSInteger pageDifference = pageIndex - currentPageIndex;
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + pageDifference * self.scrollView.bounds.size.width, self.scrollView.contentOffset.y);
        } else if (currentPageIndex > numberOfActualPages - 1 - [self numberOfInfiniteScrollPages] / 2) {
            // Perform an "infinite scroll" jump
            NSInteger pageIndex = currentPageIndex % [self.dataSource numberOfPagesInPagingScrollView:self];
            NSInteger pageDifference = currentPageIndex - pageIndex;
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x - pageDifference * self.scrollView.bounds.size.width, self.scrollView.contentOffset.y);
        }
    }
}

- (NSUInteger)numberOfInfiniteScrollPages {
    NSUInteger numberOfPages = [self.dataSource numberOfPagesInPagingScrollView:self];
    return (self.infiniteScroll && numberOfPages > 0 ? 2 : 0);
}

- (void)registerClass:(Class)class forReuseIdentifier:(NSString *)reuseIdentifier {
    self.classByReuseIdentifier[reuseIdentifier] = class;
}

- (id)dequeueReusablePageWithIdentifier:(NSString *)reuseIdentifier {
    NSMutableSet *reusablePageSet = [self reusablePageSetForReuseIdentifier:reuseIdentifier];
    
    UIView *page = [reusablePageSet anyObject];
    if (page) {
        [reusablePageSet removeObject:page];
    } else {
        Class class = self.classByReuseIdentifier[reuseIdentifier];
        page = [[class alloc] initWithFrame:self.bounds];
        page.pagingScrollViewReuseIdentifier = reuseIdentifier;
    }
    return page;
}

- (NSMutableSet *)reusablePageSetForReuseIdentifier:(NSString *)reuseIdentifier {
    NSMutableSet *reusablePageSet = self.reusablePageSetByReuseIdentifier[reuseIdentifier];
    if (!reusablePageSet) {
        reusablePageSet = [NSMutableSet set];
        self.reusablePageSetByReuseIdentifier[reuseIdentifier] = reusablePageSet;
    }
    return reusablePageSet;
}

- (UIView *)pageAtIndex:(NSUInteger)index {
	for (UIView *page in self.visiblePageSet) {
        if ([self indexOfPage:page] == index) {
            return page;
        }
    }
	return nil;
}

- (NSUInteger)indexOfPage:(UIView *)page {
    NSUInteger pageIndex = page.pagingScrollViewPageIndex;
    return pageIndex;
}

- (NSArray *)visiblePages {
    return [self.visiblePageSet allObjects];
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {
    BOOL foundPage = NO;
    for (UIView *page in self.visiblePageSet) {
        if ([self indexOfPage:page] == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (void)tilePages {
    // Calculate which pages are visible
    NSUInteger numberOfPages = [self.dataSource numberOfPagesInPagingScrollView:self];
    NSUInteger numberOfActualPages = numberOfPages + [self numberOfInfiniteScrollPages];
    
    NSInteger firstNeededActualPageIndex = MAX(floorf(CGRectGetMinX(self.scrollView.bounds) / CGRectGetWidth(self.scrollView.bounds)) - self.numberOfPreloadedPagesOnEachSide, 0);
    NSInteger lastNeededActualPageIndex = MIN(floorf((CGRectGetMaxX(self.scrollView.bounds) - 1) / CGRectGetWidth(self.scrollView.bounds)) + self.numberOfPreloadedPagesOnEachSide, numberOfActualPages - 1);
    
    if (self.infiniteScroll && numberOfPages > 0) {
        // Move visible pages that are in the wrong place due to an "infinite scroll" jump
        for (NSInteger actualPageIndex = firstNeededActualPageIndex; actualPageIndex <= lastNeededActualPageIndex; actualPageIndex++) {
            NSInteger index = actualPageIndex % numberOfPages;
            
            UIView *page = [self pageAtIndex:index];
            if (page) {
                page.frame = [self frameForPageAtActualIndex:actualPageIndex];
            }
        }
    }
    
    // Recycle no-longer-visible pages
    NSMutableSet *neededPageIndexes = [NSMutableSet set];
    if (numberOfPages > 0) {
        for (NSInteger actualPageIndex = firstNeededActualPageIndex; actualPageIndex <= lastNeededActualPageIndex; actualPageIndex++) {
            [neededPageIndexes addObject:@(actualPageIndex % numberOfPages)];
        }
    }
    
    NSMutableSet *reusablePages = [NSMutableSet set];
    for (UIView *page in self.visiblePageSet) {
        if (numberOfPages == 0 || ![neededPageIndexes containsObject:@([self indexOfPage:page])]) {
            NSString *reuseIdentifier = page.pagingScrollViewReuseIdentifier;
            if (reuseIdentifier) {
                NSMutableSet *reusablePageSet = [self reusablePageSetForReuseIdentifier:reuseIdentifier];
                [reusablePageSet addObject:page];
            }
            
            [reusablePages addObject:page];
            [page removeFromSuperview];
            
            if ([self.delegate respondsToSelector:@selector(pagingScrollView:didEndDisplayingPage:atIndex:)]) {
                [self.delegate pagingScrollView:self didEndDisplayingPage:page atIndex:[self indexOfPage:page]];
            }
        }
    }
    [self.visiblePageSet minusSet:reusablePages];
    
    // Add missing pages
    if (numberOfPages > 0) {
        for (NSInteger actualPageIndex = firstNeededActualPageIndex; actualPageIndex <= lastNeededActualPageIndex; actualPageIndex++) {
            NSInteger index = actualPageIndex % numberOfPages;
            
            if (![self isDisplayingPageForIndex:index]) {
                UIView *page = [self.dataSource pagingScrollView:self pageForIndex:index];
                [self.scrollView addSubview:page];
                [self.visiblePageSet addObject:page];
                page.pagingScrollViewPageIndex = index;
                page.frame = [self frameForPageAtActualIndex:actualPageIndex];
                if ([self.delegate respondsToSelector:@selector(pagingScrollView:layoutPageAtIndex:)]) {
                    [self.delegate pagingScrollView:self layoutPageAtIndex:index];
                }
            }
        }
    }
}

- (void)reloadDataWithCurrentPageIndex:(NSInteger)currentPageIndex {
    for (UIView *page in self.visiblePageSet) {
        [page removeFromSuperview];
        
        if ([self.delegate respondsToSelector:@selector(pagingScrollView:didEndDisplayingPage:atIndex:)]) {
            [self.delegate pagingScrollView:self didEndDisplayingPage:page atIndex:page.pagingScrollViewPageIndex];
        }
    }
    [self.visiblePageSet removeAllObjects];
    [self.reusablePageSetByReuseIdentifier removeAllObjects];
    
    CGRect frameForScrollView = [self frameForScrollView];
    self.inLayoutSubviews = YES;
    self.scrollView.contentSize = CGSizeMake(frameForScrollView.size.width * [self.dataSource numberOfPagesInPagingScrollView:self],
                                             frameForScrollView.size.height);
    self.inLayoutSubviews = NO;
    
    // Unset the delegate temporarily so that the current page index can be updated without triggering any page loading
    id<UIScrollViewDelegate> previousDelegate = self.scrollView.delegate;
    self.scrollView.delegate = nil;
    [self setCurrentPageIndex:currentPageIndex animated:NO];
    _currentPageIndex = currentPageIndex;
    self.scrollView.delegate = previousDelegate;
    
    [self tilePages];
}

- (void)reloadData {
	for (UIView *page in self.visiblePageSet) {
        [page removeFromSuperview];
        
        if ([self.delegate respondsToSelector:@selector(pagingScrollView:didEndDisplayingPage:atIndex:)]) {
            [self.delegate pagingScrollView:self didEndDisplayingPage:page atIndex:[self indexOfPage:page]];
        }
    }
    [self.visiblePageSet removeAllObjects];
    [self.reusablePageSetByReuseIdentifier removeAllObjects];
    
    NSUInteger numberOfPages = [self.dataSource numberOfPagesInPagingScrollView:self];
    NSUInteger numberOfActualPages = numberOfPages + [self numberOfInfiniteScrollPages];
	
	CGRect frameForScrollView = [self frameForScrollView];
	self.scrollView.contentSize = CGSizeMake(frameForScrollView.size.width * numberOfActualPages, frameForScrollView.size.height);
	
	[self tilePages];
}

- (void)insertPagesAtIndexes:(NSIndexSet *)indexes {
    NSUInteger numberOfPages = [self.dataSource numberOfPagesInPagingScrollView:self];
    NSUInteger numberOfActualPages = numberOfPages + [self numberOfInfiniteScrollPages];
	
	CGRect frameForScrollView = [self frameForScrollView];
	self.scrollView.contentSize = CGSizeMake(frameForScrollView.size.width * numberOfActualPages, frameForScrollView.size.height);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
		return self.scrollView;
	}
	return view;
}

- (BOOL)isDragging {
    return self.scrollView.dragging;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(pagingScrollViewWillBeginDragging:)]) {
        [self.delegate pagingScrollViewWillBeginDragging:self];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.inLayoutSubviews) {
        if ([self.delegate respondsToSelector:@selector(pagingScrollViewDidScroll:)]) {
            [self.delegate pagingScrollViewDidScroll:self];
        }
        
        NSUInteger numberOfPages = [self.dataSource numberOfPagesInPagingScrollView:self];
        NSUInteger numberOfActualPages = numberOfPages + [self numberOfInfiniteScrollPages];
        
        NSUInteger currentPageIndex = (numberOfPages > 0 ? MAX(MIN((NSInteger)roundf(self.scrollView.contentOffset.x / self.scrollView.bounds.size.width),
                                                                   (NSInteger)numberOfActualPages - 1), 0) % numberOfPages : 0);
        if (self.currentPageIndex != currentPageIndex) {
            _currentPageIndex = currentPageIndex;
            if ([self.delegate respondsToSelector:@selector(pagingScrollView:didScrollToPageAtIndex:)]) {
                [self.delegate pagingScrollView:self didScrollToPageAtIndex:self.currentPageIndex];
            }
        }
        
        [self tilePages];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(pagingScrollViewDidFinishScrolling:)]) {
        [self.delegate pagingScrollViewDidFinishScrolling:self];
    }
}

- (void)setCurrentPageIndex:(NSUInteger)index animated:(BOOL)animated {
	[self.scrollView setContentOffset:CGPointMake(index * self.scrollView.bounds.size.width, 0) animated:animated];
}

- (void)setCurrentPageIndex:(NSUInteger)index {
	[self setCurrentPageIndex:index animated:NO];
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex reloadData:(BOOL)reloadData {
    if (reloadData) {
        [self reloadDataWithCurrentPageIndex:currentPageIndex];
    } else {
        [self setCurrentPageIndex:currentPageIndex animated:NO];
    }
}

- (CGPoint)contentOffset {
    return self.scrollView.contentOffset;
}

- (void)setContentOffset:(CGPoint)contentOffset {
    self.scrollView.contentOffset = contentOffset;
}

@end
