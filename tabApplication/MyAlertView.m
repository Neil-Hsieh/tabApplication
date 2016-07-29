//
//  MyAlertView.m
//  tabApplication
//
//  Created by KevinShen on 2016/6/24.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "MyAlertView.h"
#import "UIView+SDAutoLayout.h"

const static CGFloat kCustomIOSAlertViewDefaultButtonHeight       = 50;
const static CGFloat kCustomIOSAlertViewDefaultButtonSpacerHeight = 1;
const static CGFloat kCustomIOSAlertViewCornerRadius              = 7;
static CGFloat buttonHeight = 0;
static CGFloat buttonSpacerHeight = 0;

@implementation MyAlertView
@synthesize onButtonTouchUpInside;
@synthesize buttonTitles;
@synthesize delegate;
- (id)initWithTitle:(NSString *)str setButtonTitles:(NSMutableArray *)buttonTitle {
    self = [self init];
    buttonTitles = buttonTitle;
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = CGSizeMake(screenSize.width * 0.8, screenSize.width * 0.55);
    self.dialogView = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height)];
    
    
    self.dialogView.backgroundColor = [UIColor whiteColor];
    self.dialogView.layer.cornerRadius = kCustomIOSAlertViewCornerRadius;
    
    
    UILabel *labelText = [UILabel new];
    labelText.textColor = [UIColor grayColor];
    labelText.font = [UIFont systemFontOfSize:18];
    [self.dialogView addSubview:labelText];
    self.labelText = labelText;
    self.labelText.sd_layout
    .widthIs(self.dialogView.bounds.size.width)
    .centerXEqualToView(self.dialogView)
    .centerYIs((self.dialogView.bounds.size.height - buttonHeight - buttonSpacerHeight)/2)
    .autoHeightRatio(0);
    self.labelText.textAlignment = UITextAlignmentCenter; //置中
    self.labelText.text = str;
    
    // There is a line above the button
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.dialogView.bounds.size.height - buttonHeight - buttonSpacerHeight, self.dialogView.bounds.size.width, buttonSpacerHeight)];
    lineView.backgroundColor = [UIColor blackColor];
    [self.dialogView addSubview:lineView];
    
    // Add the buttons too
    [self addButtonsToView:self.dialogView];

    [self addSubview:self.dialogView];
    
    return self;
}

- (void)show
{
    UIView* superview = [UIApplication sharedApplication].keyWindow;

    self.frame = superview.bounds;
     self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [superview addSubview:self];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    
    singleFingerTap.delegate = self;
    [superview addGestureRecognizer:singleFingerTap];
    
    //以下是show動畫
    self.dialogView.layer.opacity = 0.5f;
    self.dialogView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         self.dialogView.layer.opacity = 1.0f;
                         self.dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:NULL
     ];
    
   
}

// Button has been touched
- (void)customIOS7dialogButtonTouchUpInside:(id)sender
{
    //delegate
    if (delegate != NULL) {
        [delegate customIOS7dialogButtonTouchUpInside:self clickedButtonAtIndex:[sender tag]];
    }
    
    //block
    if (onButtonTouchUpInside != NULL) {
        onButtonTouchUpInside(self, (int)[sender tag]);
    }
}

//指定view不touch
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.dialogView]) {
        return NO;
    }
    return YES;
}

//background click
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"background click");
    [self close];
}

- (void)close{

    
    CATransform3D currentTransform = self.dialogView.layer.transform;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat startRotation = [[self.dialogView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
        CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);
        
        self.dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    }
    
    self.dialogView.layer.opacity = 1.0f;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         self.dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         self.dialogView.layer.opacity = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }
     ];
}

// Helper function: add buttons to container
- (void)addButtonsToView: (UIView *)container
{
    
    if (buttonTitles==NULL) { return; }
    
    CGFloat buttonWidth = container.bounds.size.width / [buttonTitles count];
    
    for (int i=0; i<[buttonTitles count]; i++) {
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setFrame:CGRectMake(i * buttonWidth, container.bounds.size.height - buttonHeight, buttonWidth, buttonHeight)];
        [closeButton addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setTag:i];
         closeButton.backgroundColor = [UIColor whiteColor];
        [closeButton setTitle:[buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.5f] forState:UIControlStateHighlighted];
        [closeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        
        //        [closeButton.layer setCornerRadius:kCustomIOSAlertViewCornerRadius];
        UIBezierPath *maskPath;
        if([buttonTitles count] == 1){
            maskPath = [UIBezierPath bezierPathWithRoundedRect:closeButton.bounds byRoundingCorners:( UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(kCustomIOSAlertViewCornerRadius, kCustomIOSAlertViewCornerRadius)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = closeButton.bounds;
            maskLayer.path  = maskPath.CGPath;
            closeButton.layer.mask = maskLayer;
        } else {
            if(i == 0){
                  maskPath = [UIBezierPath bezierPathWithRoundedRect:closeButton.bounds byRoundingCorners:( UIRectCornerBottomLeft ) cornerRadii:CGSizeMake(kCustomIOSAlertViewCornerRadius, kCustomIOSAlertViewCornerRadius)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = closeButton.bounds;
                maskLayer.path  = maskPath.CGPath;
                closeButton.layer.mask = maskLayer;
            }
            else if(i == [buttonTitles count]-1){
                maskPath = [UIBezierPath bezierPathWithRoundedRect:closeButton.bounds byRoundingCorners:( UIRectCornerBottomRight ) cornerRadii:CGSizeMake(kCustomIOSAlertViewCornerRadius, kCustomIOSAlertViewCornerRadius)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = closeButton.bounds;
                maskLayer.path  = maskPath.CGPath;
                closeButton.layer.mask = maskLayer;
            }
        }
      
       
        
        [container addSubview:closeButton];
    }
}


- (CGSize)countScreenSize
{
    if (buttonTitles!=NULL && [buttonTitles count] > 0) {
        buttonHeight       = kCustomIOSAlertViewDefaultButtonHeight;
        buttonSpacerHeight = kCustomIOSAlertViewDefaultButtonSpacerHeight;
    } else {
        buttonHeight = 0;
        buttonSpacerHeight = 0;
    }

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // On iOS7, screen width and height doesn't automatically follow orientation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            CGFloat tmp = screenWidth;
            screenWidth = screenHeight;
            screenHeight = tmp;
        }
    }
    
    return CGSizeMake(screenWidth, screenHeight);
}

@end
