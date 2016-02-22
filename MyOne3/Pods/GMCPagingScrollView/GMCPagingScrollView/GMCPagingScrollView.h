// GMCPagingScrollView.h
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

@protocol GMCPagingScrollViewDelegate;
@protocol GMCPagingScrollViewDataSource;

@interface GMCPagingScrollView : UIView

@property (nonatomic, weak) id<GMCPagingScrollViewDelegate> delegate;
@property (nonatomic, weak) id<GMCPagingScrollViewDataSource> dataSource;
@property (nonatomic, assign) CGFloat interpageSpacing;
@property (nonatomic, assign) UIEdgeInsets pageInsets;
@property (nonatomic, assign) NSUInteger numberOfPreloadedPagesOnEachSide;
@property (nonatomic, assign) BOOL infiniteScroll;
@property (nonatomic, assign) NSUInteger currentPageIndex;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

- (void)registerClass:(Class)class forReuseIdentifier:(NSString *)reuseIdentifier;

- (id)dequeueReusablePageWithIdentifier:(NSString *)reuseIdentifier;

- (id)pageAtIndex:(NSUInteger)page;

- (NSUInteger)indexOfPage:(id)page;

- (NSArray *)visiblePages;

- (void)setCurrentPageIndex:(NSUInteger)index animated:(BOOL)animated;

- (void)setCurrentPageIndex:(NSInteger)index reloadData:(BOOL)reloadData;

- (void)reloadData;

/**
 * This implementation assumes pages will only be inserted after the current index. It will need to be enhanced to support other use cases.
 */
- (void)insertPagesAtIndexes:(NSIndexSet *)indexes;

- (BOOL)isDragging;

@end



@protocol GMCPagingScrollViewDelegate <NSObject>

@optional

- (void)pagingScrollView:(GMCPagingScrollView *)pagingScrollView didScrollToPageAtIndex:(NSUInteger)index;

- (void)pagingScrollViewWillBeginDragging:(GMCPagingScrollView *)pagingScrollView;

- (void)pagingScrollViewDidScroll:(GMCPagingScrollView *)pagingScrollView;

- (void)pagingScrollViewDidFinishScrolling:(GMCPagingScrollView *)pagingScrollView;

- (void)pagingScrollView:(GMCPagingScrollView *)pagingScrollView layoutPageAtIndex:(NSUInteger)index;

- (void)pagingScrollView:(GMCPagingScrollView *)pagingScrollView didEndDisplayingPage:(UIView *)page atIndex:(NSUInteger)index;

@end



@protocol GMCPagingScrollViewDataSource <NSObject>

- (NSUInteger)numberOfPagesInPagingScrollView:(GMCPagingScrollView *)pagingScrollView;

- (UIView *)pagingScrollView:(GMCPagingScrollView *)pagingScrollView pageForIndex:(NSUInteger)index;

@end