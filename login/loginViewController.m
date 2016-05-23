//
//  loginViewController.m
//  pantao
//
//  Created by wkr on 16/5/5.
//  Copyright © 2016年 pantao. All rights reserved.
//

#import "loginViewController.h"
#import "mainTabBarViewController.h"
#import "registerViewController.h"
#import "EMSDK.h"

@interface loginViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UIImageView* imgLeftHand;
    UIImageView* imgRightHand;
    
    ptLoginShowType showType;
}

@property (strong, nonatomic) UIView *textView;// 账号密码的view
@property (strong, nonatomic) UITextField *userName;
@property (strong, nonatomic) UITextField *passWord;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) UIButton *sureBtn;// 确定按钮

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    
    self.navigationController.navigationBar.hidden = NO;
    [self addActivityIndicatorView];
    [self config];
    
    self.title = @"登录";
}

- (void)addActivityIndicatorView
{
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicatorView];
    self.navigationItem.rightBarButtonItem = item;
}

/**
 *  创建控件、ui
 */
-(void)config
{
    UIImageView* imgLogin = [[UIImageView alloc] initWithFrame:CGRectMake(UISCREENWIDTH / 2 - 211*0.6*aspect / 2, 34*aspect+64, 211*0.6*aspect, 109*0.6*aspect)];
    imgLogin.image = [UIImage imageNamed:@"owl-login"];
    imgLogin.layer.masksToBounds = YES;
    [self.view addSubview:imgLogin];
    
    imgLeftHand = [[UIImageView alloc] initWithFrame:CGRectMake(61*0.6*aspect-42*aspect, 66*aspect, 40*0.6*aspect, 65*0.6*aspect)];
    imgLeftHand.image = [UIImage imageNamed:@"owl-login-arm-left"];
    [imgLogin addSubview:imgLeftHand];
    
    imgRightHand = [[UIImageView alloc] initWithFrame:CGRectMake(imgLogin.frame.size.width / 2 + 53*aspect, 66*aspect, 40*0.6*aspect, 65*0.6*aspect)];
    imgRightHand.image = [UIImage imageNamed:@"owl-login-arm-right"];
    [imgLogin addSubview:imgRightHand];
    
    _textView = [[UIView alloc]initWithFrame:CGRectMake(0, imgLogin.frame.origin.y+imgLogin.frame.size.height, UISCREENWIDTH, 80*aspect+3)];
    [self.view addSubview:_textView];
    _textView.backgroundColor = [UIColor whiteColor];
    
    UIView *xianTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, 1)];
    xianTop.backgroundColor = [UIColor lightGrayColor];
    [_textView addSubview:xianTop];
    
    UIView *xianBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 80*aspect+2, UISCREENWIDTH, 1)];
    xianBottom.backgroundColor = [UIColor lightGrayColor];
    [_textView addSubview:xianBottom];
    
    UIView *xianMid = [[UIView alloc]initWithFrame:CGRectMake(30*aspect, 40*aspect+1, UISCREENWIDTH, 1)];
    xianMid.backgroundColor = [UIColor lightGrayColor];
    [_textView addSubview:xianMid];
    
    _userName = [[UITextField alloc]initWithFrame:CGRectMake(30*aspect, 1, UISCREENWIDTH, 40*aspect)];
    _userName.backgroundColor = [UIColor whiteColor];
    _userName.placeholder = @"手机号/邮箱/用户名";
    [_textView addSubview:_userName];
    _userName.text = _userNameTXT;
    _userName.delegate = self;
    
    _passWord = [[UITextField alloc]initWithFrame:CGRectMake(30*aspect, 40*aspect+2, UISCREENWIDTH, 40*aspect)];
    _passWord.backgroundColor = [UIColor whiteColor];
    _passWord.placeholder = @"密码";
    [_textView addSubview:_passWord];
    _passWord.text = _passWordTXT;
    [_passWord setSecureTextEntry:YES];
    _passWord.delegate = self;
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.frame = CGRectMake(10*aspect, _textView.frame.origin.y+_textView.frame.size.height+20*aspect, UISCREENWIDTH-20*aspect, 35*aspect);
    [self.view addSubview:_sureBtn];
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.backgroundColor = mainColor;
    _sureBtn.layer.cornerRadius = 5;
    [_sureBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:17*aspect];
    
    UIButton *goRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    goRegister.frame = CGRectMake(10*aspect, _sureBtn.frame.origin.y+_sureBtn.frame.size.height+10*aspect, 80*aspect, 30*aspect);
    goRegister.backgroundColor = [UIColor clearColor];
    [self.view addSubview:goRegister];
    [goRegister setTitle:@"立即注册" forState:UIControlStateNormal];
    [goRegister setTitleColor:mainColor forState:UIControlStateNormal];
    goRegister.titleLabel.font = [UIFont systemFontOfSize:14*aspect];
    [goRegister addTarget:self action:@selector(goRegister) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(UISCREENWIDTH/2-25*aspect-5*aspect, UISCREENHEIGHT-64-45*aspect, 25*aspect, 25*aspect);
    weiboBtn.backgroundColor = [UIColor clearColor];
    [weiboBtn setBackgroundImage:[UIImage imageNamed:@"weibo"] forState:UIControlStateNormal];
    [self.view addSubview:weiboBtn];
    [weiboBtn addTarget:self action:@selector(loginWithWeibo) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *QQBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    QQBtn.frame = CGRectMake(UISCREENWIDTH/2+5*aspect, UISCREENHEIGHT-64-45*aspect, 25*aspect, 25*aspect);
    QQBtn.backgroundColor = [UIColor clearColor];
    [QQBtn setBackgroundImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
    [self.view addSubview:QQBtn];
    [QQBtn addTarget:self action:@selector(loginWithQQ) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    singleTap.numberOfTouchesRequired = 1; //手指数
    singleTap.numberOfTapsRequired = 1; //tap次数
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_userName]) {
        if (showType != ptLoginShowType_PASS)
        {
            showType = ptLoginShowType_USER;
            return;
        }
        showType = ptLoginShowType_USER;
        [UIView animateWithDuration:0.5 animations:^{
            imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x - 42*aspect, imgLeftHand.frame.origin.y + 30*aspect, imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
            
            imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x + 48*aspect, imgRightHand.frame.origin.y + 30*aspect, imgRightHand.frame.size.width, imgRightHand.frame.size.height);
        } completion:^(BOOL b) {
        }];
        
    }
    else if ([textField isEqual:_passWord]) {
        if (showType == ptLoginShowType_PASS)
        {
            showType = ptLoginShowType_PASS;
            return;
        }
        showType = ptLoginShowType_PASS;
        [UIView animateWithDuration:0.5 animations:^{
            imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x + 42*aspect, imgLeftHand.frame.origin.y - 30*aspect, imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
            imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x - 48*aspect, imgRightHand.frame.origin.y - 30*aspect, imgRightHand.frame.size.width, imgRightHand.frame.size.height);
        } completion:^(BOOL b) {
        }];
    }
}

/**
 *  微博登录
 */
- (void)loginWithWeibo
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"loginViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

/**
 *  QQ登录
 */
- (void)loginWithQQ
{
    
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

- (void)sure
{
    [self.activityIndicatorView startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.labelText = @"正在登录...";
    [_hud show:YES];
    EMError *error = [[EMClient sharedClient] loginWithUsername:_userName.text password:_passWord.text];
    if (!error) {
//        _hud.labelText = @"登录成功";
        [_hud hide:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.activityIndicatorView stopAnimating];
        DSToast *toast = [[DSToast alloc] initWithText:@"注册成功"];
        [toast showInView:self.navigationController.view];
        [_delegate makeMPMoviePlayertoNil];
        [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"islogin"];
         [[NSUserDefaults standardUserDefaults] setValue:_userName.text forKey:@"userName"];
         [[NSUserDefaults standardUserDefaults] setValue:_passWord.text forKey:@"passWord"];
        [UIApplication sharedApplication].keyWindow.rootViewController = [mainTabBarViewController new];
    }else
    {
//        _hud.labelText = @"登录失败";
        [_hud hide:YES];
        [self shakeButton];
        DSToast *toast = [[DSToast alloc] initWithText:error.errorDescription];
        [toast showInView:self.navigationController.view];
    }
}

- (void)goRegister
{
    [self.navigationController popViewControllerAnimated:NO];
    [_delegate loginBack];
}

#pragma mark Animations

- (void)shakeButton
{
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @2000;
    positionAnimation.springBounciness = 20;
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        _sureBtn.userInteractionEnabled = YES;
    }];
    [_sureBtn.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

@end
