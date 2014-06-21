//
//  CCPhotoBrowserView.m
//  Coco
//
//  Created by PeterZhou on 14-6-18.
//  Copyright (c) 2014年 Instanza Inc. All rights reserved.
//

#import "CCPhotoBrowserView.h"

#define PAGE_WIDTH (SCREEN_WIDTH+5)
#define PADDING                  10

@interface CCPhotoBrowserView()

@property (nonatomic) int currentIndex;
@property (nonatomic) int last_x;
@property (nonatomic) int totalNum;
@property (nonatomic) BOOL startPaging;
@property (nonatomic, strong) UIScrollView *pageScrollView;
@property (nonatomic, strong) NSMutableArray *reuseArray;
@property (nonatomic, strong) NSMutableArray *visableArray;



@end

@implementation CCPhotoBrowserView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self reloadAll];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame DataSource:(id<CCPhotoBrowserDataSource>)datasource{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.reuseArray = [NSMutableArray arrayWithCapacity:2];
        self.visableArray = [NSMutableArray arrayWithCapacity:2];
        self.datasource = datasource;
        self.currentIndex = 0;
        self.last_x = 0;
        [self reloadAll];
    }
    return self;
}

#pragma mark - load method

- (void)layoutSubviews{
    [super layoutSubviews];
    [self laySubviews];
}

- (void)reloadAll{
    if (self.datasource&&[self.datasource respondsToSelector:@selector(numberOfImageInBrowserView:)]) {
        self.totalNum = [self.datasource numberOfImageInBrowserView:self];
        if (!self.pageScrollView) {

            CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
            self.pageScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
            self.pageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.pageScrollView.delegate = self;
            self.pageScrollView.scrollEnabled = YES;
            self.pageScrollView.pagingEnabled = YES;
            self.pageScrollView.showsHorizontalScrollIndicator = NO;
            self.pageScrollView.showsVerticalScrollIndicator = NO;
//            self.pageScrollView.clipsToBounds = NO;
            self.pageScrollView.contentSize = [self contentSizeForPagingScrollView];
            self.pageScrollView.backgroundColor = [UIColor whiteColor];
            [self addSubview:self.pageScrollView];
        }
        self.currentIndex = 0;
    }
}


- (void)laySubviews{
    self.pageScrollView.frame = [self frameForPagingScrollView];
    self.pageScrollView.contentSize = [self contentSizeForPagingScrollView];
    [self tilePages];
}


#pragma frame method

- (CGPoint)contentOffsetForPageAtIndex:(NSUInteger)index {
	CGFloat pageWidth = PAGE_WIDTH;
	CGFloat newOffset = index * pageWidth;
	return CGPointMake(newOffset, 0);
}
- (CGSize)contentSizeForPagingScrollView {
    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = self.bounds;
    return CGSizeMake(PAGE_WIDTH * self.totalNum, bounds.size.height);
}

- (CGRect)frameForPagingScrollView {
    CGRect frame = self.bounds;// [[UIScreen mainScreen] bounds];
    frame.size.width = PAGE_WIDTH;
    return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    CGRect bounds = self.bounds;
    CGRect pageFrame = bounds;
    pageFrame.origin.x = (PAGE_WIDTH * index);
    return pageFrame;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {
	for (CCZoomingScrollView *page in self.visableArray)
		if (page.currentIndex == index) return YES;
	return NO;
}

- (CCZoomingScrollView *)pageDisplayedAtIndex:(NSUInteger)index {
	CCZoomingScrollView *thePage = nil;
	for (CCZoomingScrollView *page in self.visableArray) {
		if (page.currentIndex == index) {
			thePage = page; break;
		}
	}
	return thePage;
}

- (CCZoomingScrollView *)dequeueRecycledPage {
    CCZoomingScrollView *page = nil;
    if (self.reuseArray.count>0) {
        page = [self.reuseArray lastObject];
        [self.reuseArray removeLastObject];
    }
	
    return page;
}

#pragma mark - event
- (void)tilePages{
    CGRect visibleBounds = self.pageScrollView.bounds;
    int left = (NSInteger)floorf(CGRectGetMinX(visibleBounds)/CGRectGetWidth(visibleBounds));
    int right = (NSInteger)floorf(CGRectGetMaxX(visibleBounds)/ CGRectGetWidth(visibleBounds));
    NSInteger iFirstIndex = left;
    NSInteger iLastIndex = right;
    if (iFirstIndex < 0) iFirstIndex = 0;
    if (iFirstIndex > self.totalNum - 1) iFirstIndex = self.totalNum - 1;
    if (iLastIndex < 0) iLastIndex = 0;
    if (iLastIndex > self.totalNum - 1) iLastIndex = self.totalNum - 1;
    int pageIndex=0;
    
	for (int i = self.visableArray.count-1;i>=0;i--) {
        CCZoomingScrollView *page = [self.visableArray objectAtIndex:i];
        pageIndex = page.currentIndex;
		if (pageIndex < (NSUInteger)iFirstIndex || pageIndex > (NSUInteger)iLastIndex) {
			[self.reuseArray addObject:page];
            [page prepareForReuse];
            [self.visableArray removeObjectAtIndex:i];
			[page removeFromSuperview];
		}
	}
    while (self.reuseArray.count > 2) // Only keep 2 recycled pages
        [self.reuseArray removeLastObject];
    for (NSUInteger index = (NSUInteger)iFirstIndex; index <= (NSUInteger)iLastIndex; index++){
        if (![self isDisplayingPageForIndex:index]) {
            CCZoomingScrollView *page = [self dequeueRecycledPage];
            if (!page) {
                CGRect frame = [self frameForPageAtIndex:index];
                CCPhoto *photo = [self.datasource imageForIndex:index];
				page = [[CCZoomingScrollView alloc] initWithPhoto:photo andFrame:frame];
                page.backgroundColor = [UIColor whiteColor];
			}
            [self configurePage:page forIndex:index];
            [self.pageScrollView addSubview:page];
            [self.visableArray addObject:page];
        }
    }
}

- (void)configurePage:(CCZoomingScrollView *)page forIndex:(NSUInteger)index {
    CCPhoto *currentPhoto = [self.datasource imageForIndex:index];
	page.frame = [self frameForPageAtIndex:index];
    page.currentIndex = index;
    [page setViewPhoto:currentPhoto];
}





#pragma mark - public method

- (void)addImageAtIndex:(int)index{
}
- (void)removeImageAtIndex:(int)index{
}
- (void)reloadImageAtIndex:(int)index{
    if ([self isDisplayingPageForIndex:index]) {
        for (CCZoomingScrollView *page in self.visableArray) {
            if (page.currentIndex == index) {
                [self configurePage:page forIndex:index];
            }
        }
    }
}

#pragma mark - scrollview delegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self tilePages];
	
	// Calculate current page
	CGRect visibleBounds = self.pageScrollView.bounds;
	NSInteger index = (NSInteger)(floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    if (index < 0) index = 0;
	if (index > self.totalNum- 1) index = self.totalNum - 1;
	NSUInteger previousCurrentPage = self.currentIndex;
	self.currentIndex = index;
	if (self.currentIndex != previousCurrentPage) {
        //        [self didStartViewingPageAtIndex:index];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    CCLog(@"dray");
//    CGRect visibleBounds = self.pageScrollView.bounds;
//    self.last_x = visibleBounds.origin.x;
//    CCLog(@"decelerating:%d",self.last_x);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    CCLog(@"decelerating");
}



@end
