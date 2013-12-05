//
//  HLLViewController.m
//  HLLDropDownQuickViewDemo
//
//  Created by CouldHll on 13-11-26.
//  Copyright (c) 2013年 CouldHll. All rights reserved.
//

#import "HLLViewController.h"

@interface HLLViewController ()

@end

@implementation HLLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // init dropdown quick view
    HLLDropDownQuickView *dropDownQuickView = [[HLLDropDownQuickView alloc] initWithFrame:CGRectMake(100, 100, 77, 37)];
    dropDownQuickView.titleBackgroundImage=[UIImage imageNamed:@"title_background"];
    dropDownQuickView.titleFont=[UIFont systemFontOfSize:9];
    dropDownQuickView.titleColor=[UIColor redColor];
    CGRect frame=dropDownQuickView.titleLabel.frame;
    dropDownQuickView.titleLabel.frame=CGRectMake(10, frame.origin.y, frame.size.width, frame.size.height);
    dropDownQuickView.optionBackgroundImage=[UIImage imageNamed:@"option_background"];
    dropDownQuickView.optionFont=[UIFont systemFontOfSize:9];
    dropDownQuickView.optionColor=[UIColor brownColor];
    dropDownQuickView.title = @"USD";
    dropDownQuickView.delegate=self;
    
    // add title&option
    NSMutableArray *options = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:0];
    for (int i=1; i<=10; i++) {
        [options addObject:[NSNumber numberWithInt:i]];
        [titles addObject:[NSString stringWithFormat:@"Option %d", i]];
    }
    [dropDownQuickView setSelectionOptions:options withTitles:titles];
    
    [self.view addSubview:dropDownQuickView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Drop Down Selector Delegate
- (void)dropDownControlViewWillBecomeActive:(HLLDropDownQuickView *)view
{
    
}

- (void)dropDownControlView:(HLLDropDownQuickView *)view didFinishWithSelection:(id)selection
{
    view.title = [NSString stringWithFormat:@"Selected: %@", selection ? : @"-"];
}

@end
