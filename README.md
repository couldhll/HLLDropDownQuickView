# HLLDropDownQuickView

DropDown List View

* One click to select.
* Animation: drop down & high light
* Can control select action using delegate.
* HLLDropDownQuickView extends UIView.

[![](https://raw.github.com/couldhll/HLLDropDownQuickView/master/Screenshot/screenshot1.png)](https://raw.github.com/couldhll/HLLDropDownQuickView/master/Screenshot/screenshot1.png)
[![](https://raw.github.com/couldhll/HLLDropDownQuickView/master/Screenshot/screenshot2.png)](https://raw.github.com/couldhll/HLLDropDownQuickView/master/Screenshot/screenshot2.png)
[![](https://raw.github.com/couldhll/HLLDropDownQuickView/master/Screenshot/screenshot3.png)](https://raw.github.com/couldhll/HLLDropDownQuickView/master/Screenshot/screenshot3.png)

## Installation

### From CocoaPods

Add `pod 'HLLDropDownQuickView'` to your Podfile or `pod 'HLLDropDownQuickView', :head` if you're feeling adventurous.

### Manually

_**Important note if your project doesn't use ARC**: you must add the `-fobjc-arc` compiler flag to `HLLDropDownQuickView.m` in Target Settings > Build Phases > Compile Sources._

* Drag the `HLLDropDownQuickView` folder into your project.
* Import `HLLDropDownQuickView.h`

## Usage

(see sample Xcode project in `/HLLDropDownQuickViewDemo`)

### Setting Data

```objective-c
[dropDownQuickView setSelectionOptions:options withTitles:titles];
```

### Custom Style

_**For exmaple:setting combo style with bold and oblique**_

```objective-c
dropDownQuickView.titleBackgroundImage=[UIImage imageNamed:@"title_background"];
dropDownQuickView.titleFont=[UIFont systemFontOfSize:9];
dropDownQuickView.titleColor=[UIColor redColor];
CGRect frame=dropDownQuickView.titleLabel.frame;
dropDownQuickView.titleLabel.frame=CGRectMake(10, frame.origin.y, frame.size.width, frame.size.height);
dropDownQuickView.optionBackgroundImage=[UIImage imageNamed:@"option_background"];
dropDownQuickView.optionFont=[UIFont systemFontOfSize:9];
dropDownQuickView.optionColor=[UIColor brownColor];
dropDownQuickView.title = @"USD";
```

### Control Select

use `HLLDropDownQuickViewDelegate`

```objective-c
@protocol HLLDropDownQuickViewDelegate <NSObject>

// Selection contains the user selected option or nil if nothing was selected
- (void)dropDownControlView:(HLLDropDownQuickView *)view didFinishWithSelection:(id)selection;

@optional

// You can use this to disable scrolling on a tableView
- (void)dropDownControlViewWillBecomeActive:(HLLDropDownQuickView *)view;

@end
```
