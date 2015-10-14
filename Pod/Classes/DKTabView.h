//
//  DKTabView.h
//  SwipeViewExample
//
//  Created by pan drinking on 15/3/24.
//
//

#import <UIKit/UIKit.h>

@class DKTabView;

typedef NS_ENUM(NSInteger, DKTABLAYOUTSTYLE) {
    DKTABFILLPARENT, DKTABWRAPCONTENT
};

typedef NS_ENUM(NSInteger, DKTABCURSORSTYLE) {
    DKTABCURSORUNDERNEATH, DKTABCURSORWRAP
};


typedef void (^dkTabItemAtIndexBlock)(UIView *view,NSInteger index);

@interface DKTabView : UIView

@property(nonatomic, strong) UIView *cursorView;
@property(nonatomic, assign) BOOL showCursor;
@property(nonatomic, assign) CGFloat cursorAnimationDuration;
@property(nonatomic, assign) CGFloat cursorHeight;
@property(nonatomic, assign) DKTABCURSORSTYLE cursorStyle;
@property(nonatomic, assign) CGVector cursorWrapInset;
@property(nonatomic, assign) NSInteger cursorIndex;


@property(nonatomic, assign) UIEdgeInsets tabViewItemMargin;
@property(nonatomic, assign) DKTABLAYOUTSTYLE layoutStyle;

@property(nonatomic, copy) dkTabItemAtIndexBlock hightlightTabItemBlock;
@property(nonatomic, copy) dkTabItemAtIndexBlock normalizeTabItemBlock;
@property(nonatomic, copy) dkTabItemAtIndexBlock didTapItemAtIndexBlock;

- (void)buildTabViewWithItems:(NSArray *(^)())tabViewItems;
- (void)updateCursorToIndex:(NSInteger)index;
@end
