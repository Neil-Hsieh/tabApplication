//
//  ViewController.m
//  tabApplication
//
//  Created by KevinShen on 2016/6/22.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "ViewController.h"
#import "CarbonKit.h"
#import "page1ViewController.h"

@interface ViewController () <CarbonTabSwipeNavigationDelegate>
{
    CarbonTabSwipeNavigation *carbonTabSwipeNavigation;
}
@property (strong, nonatomic) NSMutableArray *pageViewControllers;
@end

@implementation ViewController
@synthesize items;
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"barBackground"]resizableImageWithCapInsets:UIEdgeInsetsMake(30, 0, 30, 0)]];
//    [tempImageView setFrame:self.tableView.frame];
//    self.view.backgroundView = tempImageView;
    //    self.tableView.backgroundColor = [UIColor colorWithRed:0.125 green:0.196 blue:0.274 alpha:1.0];;
    //bar title字體顏色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UIImage *image = [[UIImage imageNamed:@"barBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//     [navBar setBackgroundColor:[UIColor colorWithRed:0.098 green:0.16 blue:0.239 alpha:1.0]];
    NSLog([NSString stringWithFormat:@"%f, %f",image.size.width ,image.size.height]);
    NSLog([NSString stringWithFormat:@"%f, %f",navBar.frame.size.width ,navBar.frame.size.height]);
    
    
    self.pageViewControllers = [NSMutableArray array];
    page1ViewController *pageView1 =[[page1ViewController alloc] initWithNibName:@"page1ViewController" bundle:nil];
    [_pageViewControllers addObject:pageView1];
    
    page1ViewController *pageView2 =[[page1ViewController alloc] initWithNibName:@"page1ViewController" bundle:nil];
    [_pageViewControllers addObject:pageView2];
    
    page1ViewController *pageView3 =[[page1ViewController alloc] initWithNibName:@"page1ViewController" bundle:nil];
    [_pageViewControllers addObject:pageView3];
    
    
//    items = @[@"Home",@"Hourglass", @"Three"];
    
        carbonTabSwipeNavigation =
    [[CarbonTabSwipeNavigation alloc] initWithItems:items delegate:self];
    [carbonTabSwipeNavigation insertIntoRootViewController:self];
    
    [self style];
    
    
}
- (void)style {
    
    UIColor *color = [UIColor colorWithRed:24.0 / 255 green:75.0 / 255 blue:152.0 / 255 alpha:1];

    
    carbonTabSwipeNavigation.toolbar.translucent = NO;
    [carbonTabSwipeNavigation setIndicatorColor:color];
    //設定tab多於寬度 讓slide可滑動
    [carbonTabSwipeNavigation setTabExtraWidth:0];
    
    CGRect fullScreenBounds=[[UIScreen mainScreen] bounds];//取得收機畫面大小
    CGFloat width = fullScreenBounds.size.width / items.count;
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:width forSegmentAtIndex:0];
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:width forSegmentAtIndex:1];
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:width forSegmentAtIndex:2];
    
    // Custimize segmented control
    [carbonTabSwipeNavigation setNormalColor:[[UIColor blueColor] colorWithAlphaComponent:0.6]
                                        font:[UIFont boldSystemFontOfSize:14]];
    [carbonTabSwipeNavigation setSelectedColor:[UIColor blueColor] font:[UIFont boldSystemFontOfSize:14]];
    
   
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// delegate
- (UIViewController *)carbonTabSwipeNavigation:(CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                         viewControllerAtIndex:(NSUInteger)index {
    index = index %3 ;
    page1ViewController *pageView = _pageViewControllers[index];
    
    pageView.stringValue = [NSString stringWithFormat:@"%d",index];
 
    return pageView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
// optional
- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                 willMoveAtIndex:(NSUInteger)index {

     self.title = items[index];
}

- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                  didMoveAtIndex:(NSUInteger)index {
    NSLog(@"Did move at index: %ld", index);
}
@end
