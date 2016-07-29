//
//  MyAlertView.h
//  tabApplication
//
//  Created by KevinShen on 2016/6/24.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomIOSAlertViewDelegate

- (void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
@interface MyAlertView : UIView <CustomIOSAlertViewDelegate>
@property (nonatomic, retain) UIView *dialogView;
@property (nonatomic, retain) UITextView *labelText;
@property (nonatomic, assign) id<CustomIOSAlertViewDelegate> delegate;
@property (nonatomic, retain) NSArray *buttonTitles;
@property (copy) void (^onButtonTouchUpInside)(MyAlertView *alertView, int buttonIndex) ;
- (id)initWithTitle:(NSString *)str setButtonTitles:(NSMutableArray *)buttonTitles ;
- (void)show;
- (void)close;
@end
