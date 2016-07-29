//
//  NavViewController.m
//  tabApplication
//
//  Created by KevinShen on 2016/6/22.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "NavViewController.h"
#import "ViewController.h"
#import "UHomeTest-Swift.h"

@interface NavViewController ()
{
     CGFloat oldPointX;
}

@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"four";
    UIButton *MenuButton;
    //    建立目錄物件
    self.Menu=[[SlideMenuUIView alloc] init];
//    [self.view addSubview:self.Menu];
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self.Menu];

    UIImage *barAddImage = [[UIImage imageNamed:@"first"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:barAddImage style:UIBarButtonItemStylePlain target:self action:@selector(callMenu)];
    //隱藏下方tab
    //    [self hideTabBar];
    
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
    [panRecognizer setDelegate:self];
    [self.view addGestureRecognizer:panRecognizer]; // add to the view you want to detect swipe on

}

-(void)panRecognized:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        // you might want to do something at the start of the pan
        oldPointX = 0;
    }
    CGPoint currentLocation = [sender locationInView:self.Menu];
    CGPoint distance = [sender translationInView:self.view]; // get distance of pan/swipe in the view in which the gesture recognizer was added

    CGRect frame = self.Menu.frame;
    frame.origin.x += distance.x - oldPointX;
    CGRect fullScreenBounds=[[UIScreen mainScreen] bounds];//取得收機畫面大小

    oldPointX = distance.x;
    
    //不讓menu滑超過原本位置
    if(frame.origin.x > 0){
        frame.origin.x = 0;
        self.Menu.frame = frame;
    }
    //menu未打開時，只讓左邊1/4範圍可滑動
    else if(currentLocation.x < frame.size.width + fullScreenBounds.size.width * 0.25){
        self.Menu.frame = frame;
    }
    //大於1/4不滑動
    else {
        distance.x = 0;
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        [sender cancelsTouchesInView]; // you may or may not need this - check documentation if unsure
        if (distance.x > 0) { // right
//            NSLog(@"user swiped right");
              self.Menu.openMenu;
        } else if (distance.x <= 0) { //left
//            NSLog(@"user swiped left");
              self.Menu.closeMenu;
        }
//        if (distance.y > 0) { // down
//            NSLog(@"user swiped down");
//        } else if (distance.y < 0) { //up
//            NSLog(@"user swiped up");
//        }

    }
}
-(void)callMenu{
    //    呼叫目錄選單出現
    [self.Menu callMenu];
}
- (IBAction)btn:(id)sender {
    ViewController *secondView=[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    
    secondView.items = @[@"Home",@"Hourglass", @"Three"];
        [self.navigationController pushViewController:secondView animated:YES];
    
//       swiftViewController *secondView=[[swiftViewController alloc] initWithNibName:@"swiftViewController" bundle:nil];
//    [self.navigationController pushViewController:secondView animated:YES];
    
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
