//
//  SlideMenuUIView.h
//  tabApplication
//
//  Created by KevinShen on 2016/6/22.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideMenuUIView : UIView<UITableViewDataSource,UITableViewDelegate>
@property float MenuScreenScale;
@property float SwichingPageSpeed;

+ (instancetype) sharedInstance;

-(void)callMenu;
-(void)openMenu;
-(void)closeMenu;
-(CGFloat)getWidth;
@end
