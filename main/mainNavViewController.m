//
//  mainNavViewController.m
//  weibo_myTest
//
//  Created by wkr on 16/3/14.
//  Copyright © 2016年 wkr. All rights reserved.
//

#import "mainNavViewController.h"

#import "UIBarButtonItem+Extension.h"


@interface mainNavViewController ()

@end

@implementation mainNavViewController

+ (void)initialize{
    [[UINavigationBar appearance] setBarTintColor:mainColor];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置导航栏按钮字体颜色
    NSMutableDictionary *textArr = [NSMutableDictionary dictionary];
    
    textArr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textArr[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    
    [item setTitleTextAttributes:textArr forState:UIControlStateNormal];
    
    // 不可选中状态
    NSMutableDictionary *disableTextArr = [NSMutableDictionary dictionary];
    
    disableTextArr[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    disableTextArr[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    
    [item setTitleTextAttributes:disableTextArr forState:UIControlStateDisabled];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    if (self.viewControllers.count > 1)
    {
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"navigationbar_back" heighlightImage:@"navigationbar_back_highlighted"];
        
        
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(more) image:@"navigationbar_more" heighlightImage:@"navigationbar_more_highlighted"];
    }
}

-(void)back {
    
    [self popViewControllerAnimated:YES];
    
}

-(void)more {
    
    [self popToRootViewControllerAnimated:YES];
    
}



@end
