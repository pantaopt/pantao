//
//  mainTabBarViewController.m
//  weibo_myTest
//
//  Created by wkr on 16/3/14.
//  Copyright © 2016年 wkr. All rights reserved.
//

#import "mainTabBarViewController.h"

#import "fristPageViewController.h"
#import "secondViewController.h"
#import "addViewController.h"
#import "thirdViewController.h"
#import "fourViewController.h"

#import "mainNavViewController.h"

#import "tabBar.h"

@interface mainTabBarViewController ()<tabBarDelegate>

@property (nonatomic,weak)UIButton *plus;
@property (nonatomic,weak)FXBlurView *blurView;
@property (nonatomic,weak)UIImageView *text;
@property (nonatomic,weak)UIImageView *ablum;
@property (nonatomic,weak)UIImageView *camera;
@property (nonatomic,weak)UIImageView *sign;
@property (nonatomic,weak)UIImageView *comment;
@property (nonatomic,weak)UIImageView *more;

@property (nonatomic, assign) NSInteger index;

@end

@implementation mainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"weiboUserInfo.plist"];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"islogin"] isEqualToString:@"weibo"]){
        NSString *url= [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@",[[[NSDictionary alloc]initWithContentsOfFile:path] objectForKey:@"access_token"],[[[NSDictionary alloc]initWithContentsOfFile:path] objectForKey:@"uid"]];
        [[netWorking sharedManager] getResultWithParameter:nil url:url successBlock:^(id responseBody) {
//                        NSLog(@"responseBody %@",responseBody);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateWeiboInfo" object:nil];
            [global shareManager].weiboUserInfoDict = [NSDictionary dictionaryWithDictionary:responseBody];
        } failureBlock:^(NSDictionary *error) {
            //            NSLog(@"error %@",error);
        }];
        
    }
    
    // 设置子控制器
    [self setChildController];
    
}

- (void)setChildController
{
    fristPageViewController *fristPage = [[fristPageViewController alloc]init];
    [self addChildViewController:fristPage title:@"video" image:@"tabbar_home" selImage:@"tabbar_home_selected"];
    
    secondViewController *secondPage = [[secondViewController alloc] init];
    [self addChildViewController:secondPage title:@"map" image:@"tabbar_message_center" selImage:@"tabbar_message_center_selected"];
    
    
    thirdViewController *thirdPage = [[thirdViewController alloc] init];
    [self addChildViewController:thirdPage title:@"drawBoard" image:@"tabbar_discover" selImage:@"tabbar_discover_selected"];
    
    
    fourViewController *fourPage = [[fourViewController alloc] init];
    [self addChildViewController:fourPage title:@"me" image:@"tabbar_profile" selImage:@"tabbar_profile_selected"];
//    mine.navigationController.navigationBar.hidden = YES;
    
    // 更换系统自带的tabbar
    tabBar *tab = [[tabBar alloc]init];
    tab.delegate = self;
    [self setValue:tab forKey:@"tabBar"];
}

#pragma mark --添加自控制器
- (void)addChildViewController:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selImage:(NSString *)selImage{
    
    // 设置自控制器的tabbarbutton属性
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *attrDic = [NSMutableDictionary dictionary];
    
    attrDic[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    [childVc.tabBarItem setTitleTextAttributes:attrDic forState:UIControlStateNormal];
    
    NSMutableDictionary *selAttr = [NSMutableDictionary dictionary];
    
    [childVc.tabBarItem setTitleTextAttributes:selAttr forState:UIControlStateSelected];
    
    // 自控制器包含一个导航栏
    mainNavViewController *nav = [[mainNavViewController alloc]initWithRootViewController:childVc];
    
    [self addChildViewController:nav];
}

#pragma mark --加号按钮的点击事件
- (void)tabBarDidClickPlusButton:(tabBar *)tabBar
{
    FXBlurView *blurView = [[FXBlurView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    blurView.tintColor = [UIColor clearColor];
    self.blurView = blurView;
    
    [self.view addSubview:blurView];
    
    UIImageView *compose = [[UIImageView alloc]init];
    [compose setImage:[UIImage imageNamed:@"compose_slogan"]];
    compose.frame = CGRectMake(0, 100, self.view.frame.size.width, 48);
    compose.contentMode = UIViewContentModeCenter;
    [blurView addSubview:compose];
    
    
    UIView *bottom = [[UIView alloc]init];
    
    bottom.frame = CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.height, 44);
    
    bottom.backgroundColor = [UIColor whiteColor];
    
    //bottom.contentMode = UIViewContentModeCenter;
    
    
    UIButton *plus = [UIButton buttonWithType:UIButtonTypeCustom];
    
    plus.frame = CGRectMake((self.view.bounds.size.width - 25) * 0.5, 8, 25, 25);
    
    [plus setImage:[UIImage imageNamed:@"tabbar_compose_background_icon_add"] forState:UIControlStateNormal];
    
    [bottom addSubview:plus];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        plus.transform = CGAffineTransformMakeRotation(M_PI_4);
        self.plus = plus;
        
    }];
    
    [plus addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [blurView addSubview:bottom];
    
    
    UIImageView *text = [self btnAnimateWithFrame:CGRectMake(31, 500, 71, 100) imageName:@"tabbar_compose_idea" text:@"文字" animateFrame:CGRectMake(31, 280, 71, 100) delay:0.0];
    [self setAction:text action:@selector(compose)];
    self.text = text;
    
    UIImageView *ablum = [self btnAnimateWithFrame:CGRectMake(152, 500, 71, 100) imageName:@"tabbar_compose_photo" text:@"相册" animateFrame:CGRectMake(152, 280, 71, 100) delay:0.1];
    self.ablum = ablum;
    
    UIImageView *camera = [self btnAnimateWithFrame:CGRectMake(273, 500, 71, 100) imageName:@"tabbar_compose_camera" text:@"摄影" animateFrame:CGRectMake(273, 280, 71, 100) delay:0.15];
    self.camera = camera;
    
    UIImageView *sign = [self btnAnimateWithFrame:CGRectMake(31, 700, 71, 100) imageName:@"tabbar_compose_lbs" text:@"签到" animateFrame:CGRectMake(31, 410, 71, 100) delay:0.2];
    self.sign = sign;
    
    
    UIImageView *comment = [self btnAnimateWithFrame:CGRectMake(152, 700, 71, 100) imageName:@"tabbar_compose_review" text:@"评论"
                                    animateFrame:CGRectMake(152, 410, 71, 100) delay:0.25];
    self.comment = comment;
    
    UIImageView *more = [self btnAnimateWithFrame:CGRectMake(273, 700, 71, 100) imageName:@"tabbar_compose_more" text:@"更多" animateFrame:CGRectMake(273, 410, 71, 100) delay:0.3];
    self.more = more;

}

//按钮出来动画
- (UIImageView *)btnAnimateWithFrame:(CGRect)frame imageName:(NSString *)imageName text:(NSString *)text animateFrame:(CGRect)aniFrame delay:(CGFloat)delay {
    
    UIImageView *btnContainer = [[UIImageView alloc]init];
    
    btnContainer.frame  = frame;
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    
    [btnContainer addSubview:image];
    
    UILabel *word = [[UILabel alloc]initWithFrame:CGRectMake(0, 75, 71, 25)];
    [word setText:text];
    [word setTextAlignment:NSTextAlignmentCenter];
    [word setFont:[UIFont systemFontOfSize:15]];
    [word setTextColor:[UIColor grayColor]];
    
    [btnContainer addSubview:word];
    
    [self.blurView addSubview:btnContainer];
    
    [UIView animateWithDuration:0.5 delay:delay usingSpringWithDamping:0.6 initialSpringVelocity:0.05 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        btnContainer.frame  = aniFrame;
        
    } completion:^(BOOL finished) {
        
    }];
    
    return btnContainer;
}

//设置按钮方法
- (void)setAction:(UIImageView *)imageView action:(SEL)action{
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:action];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:gesture];
    
}

//关闭按钮
- (void)closeClick {
    
    [UIView animateWithDuration:0.6 animations:^{
        
        self.plus.transform = CGAffineTransformMakeRotation(-M_PI_2);
        [self btnCloseAnimateWithFrame:CGRectMake(273, 700, 71, 100) delay:0.1 btnView:self.more];
        [self btnCloseAnimateWithFrame:CGRectMake(152, 700, 71, 100) delay:0.15 btnView:self.comment];
        [self btnCloseAnimateWithFrame:CGRectMake(31, 700, 71, 100) delay:0.2 btnView:self.sign];
        [self btnCloseAnimateWithFrame:CGRectMake(273, 700, 71, 100) delay:0.25 btnView:self.camera];
        [self btnCloseAnimateWithFrame:CGRectMake(152, 700, 71, 100) delay:0.3 btnView:self.ablum];
        [self btnCloseAnimateWithFrame:CGRectMake(31, 700, 71, 100) delay:0.35 btnView:self.text];
        
        
    } completion:^(BOOL finished) {
        
        [self.text removeFromSuperview];
        [self.ablum removeFromSuperview];
        [self.camera removeFromSuperview];
        [self.sign removeFromSuperview];
        [self.comment removeFromSuperview];
        [self.more removeFromSuperview];
        [self.blurView removeFromSuperview];
    }];
}

//关闭动画
- (void)btnCloseAnimateWithFrame:(CGRect)rect delay:(CGFloat)delay btnView:(UIImageView *)btnView{
    
    
    [UIView animateWithDuration:0.3 delay:delay usingSpringWithDamping:0.6 initialSpringVelocity:0.05 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        btnView.frame  = rect;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)Item
{
    UITabBar *tb = self.tabBar;
    NSArray *items = tb.items;
    for (UITabBarItem *item in items) {
        if (Item == item) {
            _index = [items indexOfObject:Item];
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickTabBarItem" object:Item];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
//    for (UIViewController *vc in self.childViewControllers[_index].childViewControllers) {
//        if ([vc isKindOfClass:[fristPageViewController class]]) {
//            return (toInterfaceOrientation != UIDeviceOrientationPortraitUpsideDown);
//        }
//    }
    return (toInterfaceOrientation == UIDeviceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
//    for (UIViewController *vc in self.childViewControllers[_index].childViewControllers) {
//        if ([vc isKindOfClass:[fristPageViewController class]]) {
//            return YES;
//        }
//    }
    
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
//    for (UIViewController *vc in self.childViewControllers[_index].childViewControllers) {
//        if ([vc isKindOfClass:[fristPageViewController class]]) {
//            return UIInterfaceOrientationMaskAllButUpsideDown;
//        }
//    }
    return UIInterfaceOrientationMaskPortrait;
}



















@end
