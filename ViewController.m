//
//  ViewController.m
//  pantao
//
//  Created by wkr on 16/5/5.
//  Copyright © 2016年 pantao. All rights reserved.
//

#import "ViewController.h"
#import "launchViewController.h"
#import "EMSDK.h"
#import "mainTabBarViewController.h"

@interface ViewController (){
    CBZSplashView *splashView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = mainColor;
    
    //不设置此处会导致View上移
    if(iOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    UIImage *icon = [UIImage imageNamed:@"QQ"];
    UIColor *color = mainColor;
    splashView = [CBZSplashView splashViewWithIcon:icon backgroundColor:color];
    
    // customize duration, icon size, or icon color here;
    splashView.animationDuration = 5;
    [self.view addSubview:splashView];
    [splashView startAnimation];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
