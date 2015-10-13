//
//  DKViewController.m
//  DKTabView
//
//  Created by drinking on 10/13/2015.
//  Copyright (c) 2015 drinking. All rights reserved.
//

#import <DKTabView/DKTabView.h>
#import "DKViewController.h"

@interface DKViewController () <DKTabViewDelegate>

@end

@implementation DKViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    DKTabView *tabView = [[DKTabView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
    tabView.layoutStyle = DKTABWRAPCONTENT;
    tabView.cursorStyle = DKTABCURSORWRAP;
    tabView.backgroundColor = [UIColor whiteColor];
    tabView.margin = UIEdgeInsetsMake(0,10,0,0);

    [tabView buildTabViewWithItems:^NSArray * {
        NSArray * titles = @[@"Apple", @"Apple", @"AppleAppleApple", @"Apple", @"Apple", @"Apple",@"Apple", @"Apple", @"Apple", @"Apple", @"Apple", @"Apple"];
        NSMutableArray *items = [[NSMutableArray alloc] init];
        for (NSString *title in titles) {
            UILabel *label = [[UILabel alloc] init];
            label.text = title;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor lightGrayColor];
            label.textAlignment = NSTextAlignmentCenter;
            [items addObject:label];
        }
        return items;
    }];

    tabView.normalizeTabItemBlock = ^(UIView *view){
        UILabel *label = (UILabel *)view;
        [label setTextColor:[UIColor grayColor]];
    };

    tabView.hightlightTabItemBlock = ^(UIView *view){
        UILabel *label = (UILabel *)view;
        [label setTextColor:[UIColor whiteColor]];
    };

    [self.view addSubview:tabView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
