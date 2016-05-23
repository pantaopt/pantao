//
//  registerViewController.m
//  pantao
//
//  Created by wkr on 16/5/5.
//  Copyright © 2016年 pantao. All rights reserved.
//

#import "registerViewController.h"
#import "EMSDK.h"
#import "PasswordStrengthIndicatorView.h"

#import "FlatButton.h"
#import <POP/POP.h>

@interface registerViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UIImageView* imgLeftHand;
    UIImageView* imgRightHand;
    
    ptRegisterShowType showType;
}

@property (strong, nonatomic) UIView *textView;// 账号密码的view
@property (strong, nonatomic) UITextField *userName;
@property (strong, nonatomic) UITextField *passWord;
@property (strong, nonatomic) PasswordStrengthIndicatorView *passwordStrengthIndicatorView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) UIButton *sureBtn;// 确定按钮

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    
    self.navigationController.navigationBar.hidden = NO;
    
    [self addActivityIndicatorView];
    self.title = @"注册";
    [self config];
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
//    [imgLogin mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@(109*0.6*aspect));
//        make.width.equalTo(@(211*0.6*aspect));
//        make.top.equalTo(self.view.mas_top).offset(34*aspect+64);
//        make.centerX.equalTo(self.view.mas_centerX);
//    }];
    
    imgLeftHand = [[UIImageView alloc] initWithFrame:CGRectMake(61*0.6*aspect-42*aspect, 66*aspect, 40*0.6*aspect, 65*0.6*aspect)];
    imgLeftHand.image = [UIImage imageNamed:@"owl-login-arm-left"];
    [imgLogin addSubview:imgLeftHand];
//    [imgLeftHand mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@(65*0.6*aspect));
//        make.width.equalTo(@(40*0.6*aspect));
//        make.top.equalTo(imgLogin.mas_top).offset(66*aspect);
//        make.right.equalTo(imgLogin.mas_left).offset(10*aspect);
//    }];
    
    imgRightHand = [[UIImageView alloc] initWithFrame:CGRectMake(imgLogin.frame.size.width / 2 + 53*aspect, 66*aspect, 40*0.6*aspect, 65*0.6*aspect)];
    imgRightHand.image = [UIImage imageNamed:@"owl-login-arm-right"];
    [imgLogin addSubview:imgRightHand];
//    [imgRightHand mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@(65*0.6*aspect));
//        make.width.equalTo(@(40*0.6*aspect));
//        make.top.equalTo(imgLogin.mas_top).offset(66*aspect);
//        make.left.equalTo(imgLogin.mas_right).offset(-5*aspect);
//    }];

    
    _textView = [[UIView alloc]initWithFrame:CGRectMake(0, imgLogin.frame.origin.y+imgLogin.frame.size.height+20*aspect, UISCREENWIDTH, 80*aspect+3)];
    [self.view addSubview:_textView];
    _textView.backgroundColor = [UIColor whiteColor];
//    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(0);
//        make.right.equalTo(self.view.mas_right).offset(0);
//        make.height.equalTo(@(80*aspect+3));
//        make.top.equalTo(imgLogin.mas_bottom).offset(20*aspect);
//    }];
    
    UIView *xianTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, 1)];
    xianTop.backgroundColor = [UIColor lightGrayColor];
    [_textView addSubview:xianTop];
//    [xianTop mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_textView.mas_left).offset(0);
//        make.right.equalTo(_textView.mas_right).offset(0);
//        make.top.equalTo(_textView.mas_top).offset(0);
//        make.height.equalTo(@1);
//    }];
    
    UIView *xianBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 80*aspect+2, UISCREENWIDTH, 1)];
    xianBottom.backgroundColor = [UIColor lightGrayColor];
    [_textView addSubview:xianBottom];
//    [xianBottom mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_textView.mas_left).offset(0);
//        make.right.equalTo(_textView.mas_right).offset(0);
//        make.bottom.equalTo(_textView.mas_bottom).offset(0);
//        make.height.equalTo(@1);
//    }];
    
    UIView *xianMid = [[UIView alloc]initWithFrame:CGRectMake(30*aspect, 40*aspect+1, UISCREENWIDTH, 1)];
    xianMid.backgroundColor = [UIColor lightGrayColor];
    [_textView addSubview:xianMid];
//    [xianMid mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_textView.mas_left).offset(0);
//        make.right.equalTo(_textView.mas_right).offset(0);
//        make.centerY.equalTo(_textView.mas_centerY);
//        make.height.equalTo(@1);
//    }];
    
    _userName = [[UITextField alloc]initWithFrame:CGRectMake(30*aspect, 1, UISCREENWIDTH, 40*aspect)];
    _userName.backgroundColor = [UIColor whiteColor];
    _userName.placeholder = @"手机号/邮箱/用户名";
    [_textView addSubview:_userName];
    _userName.delegate = self;
//    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_textView.mas_left).offset(0);
//        make.right.equalTo(_textView.mas_right).offset(0);
//        make.height.equalTo(@(40*aspect));
//        make.top.equalTo(_textView.mas_top).offset(1);
//    }];
    
    _passWord = [[UITextField alloc]initWithFrame:CGRectMake(30*aspect, 40*aspect+2, UISCREENWIDTH, 40*aspect)];
    _passWord.backgroundColor = [UIColor whiteColor];
    _passWord.placeholder = @"密码";
    [_textView addSubview:_passWord];
    [_passWord setSecureTextEntry:YES];
    _passWord.delegate = self;
    [_passWord addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    [_passWord mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_textView.mas_left).offset(0);
//        make.right.equalTo(_textView.mas_right).offset(0);
//        make.height.equalTo(@(40*aspect));
//        make.bottom.equalTo(_textView.mas_bottom).offset(1);
//    }];
    
    [self addPasswordStrengthView];
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.frame = CGRectMake(10*aspect, _textView.frame.origin.y+_textView.frame.size.height+40*aspect, UISCREENWIDTH-20*aspect, 35*aspect);
    [self.view addSubview:_sureBtn];
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.backgroundColor = mainColor;
    _sureBtn.layer.cornerRadius = 5;
    [_sureBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:17*aspect];
//    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(10*aspect);
//        make.right.equalTo(self.view.mas_right).offset(10*aspect);
//        make.height.equalTo(@(35*aspect));
//        make.top.equalTo(_textView.mas_bottom).offset(40*aspect);
//    }];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    singleTap.numberOfTouchesRequired = 1; //手指数
    singleTap.numberOfTapsRequired = 1; //tap次数
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
    
}

- (void)addPasswordStrengthView
{
    self.passwordStrengthIndicatorView = [PasswordStrengthIndicatorView new];
    [self.view addSubview:self.passwordStrengthIndicatorView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_passWord, _passwordStrengthIndicatorView);
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-[_passwordStrengthIndicatorView]-|"
                               options:0
                               metrics:nil
                               views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:[_passWord]-[_passwordStrengthIndicatorView(==10)]"
                               options:0
                               metrics:nil
                               views:views]];
}

- (void)textFieldDidChange:(UITextField *)sender
{
    if (sender.text.length < 1) {
        self.passwordStrengthIndicatorView.status = PasswordStrengthIndicatorViewStatusNone;
        return;
    }
    
    if (sender.text.length < 4) {
        self.passwordStrengthIndicatorView.status = PasswordStrengthIndicatorViewStatusWeak;
        return;
    }
    
    if (sender.text.length < 8) {
        self.passwordStrengthIndicatorView.status = PasswordStrengthIndicatorViewStatusFair;
        return;
    }
    
    self.passwordStrengthIndicatorView.status = PasswordStrengthIndicatorViewStatusStrong;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_userName]) {
        if (showType != ptRegisterShowType_PASS)
        {
            showType = ptRegisterShowType_USER;
            return;
        }
        showType = ptRegisterShowType_USER;
        [UIView animateWithDuration:0.5 animations:^{
            imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x - 42*aspect, imgLeftHand.frame.origin.y + 30*aspect, imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
            
            imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x + 48*aspect, imgRightHand.frame.origin.y + 30*aspect, imgRightHand.frame.size.width, imgRightHand.frame.size.height);
        } completion:^(BOOL b) {
        }];
        
    }
    else if ([textField isEqual:_passWord]) {
        if (showType == ptRegisterShowType_PASS)
        {
            showType = ptRegisterShowType_PASS;
            return;
        }
        showType = ptRegisterShowType_PASS;
        [UIView animateWithDuration:0.5 animations:^{
            imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x + 42*aspect, imgLeftHand.frame.origin.y - 30*aspect, imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
            imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x - 48*aspect, imgRightHand.frame.origin.y - 30*aspect, imgRightHand.frame.size.width, imgRightHand.frame.size.height);
        } completion:^(BOOL b) {
        }];
    }
}


- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

- (void)sure:(UIButton *)btn
{
    [self.activityIndicatorView startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    _hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    _hud.dimBackground = YES;
    [self.view addSubview:_hud];
    _hud.labelText = @"正在注册...";
    [_hud show:YES];
    EMError *error = [[EMClient sharedClient] registerWithUsername:_userName.text password:_passWord.text];
    if (error==nil) {
//        _hud.labelText = @"注册成功";
        [_hud hide:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.activityIndicatorView stopAnimating];
        DSToast *toast = [[DSToast alloc] initWithText:@"注册成功"];
        [toast showInView:self.navigationController.view];
        [self.navigationController popViewControllerAnimated:NO];
        [_delegate registerBack:_userName.text :_passWord.text];
        
        NSUserDefaults *userDefaultes=[NSUserDefaults standardUserDefaults];
        [userDefaultes setValue:_userName.text forKey:@"userName"];
        [userDefaultes setValue:_passWord.text forKey:@"passWord"];
    }else{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.activityIndicatorView stopAnimating];
        [self shakeButton];
//        _hud.labelText = @"注册失败";
        [_hud hide:YES];
        DSToast *toast = [[DSToast alloc] initWithText:error.errorDescription];
        [toast showInView:self.view];
    }
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
