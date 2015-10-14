//
//  DKTabView.m
//  SwipeViewExample
//
//  Created by pan drinking on 15/3/24.
//
//

#import "DKTabView.h"

@interface DKTabView ()

@property(nonatomic, strong) NSArray *tabViewItems;
@property(nonatomic, strong) UIScrollView *scrollView;

@end

@implementation DKTabView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {

    _tabViewItems = [NSArray array];
    _tabViewItemMargin = UIEdgeInsetsZero;
    _layoutStyle = DKTabFillParent;

    _cursorIndex = 0;
    _showCursor = YES;
    _cursorAnimationDuration = 0.4;
    _cursorStyle = DKTabCursorUnderneath;
    _cursorHeight = 2;
    _cursorWrapInset = CGVectorMake(0, 0);

    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];

    self.cursorView = [[UIView alloc] init];
    [self.scrollView addSubview:self.cursorView];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _scrollView.bounds = self.bounds;

    if (_layoutStyle == DKTabFillParent) {
        [self.tabViewItems enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            CGFloat width = CGRectGetWidth(self.frame) / self.self.tabViewItems.count;
            view.frame = (CGRect) {CGPointMake(idx * width, 0), CGSizeMake(width, CGRectGetHeight(self.frame))};
        }];
    } else {
        __block CGFloat contentWidth = self.tabViewItemMargin.left;
        [self.tabViewItems enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            [view sizeToFit];
            CGFloat width = CGRectGetWidth(view.frame);
            CGFloat viewHeight = CGRectGetHeight(self.frame);
            view.frame = (CGRect) {CGPointMake(contentWidth, (viewHeight - CGRectGetHeight(view.frame)) / 2), CGSizeMake(width, CGRectGetHeight(view.frame))};
            contentWidth += (width + self.tabViewItemMargin.left);
        }];

        self.scrollView.contentSize = CGSizeMake(contentWidth, CGRectGetHeight(self.frame));
    }

    [self updateCursorToIndex:self.cursorIndex];
}

- (void)didTapped:(UITapGestureRecognizer *)gesture {

    NSInteger index = gesture.view.tag;
    self.cursorIndex = index;
    [self updateCursorToIndex:index];

    if (self.didTapItemAtIndexBlock) {
        self.didTapItemAtIndexBlock(gesture.view, index);
    }
}

- (void)animateCursorTo:(NSInteger)index {

    [UIView animateWithDuration:_cursorAnimationDuration animations:^{
        if (self.cursorStyle == DKTabCursorUnderneath) {
            CGRect frame = ((UIView *) self.tabViewItems[index]).frame;
            frame.origin.y = CGRectGetHeight(self.frame) - _cursorHeight;
            frame.size = CGSizeMake(frame.size.width, _cursorHeight);
            self.cursorView.frame = frame;
        } else if (self.cursorStyle == DKTabCursorWrap) {
            self.cursorView.frame = CGRectInset(((UIView *) self.tabViewItems[index]).frame, -_cursorWrapInset.dx, -_cursorWrapInset.dx);;
        }

        [self.tabViewItems enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            if (idx != self.cursorIndex) {
                if (self.normalizeTabItemBlock) {
                    self.normalizeTabItemBlock(view, idx);
                }
            }
        }];
    }                completion:^(BOOL finished) {
        [self refreshTabItemState];
    }];

}

- (void)updateCursorToIndex:(NSInteger)index {


    if (index < 0 || index >= self.tabViewItems.count) {
        return;
    }

    self.cursorIndex = index;

    if (!_showCursor) {
        [self refreshTabItemState];
        return;
    }

    [self animateCursorTo:index];

    if (self.scrollView.contentSize.width <= CGRectGetWidth(self.scrollView.frame)) {
        return;
    }

    UIView *selectedView = [self.scrollView viewWithTag:index];
    CGFloat offset = selectedView.frame.origin.x - CGRectGetWidth(self.frame) / 2 + CGRectGetWidth(selectedView.frame) / 2;
    CGFloat maxOffset = self.scrollView.contentSize.width - CGRectGetWidth(self.frame);
    offset = offset > 0 ? (offset > maxOffset ? maxOffset : offset) : 0;
    [self.scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

- (void)refreshTabItemState {
    [self.tabViewItems enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (idx == self.cursorIndex) {
            if (self.hightlightTabItemBlock) {
                self.hightlightTabItemBlock(view, idx);
            }
        } else {
            if (self.normalizeTabItemBlock) {
                self.normalizeTabItemBlock(view, idx);
            }
        }
    }];
}


- (void)buildTabViewWithItems:(NSArray *(^)())tabViewItems {

    NSArray * items = tabViewItems();
    self.tabViewItems = [[NSMutableArray alloc] initWithArray:items];

    for (UIView *view in self.scrollView.subviews) {
        if (view != self.cursorView) {
            [view removeFromSuperview];
        }
    }

    [self.tabViewItems enumerateObjectsUsingBlock:^(UIView *item, NSUInteger idx, BOOL *stop) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapped:)];
        item.userInteractionEnabled = YES;
        item.tag = idx;
        [item addGestureRecognizer:gesture];
        [self.scrollView addSubview:item];
    }];

    self.cursorView.hidden = !_showCursor;
    if (_showCursor) {
        [self updateCursorToIndex:0];
    }

}

@end
