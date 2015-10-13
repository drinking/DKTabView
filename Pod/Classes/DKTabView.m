//
//  DKTabView.m
//  SwipeViewExample
//
//  Created by pan drinking on 15/3/24.
//
//

#import "DKTabView.h"

@interface DKTabView () <DKTabViewDelegate>

@property(nonatomic, strong) NSArray *tabViewItems;
@property(nonatomic, assign) NSInteger cursorIndex;
@property(nonatomic, strong) UIView *cursorView;
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

    _tabViewItems = [[NSArray alloc] init];
    _cursorIndex = 0;
    _margin = UIEdgeInsetsZero;
    _layoutStyle = DKTABFILLPARENT;

    _showCursor = YES;
    _cursorAnimationDuration = 0.4;
    _cursorStyle = DKTABCURSORUNDERNEATH;

    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];

    self.cursorView = [[UIView alloc] init];
    self.cursorView.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:self.cursorView];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _scrollView.bounds = self.bounds;

    if (_layoutStyle == DKTABFILLPARENT) {
        [self.tabViewItems enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            CGFloat width = CGRectGetWidth(self.frame) / self.self.tabViewItems.count;
            view.frame = (CGRect) {CGPointMake(idx * width, 0), CGSizeMake(width, CGRectGetHeight(self.frame))};
        }];
    } else {
        __block CGFloat contentWidth = self.margin.left;
        [self.tabViewItems enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            [view sizeToFit];
            CGFloat width = CGRectGetWidth(view.frame);
            CGFloat viewHeight = CGRectGetHeight(self.frame);
            view.frame = (CGRect) {CGPointMake(contentWidth, (viewHeight - CGRectGetHeight(view.frame))/2), CGSizeMake(width, CGRectGetHeight(view.frame))};
            contentWidth += (width + self.margin.left);
        }];

        self.scrollView.contentSize = CGSizeMake(contentWidth, CGRectGetHeight(self.frame));
    }

    [self updateCursorTo:self.cursorIndex];
}

- (void)didTapped:(UITapGestureRecognizer *)gesture {

    NSInteger index = gesture.view.tag;
    self.cursorIndex = index;
    [self animateCursorTo:index];

    if (self.delegate && [self.delegate respondsToSelector:@selector(tapView:didSelectItemAtIndex:)]) {
        [self.delegate tapView:self didSelectItemAtIndex:index];
    }

}

- (void)updateCursorTo:(NSInteger)index {

    if (!_showCursor) {
        return;
    }

    if ([self.tabViewItems count] == 0 || index >= self.tabViewItems.count) {
        return;
    }

    CGFloat cursorHeight = 2;

    if (self.cursorStyle == DKTABCURSORUNDERNEATH) {
        CGRect frame = ((UIView *) self.tabViewItems[index]).frame;
        frame.origin.y = CGRectGetMaxY(frame) - cursorHeight;
        frame.size = CGSizeMake(frame.size.width, cursorHeight);
        self.cursorView.frame = frame;
    } else if (self.cursorStyle == DKTABCURSORWRAP) {
        self.cursorView.frame = ((UIView *) self.tabViewItems[index]).frame;
    }

    [self.tabViewItems enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (idx != self.cursorIndex) {
            if (self.normalizeTabItemBlock) {
                self.normalizeTabItemBlock(view);
            }
        }
    }];

}

- (void)animateCursorTo:(NSInteger)index {

    if (!_showCursor) {
        return;
    }

    if (index < 0 || index >= self.tabViewItems.count) {
        return;
    }

    self.cursorIndex = index;

    [UIView animateWithDuration:_cursorAnimationDuration animations:^{
        [self updateCursorTo:index];
    }                completion:^(BOOL finished) {
        [self.tabViewItems enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            if (idx == self.cursorIndex) {
                if (self.hightlightTabItemBlock) {
                    self.hightlightTabItemBlock(view);
                }
            } else {
                if (self.normalizeTabItemBlock) {
                    self.normalizeTabItemBlock(view);
                }
            }
        }];
    }];

    if (self.scrollView.contentSize.width <= CGRectGetWidth(self.scrollView.frame)) {
        return;
    }

    UIView *selectedView = [self.scrollView viewWithTag:index];
    CGFloat offset = selectedView.frame.origin.x - CGRectGetWidth(self.frame) / 2;
    CGFloat maxOffset = self.scrollView.contentSize.width - CGRectGetWidth(self.frame);
    offset = offset > 0 ? (offset > maxOffset ? maxOffset : offset) : 0;
    [self.scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
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
        [self animateCursorTo:0];
    }

}

@end
