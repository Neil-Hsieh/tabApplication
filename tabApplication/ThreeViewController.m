//
//  ThreeViewController.m
//  tabApplication
//
//  Created by KevinShen on 2016/7/1.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "ThreeViewController.h"
#import "UHomeTest-Swift.h"
#import "ViewController.h"
#import "ScrollViewController.h"

@interface ThreeViewController ()
@end

@implementation ThreeViewController
- (IBAction)click:(id)sender {
    swiftViewController *secondView=[[swiftViewController alloc] initWithNibName:@"swiftViewController" bundle:nil];

    [self presentViewController:secondView
                       animated:YES
                     completion:nil];

}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView2.contentSize = CGSizeMake(375, 1000);
    [self.scrollView2 setShowsHorizontalScrollIndicator:NO];
    [self.scrollView2 setShowsVerticalScrollIndicator:NO];
    
    self.scrollView.contentSize = CGSizeMake(700, 50);
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    
    UIView *threeSlideView1 = [[[NSBundle mainBundle] loadNibNamed:@"ThreeSlideView1" owner:self options:nil] lastObject];
    [self.scrollView2  addSubview:threeSlideView1];
  
    UIView *containerView = [[[NSBundle mainBundle] loadNibNamed:@"SlideImage" owner:self options:nil] lastObject];
    [self.scrollView  addSubview:containerView];
    UIButton *btn = [containerView viewWithTag:5];
    [btn setTitle:NSLocalizedString(@"aaa", @"dea") forState:UIControlStateNormal];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
