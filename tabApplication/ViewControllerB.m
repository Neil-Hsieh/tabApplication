//
//  ViewControllerB.m
//  tabApplication
//
//  Created by KevinShen on 2016/7/6.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "ViewControllerB.h"

@implementation ViewControllerB

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView.contentSize = CGSizeMake(375, 1000);
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
       self.scrollView.backgroundColor = [UIColor blueColor];
}
@end
