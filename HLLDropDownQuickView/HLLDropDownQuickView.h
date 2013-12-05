//
//  HLLDropDownQuickView.h
//  HLLDropDownQuickView
//
//  Created by CouldHll on 13-11-26.
//  Copyright (c) 2013年 CouldHll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class HLLDropDownQuickView;


@protocol HLLDropDownQuickViewDelegate <NSObject>

// Selection contains the user selected option or nil if nothing was selected
- (void)dropDownControlView:(HLLDropDownQuickView *)view didFinishWithSelection:(id)selection;

@optional

// You can use this to disable scrolling on a tableView
- (void)dropDownControlViewWillBecomeActive:(HLLDropDownQuickView *)view;

@end


@interface HLLDropDownQuickView : UIView

@property (assign,nonatomic) id<HLLDropDownQuickViewDelegate> delegate;

@property (strong,nonatomic) NSString *title;

@property (strong,nonatomic) UIImageView *titleBackgroundImageView;
@property (strong,nonatomic) UILabel *titleLabel;

@property (strong,nonatomic) UIImage *titleBackgroundImage;
@property (strong,nonatomic) UIFont *titleFont;
@property (strong,nonatomic) UIColor *titleColor;

@property (strong,nonatomic) UIImage *optionBackgroundImage;
@property (strong,nonatomic) UIFont *optionFont;
@property (strong,nonatomic) UIColor *optionColor;

- (void)initialize;
- (void)setSelectionOptions:(NSArray *)selectionOptions withTitles:(NSArray *)selectionOptionTitles;

@end
