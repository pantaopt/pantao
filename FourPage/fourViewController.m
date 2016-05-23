//
//  fourViewController.m
//  weibo_myTest
//
//  Created by wkr on 16/3/14.
//  Copyright © 2016年 wkr. All rights reserved.
//

#import "fourViewController.h"
#import "EMSDK.h"
#import "launchViewController.h"
#import "UIImageView+loadImageUrlStr.h"

#import "JZMultiChoicesCircleButton.h"

@interface fourViewController ()

@property (nonatomic, strong) UIScrollView *mainScrollView;// 主scrollview

@property (nonatomic, strong) UIImageView *headerImage;// 头像

@property (nonatomic, strong) UILabel *nickName;// 昵称

@property (nonatomic, strong) UILabel *descriptions;// 个人简介

@property (nonatomic)JZMultiChoicesCircleButton *NewBTN ;

@end

@implementation fourViewController
@synthesize NewBTN;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = bgColor;
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self config];
    
    [self quit];
    
    [self ChoicesCircleButton];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateWeiboInfo) name:@"updateWeiboInfo" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickTabBarItem:) name:@"clickTabBarItem" object:nil];
}

#pragma mark circleBtn
- (void)clickTabBarItem:(NSNotification *)n{
    UITabBarItem *Item = [n object];
    UITabBar *tb = self.tabBarController.tabBar;
    NSArray *items = tb.items;
    NSLog(@"%lu",(unsigned long)[items indexOfObject:Item]);
    if ([items indexOfObject:Item] != 3) {
        [NewBTN removeFromSuperview];
    }else{
        [self.tabBarController.view addSubview:NewBTN];
    }
}

- (void)ButtonOne{
    NSLog(@"BUtton 1 Seleted");
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(SuccessLoadData) userInfo:nil repeats:NO];
}

- (void)ButtonTwo{
    NSLog(@"BUtton 2 Seleted");
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(SuccessLoadData) userInfo:nil repeats:NO];
}

- (void)ButtonThree{
    NSLog(@"BUtton 3 Seleted");
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(ErrorLoadData) userInfo:nil repeats:NO];
}

- (void)ButtonFour{
    NSLog(@"BUtton 4 Seleted");
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(ErrorLoadData) userInfo:nil repeats:NO];
}

- (void)SuccessLoadData
{
    [NewBTN SuccessCallBackWithMessage:@"YES!"];
}
- (void)ErrorLoadData
{
    [NewBTN FailedCallBackWithMessage:@"NO..."];
}

- (void)updateWeiboInfo
{
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:[[global shareManager].weiboUserInfoDict valueForKey:@"profile_image_url"]]];
    _nickName.text = [[global shareManager].weiboUserInfoDict valueForKey:@"name"];
    _descriptions.text = [NSString stringWithFormat:@"个人简介:%@",[[global shareManager].weiboUserInfoDict valueForKey:@"description"]];
}

- (void)ChoicesCircleButton{
    NSArray *IconArray = [NSArray arrayWithObjects: [UIImage imageNamed:@"SendRound"],[UIImage imageNamed:@"CompleteRound"],[UIImage imageNamed:@"CalenderRound"],[UIImage imageNamed:@"MarkRound"],nil];
    NSArray *TextArray = [NSArray arrayWithObjects: [NSString stringWithFormat:@"Send"],[NSString stringWithFormat:@"Complete"],[NSString stringWithFormat:@"Calender"],[NSString stringWithFormat:@"Mark"], nil];
    NSArray *TargetArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"ButtonOne"],[NSString stringWithFormat:@"ButtonTwo"],[NSString stringWithFormat:@"ButtonThree"],[NSString stringWithFormat:@"ButtonFour"] ,nil];
    
    NewBTN = [[JZMultiChoicesCircleButton alloc] initWithCenterPoint:CGPointMake(self.view.frame.size.width / 2 , 240*aspect )
                                                          ButtonIcon:[UIImage imageNamed:@"send"]
                                                         SmallRadius:30.0f
                                                           BigRadius:120.0f
                                                        ButtonNumber:4
                                                          ButtonIcon:IconArray
                                                          ButtonText:TextArray
                                                        ButtonTarget:TargetArray
                                                         UseParallex:YES
                                                   ParallaxParameter:100
                                               RespondViewController:self];
    [self.tabBarController.view addSubview:NewBTN];

}

#pragma mark 退出登录按钮
- (void)quit{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 80*aspect, 30*aspect);
    btn.center = self.view.center;
    [self.view addSubview:btn];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    btn.backgroundColor = mainColor;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.equalTo(@(30*aspect));
        make.width.equalTo(@(80*aspect));
    }];
}

#pragma mark ui控件的创建初始化
- (void)config{
    _mainScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_mainScrollView];
    _mainScrollView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.0f];
    
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, UISCREENWIDTH, 20)];
    statusBarView.backgroundColor=mainColor;
    [_mainScrollView addSubview:statusBarView];
    
    // ///上底view
    UIView *topBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, 200*aspect)];
    [_mainScrollView addSubview:topBottomView];
    topBottomView.backgroundColor = mainColor;
    [topBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.equalTo(@(200*aspect));
    }];
    
    // ///头像
    _headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(UISCREENWIDTH/2-35*aspect, 65*aspect, 70*aspect, 70*aspect)];
    [topBottomView addSubview:_headerImage];
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:[[global shareManager].weiboUserInfoDict valueForKey:@"profile_image_url"]]];
    _headerImage.layer.masksToBounds = YES;
    _headerImage.layer.cornerRadius = 35*aspect;
    _headerImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _headerImage.layer.borderWidth = 1;
    [_headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topBottomView.mas_centerX);
        make.centerY.equalTo(topBottomView.mas_centerY);
        make.height.equalTo(@(70*aspect));
        make.width.equalTo(@(70*aspect));
    }];
    
    //    [headerImage loadImageUrlStr:[[global shareManager].weiboUserInfoDict valueForKey:@"profile_image_url"] placeHolderImageName:nil radius:35*aspect];
    
    _nickName = [[UILabel alloc]initWithFrame:CGRectMake(0, _headerImage.frame.origin.y+_headerImage.frame.size.height, UISCREENWIDTH, 40*aspect)];
    _nickName.textColor = [UIColor whiteColor];
    _nickName.textAlignment = NSTextAlignmentCenter;
    _nickName.font = [UIFont systemFontOfSize:16*aspect];
    _nickName.text = [[global shareManager].weiboUserInfoDict valueForKey:@"name"];
    [topBottomView addSubview:_nickName];
    [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.width.equalTo(self.view.mas_width);
        make.top.equalTo(_headerImage.mas_bottom);
        make.height.equalTo(@(40*aspect));
    }];
    
    _descriptions = [[UILabel alloc]initWithFrame:CGRectMake(0, _nickName.frame.origin.y+_nickName.frame.size.height, UISCREENWIDTH, 25*aspect)];
    _descriptions.textColor = [UIColor whiteColor];
    _descriptions.textAlignment = NSTextAlignmentCenter;
    _descriptions.font = [UIFont systemFontOfSize:14*aspect];
    _descriptions.text = [NSString stringWithFormat:@"个人简介:%@",[[global shareManager].weiboUserInfoDict valueForKey:@"description"]];
    [topBottomView addSubview:_descriptions];
    [_descriptions mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.width.equalTo(self.view.mas_width);
        make.top.equalTo(_nickName.mas_bottom);
        make.height.equalTo(@(25*aspect));
    }];
    
    _mainScrollView.contentSize = CGSizeMake(UISCREENWIDTH, topBottomView.frame.origin.y+topBottomView.frame.size.height+20*aspect);
}


- (void)logout
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"islogin"] isEqualToString:@"weibo"]){
        [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"islogin"];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc]initWithRootViewController:[launchViewController new]];
    }else{
        EMError *error = [[EMClient sharedClient] logout:YES];
        if (!error) {
            [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"islogin"];
            DSToast *toast = [[DSToast alloc] initWithText:@"已退出"];
            [toast showInView:self.view showType:DSToastShowTypeCenter];
            [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc]initWithRootViewController:[launchViewController new]];
            //         [self presentViewController: [[UINavigationController alloc]initWithRootViewController:[launchViewController new]] animated:NO completion:nil];
        }
    }
}


@end
