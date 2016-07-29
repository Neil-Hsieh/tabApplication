//
//  SecondViewController.m
//  tabApplication
//
//  Created by KevinShen on 2016/6/22.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "SecondViewController.h"
#import "ViewController.h"
#import "CustomIOSAlertView.h"
#import "UIView+SDAutoLayout.h"
@interface SecondViewController ()
{
     double oldPointX;
}
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation SecondViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _button.backgroundColor = [UIColor blueColor];
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

-(void)callMenu{
    //    呼叫目錄選單出現
    [self.Menu callMenu];

}

- (IBAction)btnOn:(id)sender {
    // Here we need to pass a full frame
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self createDemoView]];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Close", @"Sure", nil]];
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
    
    
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    [self postHttp];
//    [self getHttp];
    [alertView close];
}

- (void) getHttp {
    
    NSString *url = [NSString stringWithFormat:@"http://demo.cctech-support.com/icarry-as/api/showVendorList?id=11&idType=G&longitude=0&latitude=0&page=1&per_page=10"];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url ]];
    
    // 发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (connectionError) { // 比如请求超时
            NSLog(@"----请求失败");
        } else {
            // 解析服务器返回的数据
//            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //利用的方式取得Json資料
            NSDictionary* jsonObj =
            [NSJSONSerialization JSONObjectWithData:data
                                            options:NSJSONReadingMutableContainers
                                              error:nil];
            
            //是object就用String接
            NSLog(@"vendorList = %@",[jsonObj objectForKey:@"vendorList"]);
            //是Array就用Array接
            NSArray *jsonobj2 = [jsonObj objectForKey:@"vendorList"];
            
            
            //迭代的列出所有Json資料中的Key與Value
            [jsonobj2 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                NSDictionary* array1 = [jsonobj2 objectAtIndex:idx];
                
                [array1 enumerateKeysAndObjectsUsingBlock:^(id key,id obj,BOOL *stop){
                    NSLog(@"key= %@ , Value = %@ ",key,obj);
                }];
            }];

        }
        
    }];

}

- (void) postHttp{
    
    NSString *url = [NSString stringWithFormat:@"http://demo.cctech-support.com/icarry-as/api/auth"];

    // 创建请求对象
    NSMutableURLRequest *reuqest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // 更改请求方法
    reuqest.HTTPMethod = @"POST";
    // 设置请求头,返回类型
    [reuqest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 参数拼接
    NSDictionary *parameter = @{@"au_version": @"1.8", @"au_wechat_no": @"ogHyujlDreQDv6DbT958RG0xGAVw"};

    NSData *data = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:nil];

    // 因为需要对body体进行加密所以先把data转化成字符串，如果不加密可略过次步
    NSString *bodyString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // NSLog(@"加密前 %@",bodyString);
    // 对body体进行加密
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    // NSLog(@"加密後 %@",bodyData);
    reuqest.HTTPBody = bodyData;
    //设置请求超时
    reuqest.timeoutInterval = 3;

    // 发送请求
    [NSURLConnection sendAsynchronousRequest:reuqest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) { // 比如请求超时
            NSLog(@"----请求失败");
        } else {
            NSLog(@"------%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }
    }];
    
    

    
}



- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  290, 200)];
    
    
    demoView.backgroundColor = [UIColor blueColor];
//    demoView.layer.cornerRadius = 7;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:demoView.bounds byRoundingCorners:( UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(7.0, 7.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = demoView.bounds;
    maskLayer.path  = maskPath.CGPath;
    
    demoView.layer.mask = maskLayer;
    return demoView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
