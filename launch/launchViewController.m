//
//  launchViewController.m
//  pantao
//
//  Created by wkr on 16/5/5.
//  Copyright © 2016年 pantao. All rights reserved.
//

#import "launchViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "registerViewController.h"
#import "loginViewController.h"

@interface launchViewController ()<loginBackDelegate,registerBackDelegate>

@property(nonatomic,strong)MPMoviePlayerController *moviePlayer;
@property(nonatomic ,strong)NSTimer *timer;
@property(nonatomic ,strong)AVAudioSession *avaudioSession;

@property (strong, nonatomic) UIView *alpaView;
@property (strong, nonatomic) UIButton *regiset;
@property (strong, nonatomic) UIButton *login;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation launchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = mainColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    [self config];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: YES];
    self.navigationController.navigationBar.hidden = YES;
    [_moviePlayer play];
}

/**
 *  创建控件、ui
 */
- (void)config
{
    /**
     *  设置其他音乐软件播放的音乐不被打断
     */
    
    self.avaudioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [self.avaudioSession setCategory:AVAudioSessionCategoryAmbient error:&error];
    
    
    
    NSString *urlStr = [[NSBundle mainBundle]pathForResource:@"1.mp4" ofType:nil];
    
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    
    _moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:url];
    //    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    [_moviePlayer play];
    [_moviePlayer.view setFrame:self.view.bounds];
    [self.view addSubview:_moviePlayer.view];
//    [_moviePlayer.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).offset(0);
//        make.right.equalTo(self.view.mas_right).offset(0);
//        make.left.equalTo(self.view.mas_left).offset(0);
//        make.bottom.equalTo(self.view.mas_bottom).offset(0);
//    }];
    
    _moviePlayer.shouldAutoplay = YES;
    [_moviePlayer setControlStyle:MPMovieControlStyleNone];
    [_moviePlayer setFullscreen:YES];
    
    [_moviePlayer setRepeatMode:MPMovieRepeatModeOne];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackStateChanged)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_moviePlayer];
    
    
    _alpaView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, UISCREENWIDTH, UISCREENHEIGHT-20)];
    _alpaView.backgroundColor = [UIColor clearColor];
    [_moviePlayer.view addSubview:_alpaView];
//    [_alpaView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).offset(20);
//        make.right.equalTo(self.view.mas_right).offset(0);
//        make.left.equalTo(self.view.mas_left).offset(0);
//        make.bottom.equalTo(self.view.mas_bottom).offset(0);
//    }];
    
    UILabel *panTao = [[UILabel alloc]initWithFrame:CGRectMake(0, 200*aspect, UISCREENWIDTH, 100*aspect)];
    panTao.text = @"panTao";
    panTao.font = [UIFont systemFontOfSize:38*aspect];
    panTao.backgroundColor = [UIColor clearColor];
    panTao.textAlignment = NSTextAlignmentCenter;
    panTao.textColor = [UIColor whiteColor];
    [_alpaView addSubview:panTao];
//    [panTao mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(0);
//        make.centerY.equalTo(self.view.mas_centerY);
//        make.right.equalTo(self.view.mas_right).offset(0);
//        make.height.equalTo(@(100*aspect));
//    }];
    
    
    self.regiset = [UIButton buttonWithType:UIButtonTypeCustom];
    self.regiset.frame = CGRectMake(20*aspect, UISCREENHEIGHT-20-65*aspect, 158*aspect, 50*aspect);
    self.regiset.layer.cornerRadius = 3.0f;
    self.regiset.alpha = 0.4f;
    [self.regiset setTitle:@"注册" forState:UIControlStateNormal];
    //    [self.regiset setTitleColor: forState:UIControlStateNormal];
    self.regiset.backgroundColor = [UIColor blackColor];
    self.regiset.titleLabel.font = [UIFont systemFontOfSize:18*aspect];
    [_alpaView addSubview:self.regiset];
    [self.regiset addTarget:self action:@selector(goRegiset) forControlEvents:UIControlEventTouchUpInside];
    
    self.login = [UIButton buttonWithType:UIButtonTypeCustom];
    self.login.frame = CGRectMake(UISCREENWIDTH-178*aspect, UISCREENHEIGHT-20-65*aspect, 158*aspect, 50*aspect);
    self.login.layer.cornerRadius = 3.0f;
    self.login.alpha = 0.4f;
    [self.login setTitle:@"登录" forState:UIControlStateNormal];
    [self.login setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.login.backgroundColor = [UIColor whiteColor];
    self.login.titleLabel.font = [UIFont systemFontOfSize:18*aspect];
    [_alpaView addSubview:self.login];
    [self.login addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
    
//    [_regiset mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(20*aspect);
//        make.height.equalTo(@(50*aspect));
//        make.right.equalTo(_login.mas_left).offset(-10*aspect);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-65*aspect);
//        make.width.equalTo(_login.mas_width);
//    }];
//    
//    [_login mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.view.mas_right).offset(-20*aspect);
//        make.height.equalTo(@(50*aspect));
//        make.left.equalTo(_regiset.mas_right).offset(10*aspect);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-65*aspect);
//        make.width.equalTo(_regiset.mas_width);
//    }];
//
//    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, UISCREENHEIGHT-20-65*aspect)];
//    self.scrollView.bounces = NO;
//    self.scrollView.pagingEnabled = YES;
//    [_alpaView addSubview:self.scrollView];
//    
//    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(155*aspect, UISCREENHEIGHT-65*aspect-20-37*aspect, 65*aspect, 37*aspect)];
//    self.pageControl.currentPage = 0;
//    self. pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
//    self.pageControl.pageIndicatorTintColor = [UIColor blackColor];
//    self.pageControl.alpha = 0.4f;
//    [self.pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
//    [_alpaView addSubview:self.pageControl];
    
    [self setupTimer];
    
}

- (void)goRegiset
{
    [_moviePlayer stop];
//    _moviePlayer = nil;
    registerViewController *regster = [[registerViewController alloc]init];
    regster.delegate = self;
    [self.navigationController pushViewController:regster animated:YES];
}

- (void)registerBack:(NSString *)userName :(NSString *)passWord
{
    [_moviePlayer stop];
//    _moviePlayer = nil;
    loginViewController *login = [[loginViewController alloc]init];
    login.userNameTXT = userName;
    login.passWordTXT = passWord;
    [self.navigationController pushViewController:login animated:NO];
}

- (void)goLogin
{
    [_moviePlayer stop];
//    _moviePlayer = nil;
    loginViewController *login = [[loginViewController alloc]init];
    login.delegate = self;
    [self.navigationController pushViewController:login animated:YES];
}

- (void)loginBack
{
    [_moviePlayer stop];
//    _moviePlayer = nil;
    registerViewController *regster = [[registerViewController alloc]init];
    [self.navigationController pushViewController:regster animated:NO];
}

- (void)makeMPMoviePlayertoNil
{
    [_moviePlayer stop];
//    _moviePlayer = nil;
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playbackStateChanged{
    
    
    //取得目前状态
    MPMoviePlaybackState playbackState = [_moviePlayer playbackState];
    
    //状态类型
    switch (playbackState) {
        case MPMoviePlaybackStateStopped:
            [_moviePlayer play];
            break;
            
        case MPMoviePlaybackStatePlaying:
            NSLog(@"播放中");
            break;
            
        case MPMoviePlaybackStatePaused:
            [_moviePlayer play];
            break;
            
        case MPMoviePlaybackStateInterrupted:
            NSLog(@"播放被中断");
            break;
            
        case MPMoviePlaybackStateSeekingForward:
            NSLog(@"往前快转");
            break;
            
        case MPMoviePlaybackStateSeekingBackward:
            NSLog(@"往后快转");
            break;
            
        default:
            NSLog(@"无法辨识的状态");
            break;
    }
}


//ios以后隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupTimer{
    
    self.timer = [NSTimer timerWithTimeInterval:3.0f target:self selector:@selector(timerChanged) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

- (void)pageChanged:(UIPageControl *)pageControl{
    
    CGFloat x = (pageControl.currentPage) * [UIScreen mainScreen].bounds.size.width;
    
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    
    
}

- (void)timerChanged{
    int page  = (self.pageControl.currentPage +1) %4;
    
    self.pageControl.currentPage = page;
    
    [self pageChanged:self.pageControl];
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    double page = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    self.pageControl.currentPage = page;
    
    if (page== - 1)
    {
        self.pageControl.currentPage = 3;// 序号0 最后1页
    }
    else if (page == 4)
    {
        self.pageControl.currentPage = 0; // 最后+1,循环第1页
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self setupTimer];
    
}


@end
