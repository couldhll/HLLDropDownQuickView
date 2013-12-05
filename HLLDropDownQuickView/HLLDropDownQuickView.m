//
//  HLLDropDownQuickView.m
//  HLLDropDownQuickView
//
//  Created by CouldHll on 13-11-26.
//  Copyright (c) 2013年 CouldHll. All rights reserved.
//

#import "HLLDropDownQuickView.h"

#import <QuartzCore/QuartzCore.h>

#define kOptionHeight 37
#define kOptionSpacing 1
#define kAnimationDuration 0.2

@interface HLLDropDownQuickView ()
{

    
    
    CGRect mBaseFrame;
    
    // Configuration
    NSArray *mSelectionOptions, *mSelectionTitles;
    
    NSMutableArray *mSelectionCells;
    
    // Control state
    BOOL mControlIsActive;
    NSInteger mSelectionIndex;
    NSInteger mPreviousSelectionIndex;
}

@end

@implementation HLLDropDownQuickView

@synthesize titleBackgroundImageView;
@synthesize titleLabel;

@synthesize titleBackgroundImage;
@synthesize titleFont;
@synthesize titleColor;

@synthesize optionBackgroundImage;
@synthesize optionFont;
@synthesize optionColor;

#pragma mark - Property

- (void)setTitleBackgroundImage:(UIImage *)image
{
    titleBackgroundImage=image;
    titleBackgroundImageView.image=titleBackgroundImage;
}

- (void)setTitleFont:(UIFont *)font
{
    optionFont=font;
    [titleLabel setFont:optionFont];
}

- (void)setTitleColor:(UIColor *)color
{
    titleColor=color;
    [titleLabel setTextColor:titleColor];
}

#pragma mark - Init

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    // init frame
    mBaseFrame = self.frame;
    
    // init title background
    titleBackgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:titleBackgroundImageView];
    
    // Title
    titleLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 5, 0)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:titleLabel];
}


#pragma mark - Accessors

- (void)setTitle:(NSString *)title {
    _title = title;
    titleLabel.text = title;
}


#pragma mark - Configuration

- (void)setSelectionOptions:(NSArray *)selectionOptions withTitles:(NSArray *)selectionOptionTitles {
    if ([selectionOptions count] != [selectionOptionTitles count]) {
        [NSException raise:NSInternalInconsistencyException format:@"selectionOptions and selectionOptionTitles must contain the same number of objects"];
    }
    mSelectionOptions = selectionOptions;
    mSelectionTitles = selectionOptionTitles;
    mSelectionCells = nil;
}


#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] != 1)
        return;
    
    UITouch *touch = [touches anyObject];
    if (CGRectContainsPoint(self.bounds, [touch locationInView:self])) {
        [self activateControl];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] != 1)
        return;
    
    UITouch *touch = [touches anyObject];
    
    // Calculate the selection index
    CGPoint location = [touch locationInView:self];
    if ((CGRectContainsPoint(self.bounds, location)) && (location.y > mBaseFrame.size.height)) {
        mSelectionIndex = (location.y - mBaseFrame.size.height - kOptionSpacing) / (kOptionHeight + kOptionSpacing);
    } else {
        mSelectionIndex = NSNotFound;
    }
    
    if (mSelectionIndex == mPreviousSelectionIndex)
        return;
    
    // Selection animation
    if (mSelectionIndex != NSNotFound) {
        UIView *cell = [mSelectionCells objectAtIndex:mSelectionIndex];
        [UIView animateWithDuration:kAnimationDuration animations:^{
            cell.frame = CGRectInset(cell.frame, -6, 0);
        }];
    }
    if (mPreviousSelectionIndex != NSNotFound) {
        UIView *cell = [mSelectionCells objectAtIndex:mPreviousSelectionIndex];
        [UIView animateWithDuration:kAnimationDuration animations:^{
            cell.frame = CGRectInset(cell.frame, 6, 0);
        }];
    }
    mPreviousSelectionIndex = mSelectionIndex;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (mControlIsActive) {
        [self inactivateControl];
        if (mSelectionIndex < [mSelectionOptions count]) {
            [self.delegate dropDownControlView:self didFinishWithSelection:[mSelectionOptions objectAtIndex:mSelectionIndex]];
        } else {
            [self.delegate dropDownControlView:self didFinishWithSelection:nil];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (mControlIsActive) {
        [self inactivateControl];
    }
}

#pragma mark - View Transformation

- (CATransform3D)contractedTransorm {
    CATransform3D t = CATransform3DIdentity;
    t = CATransform3DRotate(t, M_PI / 2, 1, 0, 0);
    t.m34 = -1.0/50;
    return t;
}

#pragma mark - Control Activation / Deactivation

- (void)activateControl {
    mControlIsActive = YES;
    
    mSelectionIndex = NSNotFound;
    mPreviousSelectionIndex = NSNotFound;
    
    if ([self.delegate respondsToSelector:@selector(dropDownControlViewWillBecomeActive:)]) {
        [self.delegate dropDownControlViewWillBecomeActive:self];
    }
    
    // Prepare the selection cells
    if (mSelectionCells == nil) {
        mSelectionCells = [NSMutableArray arrayWithCapacity:0];
        for (int i=0; i < [mSelectionTitles count]; i++) {
            UIImageView *newCell = [[UIImageView alloc] initWithImage:optionBackgroundImage];
            newCell.frame = CGRectMake(0, mBaseFrame.size.height + (i * kOptionHeight + kOptionSpacing) + kOptionSpacing, mBaseFrame.size.width, kOptionHeight);
            newCell.layer.anchorPoint = CGPointMake(0.5, 0.0);
            newCell.layer.transform = [self contractedTransorm];
            //newCell.alpha = 0;
            
            UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectInset(newCell.bounds, 10, 0)];
            newLabel.font = optionFont;
            newLabel.backgroundColor = [UIColor clearColor];
            newLabel.textColor = optionColor;
            newLabel.text = [mSelectionTitles objectAtIndex:i];
            [newCell addSubview:newLabel];
            
            [self addSubview:newCell];
            [mSelectionCells addObject:newCell];
        }
    }
    
    // Expand our frame
    CGRect newFrame = mBaseFrame;
    newFrame.size.height += [mSelectionOptions count] * (kOptionHeight + kOptionSpacing);
    self.frame = newFrame;
    
    // Show selection cells animated
    int count = (int)[mSelectionCells count];
    for (int i = 0; i < count; i++) {
        UIView *cell = [mSelectionCells objectAtIndex:i];
        cell.alpha = 1.0;
        [UIView animateWithDuration:kAnimationDuration delay:(i * kAnimationDuration / count) options:0 animations:^{
            CGRect destinationFrame = CGRectMake(0, mBaseFrame.size.height + i * (kOptionHeight + kOptionSpacing) + kOptionSpacing, mBaseFrame.size.width, kOptionHeight);
            cell.frame = destinationFrame;
            cell.layer.transform = CATransform3DIdentity;
        } completion:nil];
    }
}

- (void)inactivateControl {
    mControlIsActive = NO;
    
    [self.delegate dropDownControlView:self didFinishWithSelection:nil];
    
    int count = (int)[mSelectionCells count];
    for (int i = count - 1; i >= 0; i--) {
        UIView *cell = [mSelectionCells objectAtIndex:i];
        [UIView animateWithDuration:kAnimationDuration delay:((count - 1 - i) * kAnimationDuration / count) options:0 animations:^{
            cell.frame = CGRectMake(0, mBaseFrame.size.height + (i * kOptionHeight + kOptionSpacing) + kOptionSpacing, mBaseFrame.size.width, mBaseFrame.size.height);
            cell.layer.transform = [self contractedTransorm];
        } completion:^(BOOL completed){
            cell.alpha = 0;
            if (i == 0) {
                self.frame = mBaseFrame;
            }
        }];
    }
}

@end
