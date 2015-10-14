//
//  DKViewController.m
//  DKTabView
//
//  Created by drinking on 10/13/2015.
//  Copyright (c) 2015 drinking. All rights reserved.
//

#import <DKTabView/DKTabView.h>
#import "DKViewController.h"

@interface DKViewController ()

@end

@implementation DKViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor lightGrayColor];

    [self buildTabViewStyle1];
    [self buildTabViewStyle2];
    [self buildTabViewStyle3];
    [self buildTabViewStyle4];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)buildTabViewStyle1 {
    DKTabView *tabView = [[DKTabView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.frame), 44)];
    tabView.layoutStyle = DKTabWrapContent;
    tabView.cursorStyle = DKTabCursorWrap;
    tabView.cursorWrapInset = CGVectorMake(2,2);
    tabView.backgroundColor = [UIColor whiteColor];
    tabView.tabViewItemMargin = UIEdgeInsetsMake(0, 10, 0, 0);
    tabView.cursorView.backgroundColor = [UIColor colorWithRed:110.0/255.0 green:164.0/255.0 blue:175.0/255.0 alpha:1];

    [tabView buildTabViewWithItems:^NSArray * {
        NSArray * titles = @[@"推荐", @"美颜", @"美肤", @"抗氧化", @"去皱纹", @"消水肿"];
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

    tabView.normalizeTabItemBlock = ^(UIView *view,NSInteger index) {
        UILabel *label = (UILabel *) view;
        [label setTextColor:[UIColor blackColor]];
    };

    tabView.hightlightTabItemBlock = ^(UIView *view,NSInteger index) {
        UILabel *label = (UILabel *) view;
        [label setTextColor:[UIColor whiteColor]];
    };

    [self.view addSubview:tabView];
}

- (void)buildTabViewStyle2 {
    DKTabView *tabView = [[DKTabView alloc] initWithFrame:CGRectMake(0, 70, CGRectGetWidth(self.view.frame), 44)];
    tabView.layoutStyle = DKTabWrapContent;
    tabView.cursorStyle = DKTabCursorUnderneath;
    tabView.backgroundColor = [UIColor whiteColor];
    tabView.tabViewItemMargin = UIEdgeInsetsMake(0, 10, 0, 0);
    tabView.cursorView.backgroundColor = [UIColor redColor];

    [tabView buildTabViewWithItems:^NSArray * {
        NSArray * titles = @[@"Apple", @"Apple", @"AppleAppleApple", @"Apple", @"Apple", @"Apple", @"Apple", @"Apple", @"Apple", @"Apple", @"Apple", @"Apple"];
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

    tabView.normalizeTabItemBlock = ^(UIView *view,NSInteger index) {
        UILabel *label = (UILabel *) view;
        [label setTextColor:[UIColor grayColor]];
    };

    tabView.hightlightTabItemBlock = ^(UIView *view,NSInteger index) {
        UILabel *label = (UILabel *) view;
        [label setTextColor:[UIColor redColor]];
    };

    [self.view addSubview:tabView];
}

- (void)buildTabViewStyle3 {
    DKTabView *tabView = [[DKTabView alloc] initWithFrame:CGRectMake(0, 120, CGRectGetWidth(self.view.frame), 44)];
    tabView.layoutStyle = DKTabFillParent;
    tabView.cursorStyle = DKTabCursorUnderneath;
    tabView.backgroundColor = [UIColor whiteColor];
    tabView.cursorView.backgroundColor = [UIColor blackColor];

    [tabView buildTabViewWithItems:^NSArray * {
        NSArray * titles = @[@"NEWS", @"CULTURE", @"BOOKS", @"BUSINESS"];
        NSMutableArray *items = [[NSMutableArray alloc] init];
        for (NSString *title in titles) {
            UILabel *label = [[UILabel alloc] init];
            label.text = title;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
            [items addObject:label];
        }
        return items;
    }];

    [self.view addSubview:tabView];
}

- (void)buildTabViewStyle4 {
    DKTabView *tabView = [[DKTabView alloc] initWithFrame:CGRectMake(0, 170, CGRectGetWidth(self.view.frame), 44)];
    tabView.layoutStyle = DKTabFillParent;
    tabView.showCursor = NO;
    tabView.backgroundColor = [UIColor whiteColor];

    NSArray * imageNames = @[@"home", @"heart", @"refresh", @"locked"];
    NSArray * imageHLNames = @[@"home_hl", @"heart_hl", @"refresh_hl", @"locked_hl"];

    [tabView buildTabViewWithItems:^NSArray * {
        NSMutableArray *items = [[NSMutableArray alloc] init];
        for (NSString *name in imageNames) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
            imageView.contentMode = UIViewContentModeCenter;
            [items addObject:imageView];
        }
        return items;
    }];

    tabView.normalizeTabItemBlock = ^(UIView *view,NSInteger index) {
        UIImageView *imageView = (UIImageView *)view;
        [imageView setImage:[UIImage imageNamed:imageNames[index]]];
    };

    tabView.hightlightTabItemBlock = ^(UIView *view,NSInteger index) {
        UIImageView *imageView = (UIImageView *)view;
        [imageView setImage:[UIImage imageNamed:imageHLNames[index]]];

    };

    tabView.didTapItemAtIndexBlock = ^(UIView *view,NSInteger index) {
        NSString *title = [NSString stringWithFormat:@"Click At Tab %d",index+1];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    };

    [self.view addSubview:tabView];
}
@end
