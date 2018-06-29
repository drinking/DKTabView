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
    _layoutStyle = DKTabLayoutFill;

    _cursorIndex = 0;
    _showCursor = YES;
    _cursorAnimationDuration = 0.4;
    _cursorStyle = DKTabCursorBottom;
    _cursorHeight = 2;
    _cursorWrapInset = CGVectorMake(0, 0);

    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.scrollsToTop = NO;

    self.cursorView = [[UIView alloc] init];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _scrollView.bounds = self.bounds;

    if (_layoutStyle == DKTabLayoutFill) {
        [self.tabViewItems enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            CGFloat width = CGRectGetWidth(self.frame) / self.self.tabViewItems.count;
            view.frame = (CGRect) {CGPointMake(idx * width, 0), CGSizeMake(width, CGRectGetHeight(self.frame))};
            UILabel *label = [view viewWithTag:10000];
            [label sizeToFit];
            label.center = CGPointMake(width/2, CGRectGetHeight(self.frame)/2);
        }];
    } else {
        __block CGFloat contentWidth = self.tabViewItemMargin.left;
        [self.tabViewItems enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            UILabel *label = [view viewWithTag:10000];
            [label sizeToFit];
            CGRect frame = label.bounds;
            CGFloat width = CGRectGetWidth(frame);
            CGFloat viewHeight = CGRectGetHeight(self.frame);
            view.frame = (CGRect) {CGPointMake(contentWidth, (viewHeight - CGRectGetHeight(frame)) / 2), CGSizeMake(width, CGRectGetHeight(frame))};
            contentWidth += (width + self.tabViewItemMargin.left);
        }];

        self.scrollView.contentSize = CGSizeMake(contentWidth, CGRectGetHeight(self.frame));
    }

    [self updateCursorToIndex:self.cursorIndex withAnimation:NO];

}

- (void)didTapped:(UITapGestureRecognizer *)gesture {

    NSInteger index = gesture.view.tag;
    self.cursorIndex = index;
    [self updateCursorToIndex:index];

    if (self.didTapItemAtIndexBlock) {
        self.didTapItemAtIndexBlock(gesture.view, index);
    }
}

- (void)moveCursorTo:(NSInteger)index withAnimation:(BOOL)animate {

    void (^repositionCursorBlock)(void) = ^{
        if (self.cursorStyle == DKTabCursorBottom) {
            CGRect frame = ((UIView *) self.tabViewItems[index]).frame;
            frame.origin.y = CGRectGetHeight(self.frame) - _cursorHeight;
            frame.size = CGSizeMake(frame.size.width, _cursorHeight);
            self.cursorView.frame = frame;
        } else if (self.cursorStyle == DKTabCursorFill) {
            self.cursorView.frame = CGRectInset(((UIView *) self.tabViewItems[index]).frame, -_cursorWrapInset.dx, -_cursorWrapInset.dx);;
        }else if (self.cursorStyle == DKTabCursorBottomWrap) {
            UIView *container = self.tabViewItems[index];
            CGRect frame = [container viewWithTag:10000].frame;
            frame.origin.y = CGRectGetHeight(self.frame) - _cursorHeight;
            frame.origin.x = container.frame.origin.x + frame.origin.x;
            frame.size = CGSizeMake(frame.size.width, _cursorHeight);
            self.cursorView.frame = frame;
        }

        [self.tabViewItems enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            if (idx != self.cursorIndex) {
                if (self.normalizeTabItemBlock) {
                    self.normalizeTabItemBlock([view viewWithTag:10000], idx);
                }
            }
        }];
    };

    if (!animate) {
        repositionCursorBlock();
        [self refreshTabItemState];
        return;
    }

    [UIView animateWithDuration:_cursorAnimationDuration animations:repositionCursorBlock
                     completion:^(BOOL finished) {
                         [self refreshTabItemState];
                     }];

}

- (void)updateCursorToIndex:(NSInteger)index withAnimation:(BOOL)animate {

    if (index < 0 || index >= self.tabViewItems.count) {
        return;
    }

    self.cursorIndex = index;

    if (!_showCursor) {
        [self refreshTabItemState];
        return;
    }

    [self moveCursorTo:index withAnimation:animate];

    if (self.scrollView.contentSize.width <= CGRectGetWidth(self.scrollView.frame)) {
        return;
    }

    UIView *selectedView = [self.scrollView viewWithTag:index];
    CGFloat offset = selectedView.frame.origin.x - CGRectGetWidth(self.frame) / 2 + CGRectGetWidth(selectedView.frame) / 2;
    CGFloat maxOffset = self.scrollView.contentSize.width - CGRectGetWidth(self.frame);
    offset = offset > 0 ? (offset > maxOffset ? maxOffset : offset) : 0;
    [self.scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

- (void)updateCursorToIndex:(NSInteger)index {
    [self updateCursorToIndex:index withAnimation:YES];
}

- (void)refreshTabItemState {
    [self.tabViewItems enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (idx == self.cursorIndex) {
            if (self.hightlightTabItemBlock) {
                self.hightlightTabItemBlock([view viewWithTag:10000], idx);
            }
        } else {
            if (self.normalizeTabItemBlock) {
                self.normalizeTabItemBlock([view viewWithTag:10000], idx);
            }
        }
    }];
}


- (void)buildTabViewWithItems:(NSArray *(^)())tabViewItems {

    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    if (_showCursor) {
        [self.scrollView addSubview:self.cursorView];
    }
    
    NSMutableArray *items = [@[] mutableCopy];
    [tabViewItems() enumerateObjectsUsingBlock:^(UIView *item, NSUInteger idx, BOOL *stop) {
        item.tag = 10000;
        UIView *containerView = [UIView new];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapped:)];
        containerView.userInteractionEnabled = YES;
        containerView.tag = idx;
        [containerView addGestureRecognizer:gesture];
        [containerView addSubview:item];
        [items addObject:containerView];
        [self.scrollView addSubview:containerView];
    }];
    
    self.tabViewItems = items;

    [self setNeedsLayout];
    [self layoutIfNeeded];

}

@end
