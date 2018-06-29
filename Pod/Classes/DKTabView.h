//
//  DKTabView.h
//  SwipeViewExample
//
//  Created by pan drinking on 15/3/24.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DKTabLayoutStyle) {
    DKTabLayoutFill, DKTabLayoutWrap
};

typedef NS_ENUM(NSInteger, DKTabCursorStyle) {
    // Cursor stay at bottom, the same width as container
    DKTabCursorBottom,
    // Cursor stay at bottom, the same width as textLabel
    DKTabCursorBottomWrap,
    // Cursor fill the space of textLabel
    DKTabCursorFill
};

typedef void (^dkTabItemAtIndexBlock)(UIView *view, NSInteger index);

@interface DKTabView : UIView

@property(nonatomic, strong) UIView *cursorView;
@property(nonatomic, assign) BOOL showCursor;
@property(nonatomic, assign) CGFloat cursorAnimationDuration;
@property(nonatomic, assign) CGFloat cursorHeight;
@property(nonatomic, assign) DKTabCursorStyle cursorStyle;
@property(nonatomic, assign) CGVector cursorWrapInset;
@property(nonatomic, assign) NSInteger cursorIndex;

@property(nonatomic, assign) UIEdgeInsets tabViewItemMargin;
@property(nonatomic, assign) DKTabLayoutStyle layoutStyle;

@property(nonatomic, copy) dkTabItemAtIndexBlock hightlightTabItemBlock;
@property(nonatomic, copy) dkTabItemAtIndexBlock normalizeTabItemBlock;
@property(nonatomic, copy) dkTabItemAtIndexBlock didTapItemAtIndexBlock;

- (void)buildTabViewWithItems:(NSArray *(^)(void))tabViewItems;

- (void)updateCursorToIndex:(NSInteger)index;
@end
