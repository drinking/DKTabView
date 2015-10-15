# DKTabView

[![CI Status](http://img.shields.io/travis/drinking/DKTabView.svg?style=flat)](https://travis-ci.org/drinking/DKTabView)
[![Version](https://img.shields.io/cocoapods/v/DKTabView.svg?style=flat)](http://cocoapods.org/pods/DKTabView)
[![License](https://img.shields.io/cocoapods/l/DKTabView.svg?style=flat)](http://cocoapods.org/pods/DKTabView)
[![Platform](https://img.shields.io/cocoapods/p/DKTabView.svg?style=flat)](http://cocoapods.org/pods/DKTabView)

## Demo
![Platform](https://raw.githubusercontent.com/drinking/DKTabView/master/Example/demo/demo.gif)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Here's how to create a custom tab view.
```objc
    DKTabView *tabView = [[DKTabView alloc] initWithFrame:CGRectMake(0, 120, CGRectGetWidth(self.view.frame), 44)];
    tabView.layoutStyle = DKTabFillParent;
    tabView.cursorStyle = DKTabCursorUnderneath;
    tabView.backgroundColor = [UIColor whiteColor];
    tabView.cursorView.backgroundColor = [UIColor blackColor];

    // This method should be invoked at the last step
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
```

## Installation

DKTabView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DKTabView"
```

## Author

drinking, pan49@126.com

## License

DKTabView is available under the MIT license. See the LICENSE file for more info.
