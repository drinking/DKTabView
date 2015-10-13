//
//  DKTabView.h
//  SwipeViewExample
//
//  Created by pan drinking on 15/3/24.
//
//

#import <UIKit/UIKit.h>

@class DKTabView;

@protocol DKTabViewDelegate <NSObject>

@required
- (NSInteger)countForTabItem;

- (UIView *)viewForTabAtIndex:(NSInteger)index;

@optional
- (void)tapView:(DKTabView *)tabView didSelectItemAtIndex:(NSInteger)index;

@end

typedef NS_ENUM(NSInteger, DKTABLAYOUTSTYLE) {
    DKTABFILLPARENT, DKTABWRAPCONTENT
};

typedef NS_ENUM(NSInteger, DKTABCURSORSTYLE) {
    DKTABCURSORUNDERNEATH, DKTABCURSORWRAP
};


typedef void (^dkConfigureView)(UIView *view);

@interface DKTabView : UIView

@property(nonatomic, weak) id <DKTabViewDelegate> delegate;
@property(nonatomic, assign) BOOL showCursor;
@property(nonatomic, assign) CGFloat cursorAnimationDuration;
@property(nonatomic, assign) UIEdgeInsets margin;
@property(nonatomic, assign) DKTABLAYOUTSTYLE layoutStyle;
@property(nonatomic, assign) DKTABCURSORSTYLE cursorStyle;

@property(nonatomic, copy) dkConfigureView hightlightTabItemBlock;
@property(nonatomic, copy) dkConfigureView normalizeTabItemBlock;

- (void)buildTabViewWithItems:(NSArray *(^)())tabViewItems;

- (void)animateCursorTo:(NSInteger)index;
@end
