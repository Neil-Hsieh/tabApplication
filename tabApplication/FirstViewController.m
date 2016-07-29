//
//  FirstViewController.m
//  tabApplication
//
//  Created by KevinShen on 2016/6/22.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstViewTableCell.h"
#import "CarbonKit.h"
#import "MyAlertView.h"

@interface FirstViewController ()
{
    CarbonSwipeRefresh *refresh;
    double oldPointX;
}
@property (weak, nonatomic) IBOutlet UITableView *imageTableView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *MenuButton;
    //    建立目錄物件
    self.Menu=[[SlideMenuUIView alloc] init];
    [self.view addSubview:self.Menu];
    
    //    建立頂層目錄 Button
    MenuButton=[UIButton buttonWithType:UIButtonTypeCustom];
    MenuButton.frame=CGRectMake(0,[[UIApplication sharedApplication] statusBarFrame].size.height,  44, 42);
    [MenuButton setImage:[UIImage imageNamed:@"first"] forState:UIControlStateNormal];
    [MenuButton addTarget:self action:@selector(callMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:MenuButton];
    
    
    //隱藏下方tab
//    [self hideTabBar];
    
    self.imageTableView.delegate = self;
    self.imageTableView.dataSource = self;

   
    refresh = [[CarbonSwipeRefresh alloc] initWithScrollView:self.imageTableView];
    [refresh setColors:@[
                         [UIColor blueColor],
                         [UIColor redColor],
                         [UIColor orangeColor],
                         [UIColor greenColor]]
     ]; // default tintColor
    
    // If your ViewController extends to UIViewController
    // else see below
    [self.view addSubview:refresh];
    
    [refresh addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    /**
     設定左右滑動來開關slideMenu
     **/
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
    [panRecognizer setDelegate:self];
    [self.view addGestureRecognizer:panRecognizer]; // add to the view you want to detect swipe on
    
}


/**
 設定左右滑動來開關slideMenu
 **/
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


//下拉到底會觸發
- (void)refresh:(id)sender {
    //結束refresh。不結束的話會一直選轉變色
    [refresh endRefreshing];
    
    
    MyAlertView* alertView = [[MyAlertView alloc] initWithTitle:@"title header" setButtonTitles:[NSMutableArray arrayWithObjects:@"Close", nil]];
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(MyAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    [alertView show];
    


}

- (void)customIOS7dialogButtonTouchUpInside: (MyAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
      NSLog(@"setDelegate: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
    [alertView close];
}

-(void)callMenu{
    //    呼叫目錄選單出現
    [self.Menu callMenu];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)hideTabBar{
    
    
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    self.tabBarController.tabBar.hidden = YES;
    
}


#pragma -mark TableView Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FirstViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstCell" forIndexPath:indexPath];

    cell.labelT.text = [NSString stringWithFormat:@"labe %d",indexPath.row] ;
//    cell.imageT.image=[UIImage imageNamed:@"first"];
    if(cell.imageT.image == nil){
        NSURL *url = [NSURL URLWithString:@"http://img.ivsky.com/img/bizhi/slides/201508/18/september-012.jpg"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError) { // 比如请求超时
//                NSLog(@"----请求失败");
            } else {
//                NSLog(@"----请求成功 ");
            }
            dispatch_async(dispatch_get_main_queue(), ^{
//                FirstViewTableCell *cell = [self.imageTableView cellForRowAtIndexPath:indexPath];
                
                cell.imageT.image=[UIImage imageWithData:data];
            });
            
        
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

@end
