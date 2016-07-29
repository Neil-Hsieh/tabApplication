//
//  SlideMenuUIView.m
//  tabApplication
//
//  Created by KevinShen on 2016/6/22.
//  Copyright © 2016年 mocacube. All rights reserved.
//

#import "SlideMenuUIView.h"
#import "AppDelegate.h"
@implementation SlideMenuUIView{
    NSMutableArray *MenuArray;  // 選單內容用
    UITableView *MenuTableView; // 選單顯示用
    int targetPageID;           // 目標 tab ID
}

+ (instancetype) sharedInstance
{
    static SlideMenuUIView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SlideMenuUIView alloc] init];
    });
    return instance;
}

-(id)init{
    self=[super init];
    if (self) {
        //設定Menu 資料來源
        MenuArray=[[NSMutableArray alloc] initWithCapacity:50];
        [MenuArray addObject:@"第一項"];
        [MenuArray addObject:@"第二項"];
        [MenuArray addObject:@"第三項"];
        [MenuArray addObject:@"第四項"];
        //預設畫面比例
        self.MenuScreenScale=0.8;
        //預設頁面切換時間
        self.SwichingPageSpeed=0.25;
        //預設下次畫面切換為不切換
        targetPageID=999;
        
        //設定基本大小
        CGRect fullScreenBounds=[[UIScreen mainScreen] bounds];//取得收機畫面大小
        self.frame=CGRectMake(-fullScreenBounds.size.width*self.MenuScreenScale,[[UIApplication sharedApplication] statusBarFrame].size.height , fullScreenBounds.size.width*self.MenuScreenScale, fullScreenBounds.size.height);
        self.backgroundColor=[UIColor lightGrayColor];
        UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(44, 0, self.frame.size.width-44, 42)];
        titleLabel.text=@"選單項目";
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        titleLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:titleLabel];
        
        
//        //        收Menu 的 Button
//        UIButton *MenuButton=[UIButton buttonWithType:UIButtonTypeCustom];
//        MenuButton.frame=CGRectMake(0,0, 44, 42);
//        [MenuButton setImage:[UIImage imageNamed:@"first"] forState:UIControlStateNormal];
//        [MenuButton addTarget:self action:@selector(callMenu) forControlEvents:UIControlEventTouchUpInside];//按下去時呼叫 callMenu 方法來收起 Menu
//      
//        [self addSubview:MenuButton];
        [self addMenu];
        
        
    }
    return self;
    
    
}


-(void)addMenu{
    
    //設定Table 代理人
    MenuTableView=[[UITableView alloc] init];
    MenuTableView.dataSource=self;
    MenuTableView.delegate=self;
    MenuTableView.frame=CGRectMake(0, 44, self.frame.size.width, self.frame.size.height-44);
    MenuTableView.allowsSelection=YES;
    [self addSubview:MenuTableView];
    //顯示在最上層
    self.layer.zPosition = 1;
}


-(void)callMenu{
    
    [UIView beginAnimations:@"inMenu"context:nil];
    [UIView setAnimationDuration:self.SwichingPageSpeed];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(SwichingPage)];
    
    
    //    設定選單完成時的畫面
    CGRect fullScreenBounds=[[UIScreen mainScreen] bounds];//取得畫面大小
    if (self.frame.origin.x==0) {//如果選單是在0,0 表示選單已出現要收起選單
        self.frame=CGRectMake(-fullScreenBounds.size.width*self.MenuScreenScale, [[UIApplication sharedApplication] statusBarFrame].size.height, fullScreenBounds.size.width*self.MenuScreenScale, fullScreenBounds.size.height);
    }else{
        targetPageID=999;//選單滑出時重設目標
        self.frame=CGRectMake(0, [[UIApplication sharedApplication] statusBarFrame].size.height, fullScreenBounds.size.width*self.MenuScreenScale, fullScreenBounds.size.height);
    }
    [UIView commitAnimations];
}

-(void)closeMenu{
    
    [UIView beginAnimations:@"inMenu"context:nil];
    [UIView setAnimationDuration:self.SwichingPageSpeed];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(SwichingPage)];
    
    CGRect fullScreenBounds=[[UIScreen mainScreen] bounds];//取得畫面大小
        self.frame=CGRectMake(-fullScreenBounds.size.width*self.MenuScreenScale, [[UIApplication sharedApplication] statusBarFrame].size.height, fullScreenBounds.size.width*self.MenuScreenScale, fullScreenBounds.size.height);
  
    [UIView commitAnimations];
}

-(void)openMenu{
    
    [UIView beginAnimations:@"inMenu"context:nil];
    [UIView setAnimationDuration:self.SwichingPageSpeed];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(SwichingPage)];
    
    
    //    設定選單完成時的畫面
    CGRect fullScreenBounds=[[UIScreen mainScreen] bounds];//取得畫面大小


        self.frame=CGRectMake(0, [[UIApplication sharedApplication] statusBarFrame].size.height, fullScreenBounds.size.width*self.MenuScreenScale, fullScreenBounds.size.height);
    
    [UIView commitAnimations];
}

-(CGFloat)getWidth {
    return self.frame.origin.x;
}

-(void)SwichingPage{
    if (targetPageID!=999) {//如果是選單出現時，不需要在完成動畫時切換tab
        AppDelegate *AppDele =(AppDelegate*)[[UIApplication sharedApplication] delegate];
        [((UITabBarController *)AppDele.window.rootViewController) setSelectedIndex:targetPageID];

    }
}



#pragma -mark TableView Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return MenuArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *myCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Menu"];
    myCell.textLabel.text=[MenuArray objectAtIndex:indexPath.row];
    [myCell.textLabel setTextAlignment:NSTextAlignmentLeft];
    myCell.imageView.image=[UIImage imageNamed:@"icon_menu.png"];
    
    return myCell;
}

#pragma mark -UITableDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self callMenu];
    targetPageID=indexPath.row;//設定目標 tab ID
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end

