//
//  CustomScrollView.h
//  QMLtest
//
//  Created by sreejith on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QBMLayoutDelegate <NSObject>
- (void)didSelectedView:(UIView *)selectedView atIndex:(NSUInteger)index;
@optional
- (void)viewDidScrolled:(UIScrollView *)sView;
@end

@protocol QBMLayoutDataSource;

@interface CustomScrollView : UIScrollView <UIScrollViewDelegate>
{
    int             preloadBuffer_;
	NSMutableDictionary *sizeDict;
	NSMutableArray *sizeArray;
    __unsafe_unretained id<QBMLayoutDataSource> dataSource_;
    __unsafe_unretained id<QBMLayoutDelegate> scrollDelegate_;
    BOOL isReachedEnd;
    BOOL isRefreshStarted;
    BOOL isScrolling_;
    
}

@property (nonatomic) UIEdgeInsets contentInsets;
@property (nonatomic) UIEdgeInsets finalInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) NSInteger totalCount;
@property (nonatomic) NSInteger coloumCount;
@property (nonatomic) NSInteger rowCount;
@property (nonatomic) CGFloat rowGap;
@property (nonatomic) CGFloat columnGap;
@property (nonatomic, strong)   NSMutableSet *recycledItems;
@property (nonatomic, strong)   NSMutableSet *visibleItems;
@property(nonatomic , readonly) NSInteger firstVisibleItemIndex;
@property(nonatomic , readonly) NSInteger lastVisibleItemIndex;
@property int preloadBuffer;
@property(nonatomic, assign) __unsafe_unretained id<QBMLayoutDataSource> dataSource;
@property(nonatomic, assign) __unsafe_unretained id<QBMLayoutDelegate> scrollDelegate;


- (void)refreshScrollView;
- (UIView *)dequeueReusableItem;
- (void)initializeScrollView;
- (NSArray *)getTheExtractedIndexes:(NSUInteger)currentIndex;
@end


@protocol QBMLayoutDataSource <NSObject>

@required
/**
 To set the number of items to display
 */
- (NSInteger)numberOfItemsInArrayView:(CustomScrollView *)layOutView;
/**
 To set the item at an index
 */
- (UIView *)viewForItemInScrollView:(CustomScrollView *)layOutView atIndex:(NSInteger)index;
/**
 To set the number of columns required
 */
- (NSInteger)numberOfColoumnsRequired;


@optional
/**
 To set the horizontal gap between two items
 */
- (CGFloat)gapForRow;

/**
 To set the vertical gap between two items
 */
- (CGFloat)gapForColoumn;

@end

