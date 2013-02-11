//
//  CustomScrollView.m
//  QMLtest
//
//  Created by sreejith on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomScrollView.h"


@interface CustomScrollView(){
@private
    
}
- (void)configureItems:(BOOL)updateExisting;
- (void)configureItem:(UIView *)item forIndex:(NSInteger)index;
- (void)recycleItem:(UIView *)item;
- (void)initialSetUp;
- (void)setTheContentSize;
- (void)addTapGestureForView:(UIView *)view;
- (void)reloadData;

- (CGFloat)getTheContentheightOfView ;
- (UIView *)viewForItemAtIndex:(NSUInteger)index;  
- (CGRect)rectForItemAtIndex:(NSUInteger)index withView:(UIView *)view;
- (CGPoint)getXYPoint:(NSUInteger)index;
@end
@implementation CustomScrollView


@synthesize contentInsets = contentInsets_;
@synthesize itemSize = itemSize_;
@synthesize totalCount = totalCount_;
@synthesize recycledItems = recycledItems_;
@synthesize visibleItems = visibleItems_;
@synthesize coloumCount = coloumCount_;
@synthesize rowCount = rowCount_;
@synthesize rowGap = rowGap_;
@synthesize columnGap = columnGap_;
@synthesize finalInsets = finalInsets_;
@synthesize preloadBuffer = preloadBuffer_;
@synthesize dataSource = dataSource_;
@synthesize scrollDelegate = scrollDelegate_;


- (id)initWithFrame:(CGRect)frames 
{
    self = [super initWithFrame:frames];
    if (self) {
        
        [self initialSetUp];
    }
    return self;
}
- (id)init{
    
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 320, 480);
        [self initialSetUp];
    }
    return self;
}

- (void)initialSetUp 
{
    self.delegate = self;
    isReachedEnd = NO;
    self.showsVerticalScrollIndicator = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = YES;
	self.userInteractionEnabled = YES;
    self.contentSize = CGSizeMake(320, 500);
    self.backgroundColor = [UIColor  grayColor];
    self.tag = 1001;
    visibleItems_ = [[NSMutableSet alloc] init];
    recycledItems_ = [[NSMutableSet alloc] init];
    itemSize_ = CGSizeZero;
    preloadBuffer_ = 0;
    
    
    
}
- (void)initializeScrollView
{
    [self reloadData];
}
- (void)refreshScrollView {
    
    
    totalCount_ = [dataSource_ numberOfItemsInArrayView:self];
    if ([dataSource_ respondsToSelector:@selector(gapForRow)])
        rowGap_ = [dataSource_ gapForRow];
    else
        rowGap_ = 5;
    
    if ([dataSource_ respondsToSelector:@selector(gapForColoumn)])
        columnGap_ = [dataSource_ gapForColoumn];
    else
        columnGap_ = 5;
    if ([dataSource_ respondsToSelector:@selector(numberOfColoumnsRequired)])
        coloumCount_ = [dataSource_ numberOfColoumnsRequired];
    else
        coloumCount_ = 5;
    
    for (UIView *view in [visibleItems_ allObjects])
    {
        [view removeFromSuperview];
    }
    [visibleItems_ removeAllObjects];
    isReachedEnd = NO;
    [self configureItems:NO];
    
}
- (void)reloadData
{
    totalCount_ = [dataSource_ numberOfItemsInArrayView:self];
    if ([dataSource_ respondsToSelector:@selector(gapForRow)])
        rowGap_ = [dataSource_ gapForRow];
    else
        rowGap_ = 5;
    
    if ([dataSource_ respondsToSelector:@selector(gapForColoumn)])
        columnGap_ = [dataSource_ gapForColoumn];
    else
        columnGap_ = 5;
    if ([dataSource_ respondsToSelector:@selector(numberOfColoumnsRequired)])
        coloumCount_ = [dataSource_ numberOfColoumnsRequired];
    else
        coloumCount_ = 5;

    for (UIView *view in visibleItems_)
    {
        [self recycleItem:view];
    }
    [visibleItems_ removeAllObjects];
    
    [self configureItems:NO];
}

- (UIView *)viewForItemAtIndex:(NSUInteger)index 
{
    for (UIView *item in visibleItems_)
        if (item.tag == index)
            return item;
    return nil;
}


/**
 To get the required height of the ScrollView
 
 */
- (CGFloat)getTheContentheightOfView {
    CGFloat maxValue = 0.0f;
    int lastRow_First_Item = coloumCount_*(rowCount_ - 1);
    
    for (int i = lastRow_First_Item; i<totalCount_;i++) {
        
         for (UIView *item in [visibleItems_ allObjects]){
             if (item.tag == i) {
                 CGRect iFrame = item.frame;
                 CGFloat yPos = CGRectGetMaxY(iFrame)+rowGap_; 
                  
                 if (yPos > maxValue)
                     maxValue = yPos;
             }
         }
        
    }
    return maxValue;

}

- (CGPoint)getXYPoint:(NSUInteger)index
{
    CGFloat xPos = 0;
    CGFloat yPos1 = 0;
    CGFloat yPos2 = 0;
    
    int index_2 = 0;
    CGFloat yPos = 0;
    NSArray * indexArray = [self getTheExtractedIndexes:index];


    if (index == 0) {
        xPos = columnGap_;
        yPos = rowGap_;
        return CGPointMake(xPos, yPos);
    }
    if (index <coloumCount_) {
        
        for (UIView *item in [visibleItems_ allObjects]) {
            if (item.tag == index-1) {
                CGRect rFrame = item.frame;
                xPos = CGRectGetMaxX(rFrame)+columnGap_;
                
            }
        }
        yPos = rowGap_;
        return CGPointMake(xPos, yPos);
        
    }else{
        
        for (int i = 0; i<[indexArray count]; i++) {
            int ref_tag = [[indexArray objectAtIndex:i] intValue];
            
            for (UIView *item in [visibleItems_ allObjects]){
                if (item.tag == ref_tag) {
                    CGRect iFrame = item.frame;
                    yPos1 = CGRectGetMaxY(iFrame);
                    if(yPos2==0){
                        yPos2 = yPos1;
                        index_2 = ref_tag;
                    }
                    else {
                        if(yPos2>yPos1){
                            yPos2 = yPos1;
                            index_2 = ref_tag;
                            
                        }
                    }
                    
                }
            }
        }
        

        for (UIView *item in [visibleItems_ allObjects]) {
            if (item.tag == index_2)
                xPos = CGRectGetMinX(item.frame)-columnGap_;
        }
        return CGPointMake(xPos, yPos2);
    }
    return CGPointZero;
}


- (NSArray *)getTheExtractedIndexes:(NSUInteger)currentIndex
{
    int startIndex = 0;
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSMutableArray *indexArray = [[NSMutableArray alloc]init];
    NSMutableArray *orgIndexArray = [[NSMutableArray alloc]init];
    
    for (int i = startIndex; i<currentIndex; i++) {
        for (UIView *item in [visibleItems_ allObjects]) {
            if (item.tag == i)
               [array addObject:item];
        }
        [orgIndexArray addObject:[NSNumber numberWithInt:i]];

    }
    for (int j = 0; j<[array count]; j++) {
        UIView *sel_View = (UIView *)[array objectAtIndex:j];
        for (int k= 0; k<[array count]; k++) {
            UIView *test_View = (UIView *)[array objectAtIndex:k];
            if(j!=k){
                if (CGRectGetMinX(sel_View.frame) == CGRectGetMinX(test_View.frame)) {
                    
                    int min_Index = MIN(sel_View.tag, test_View.tag);
                    [indexArray addObject:[NSNumber numberWithInt:min_Index]];
                    
                } 
            }
                
        }
    }
    NSSet *set = [NSSet setWithArray:indexArray];
    [indexArray removeAllObjects];
    [indexArray addObjectsFromArray:[set allObjects]];
    for (int i = 0; i<[indexArray count]; i++) {
        for (int j =0; j<[orgIndexArray count]; j++) {
            if ([[indexArray objectAtIndex:i]isEqual:[orgIndexArray objectAtIndex:j] ]) {
                [orgIndexArray removeObjectAtIndex:j];
            }
        }
    }
    
    
    return orgIndexArray;
}



//-------------------------------------------------------------------------------------------//
/**
 Configuring the items in the ScrollView
 */

- (void)configureItems:(BOOL)reconfigure {
    
    CGSize contentSize = CGSizeMake(self.bounds.size.width,
                                    [self getTheContentheightOfView] + rowGap_ * (rowCount_ - 1) + finalInsets_.top + finalInsets_.bottom);
    
    
    if (self.contentSize.width != contentSize.width || self.contentSize.height != contentSize.height) {
        self.contentSize = contentSize;
    }
    int firstItem = self.firstVisibleItemIndex;
    int lastItem  = self.lastVisibleItemIndex;
    
    // recycle items that are no longer visible
    for (UIView *item in visibleItems_) {
        if (item.tag < firstItem || item.tag > lastItem) {
            [self recycleItem:item];
        }
    }
    [visibleItems_ minusSet:recycledItems_];

    if (lastItem < 0)
        return;
   
    for (int index = firstItem; index <= lastItem; index++) {
        isRefreshStarted = YES;
        UIView *item = [self viewForItemAtIndex:index];
        if (item == nil) {
            item = [dataSource_ viewForItemInScrollView:self atIndex:index];
			item.userInteractionEnabled = YES;
            [self addSubview:item];
            [visibleItems_ addObject:item];
            [self addTapGestureForView:item];
            if (index==lastItem) {
                isReachedEnd = YES;
            }
        } else if (!reconfigure) {
            continue;
        }
        item.tag = index;
        [self configureItem:item forIndex:index];
    }
    
}

- (void)configureItem:(UIView *)item forIndex:(NSInteger)index {
    
    item.frame = [self rectForItemAtIndex:index withView:item];
	[self setTheContentSize];
    [item setNeedsDisplay]; 
    
    
}
/**
 Add tap gesture to the scroll View items
 */
- (void)addTapGestureForView:(UIView *)view {
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(didTap:)];
    tap.numberOfTapsRequired = 1;
    [view addGestureRecognizer:tap];
}

/**
 catch tap on an item in the scroll View 
 */
- (void)didTap:(UITapGestureRecognizer *)tapGesture
{
    if ([dataSource_ respondsToSelector:@selector(didSelectedView:atIndex:)]) {
        [scrollDelegate_ didSelectedView:tapGesture.view atIndex:[tapGesture.view tag]];
    }
}
/**
 Setting the content size of the scroll View.
 */
- (void)setTheContentSize {
    
    CGSize contentSize = CGSizeMake(self.bounds.size.width,
                                    [self getTheContentheightOfView] + rowGap_ * (rowCount_-1) + finalInsets_.top + finalInsets_.bottom);
    self.contentSize = contentSize;
}

#pragma mark -
#pragma mark Layouting

- (void)layoutSubviews {
    if (!isReachedEnd) {
    BOOL boundsChanged = !CGRectEqualToRect(self.frame, self.bounds);
        
    rowCount_ = (totalCount_ + coloumCount_ - 1) / coloumCount_;
    
    finalInsets_ = UIEdgeInsetsMake(contentInsets_.top + rowGap_,
                                    contentInsets_.left + columnGap_,
                                    contentInsets_.bottom + rowGap_,
                                    contentInsets_.right + columnGap_);
	
    
    [self configureItems:boundsChanged];
    }
}
/**
 Return the frame of a given itemView
 */
- (CGRect)rectForItemAtIndex:(NSUInteger)index withView:(UIView *)view {
    CGPoint point = [self getXYPoint:index];
    return CGRectMake(finalInsets_.left + point.x,
                      finalInsets_.top  + point.y,
                      itemSize_.width, itemSize_.height);
}

- (NSInteger)firstVisibleItemIndex {
	
    int firstRow = MAX(floorf((CGRectGetMinY(self.bounds) - finalInsets_.top) / (itemSize_.height + rowGap_)), 0);
    return MIN( MAX(0,firstRow - (preloadBuffer_)) * coloumCount_, totalCount_ - 1);
}
/**
 Return the last item Index.
 */
- (NSInteger)lastVisibleItemIndex {
    int lastRow = MIN( ceilf((CGRectGetMaxY(self.bounds) - finalInsets_.top) / (itemSize_.height + rowGap_)), rowCount_ - 1);

    if (lastRow<0)
        return lastRow;
    else
        return totalCount_-1;
    
    
}

- (UIView *)dequeueReusableItem {
    UIView *result = [recycledItems_ anyObject];
    if (result) {
        [recycledItems_ removeObject:result];
    }
    return result;
}
- (void)recycleItem:(UIView *)item {
    [recycledItems_ addObject:item];
    [item removeFromSuperview];
}


#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollDelegate_ respondsToSelector:@selector(viewDidScrolled:)]) {
        [scrollDelegate_ viewDidScrolled:scrollView];
    }
    
}


  
@end
