//
//  thirdViewController.m
//  pantao
//
//  Created by wkr on 16/5/13.
//  Copyright © 2016年 pantao. All rights reserved.
//

#import "thirdViewController.h"
#import "PTView.h"
#import "MBProgressHUD+NJ.h"
#import "UIImage+captureView.h"
#import "DXPopover.h" // 弹入弹出视图

@interface thirdViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) PTView *drawView;

@property (nonatomic, strong) NSArray *colorArr;

@property (nonatomic, strong) UIButton *lineWidthBtn;// 线宽按钮
@property (nonatomic, strong) UITableView *lineTableView;// 线宽选择的tableview
@property (nonatomic, strong) NSArray *lineWidthArr;// 线宽数组

@property (nonatomic, strong) DXPopover *popover;

@end

@implementation thirdViewController

- (void)viewDidLoad {
//    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.0f];
    
    [self uiconfig];
}

- (void)uiconfig{
    //初始化画板
    _drawView = [[PTView alloc]initWithFrame:CGRectMake(0, UISCREENWIDTH/8+1, UISCREENWIDTH, UISCREENHEIGHT-UISCREENWIDTH/8-49-64-1)];
    [self.view addSubview:_drawView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, UISCREENHEIGHT-(UISCREENWIDTH/8-10*aspect)-49-64, UISCREENWIDTH, UISCREENWIDTH/8-10*aspect)];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    _drawView.backgroundColor = [UIColor whiteColor];
    // 创建下面的8个选色按钮
    _colorArr = [NSArray arrayWithObjects:[UIColor colorWithRed:0.08f green:0.14f blue:0.13f alpha:1.00f],
                                                  [UIColor colorWithRed:0.93f green:0.23f blue:0.27f alpha:1.00f],
                                                  [UIColor colorWithRed:0.99f green:0.88f blue:0.86f alpha:1.00f],
                                                  [UIColor colorWithRed:0.89f green:0.46f blue:0.31f alpha:1.00f],
                                                  [UIColor colorWithRed:0.99f green:0.68f blue:0.15f alpha:1.00f],
                                                  [UIColor colorWithRed:1.00f green:0.95f blue:0.24f alpha:1.00f],
                                                  [UIColor colorWithRed:0.72f green:0.86f blue:0.32f alpha:1.00f],
                                                  [UIColor colorWithRed:0.32f green:0.69f blue:0.41f alpha:1.00f],nil];
    for (int i = 0; i<8; i++) {
        UIButton *choseColorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        choseColorBtn.frame = CGRectMake(5*aspect+i*UISCREENWIDTH/8, 0, UISCREENWIDTH/8-10*aspect, UISCREENWIDTH/8-10*aspect);
        [bottomView addSubview:choseColorBtn];
        choseColorBtn.backgroundColor = _colorArr[i];
        choseColorBtn.layer.cornerRadius = (UISCREENWIDTH/8-10*aspect)/2;
        choseColorBtn.tag = i;
        [choseColorBtn addTarget:self action:@selector(getColor:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.drawView.penColor = _colorArr[0];
    _lineWidthArr = [NSArray arrayWithObjects:@"7",@"8",@"9",@"10",@"11",@"12", nil];
    
    self.drawView.penWidth = [_lineWidthArr[0] floatValue];
    
    //画板上方的操作
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, UISCREENWIDTH/8)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    //选择线条粗细
    _lineWidthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lineWidthBtn.frame = CGRectMake(0, 0, UISCREENWIDTH/4, UISCREENWIDTH/8);
    [_lineWidthBtn setTitle:_lineWidthArr[0] forState:UIControlStateNormal];
    [_lineWidthBtn setTitleColor:mainColor forState:UIControlStateNormal];
    _lineWidthBtn.titleLabel.font = [UIFont systemFontOfSize:15*aspect];
    [topView addSubview:_lineWidthBtn];
    [_lineWidthBtn addTarget:self action:@selector(selectLineWidth) forControlEvents:UIControlEventTouchUpInside];
    
    _lineTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, UISCREENWIDTH/8, UISCREENWIDTH/4, UISCREENWIDTH/2) style:UITableViewStylePlain];
    _lineTableView.backgroundColor = [UIColor clearColor];
    _lineTableView.delegate = self;
    _lineTableView.dataSource = self;
//    _lineTableView.layer.cornerRadius = 3;
//    _lineTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _lineTableView.layer.borderWidth = 1;
    
    //清屏按钮
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(UISCREENWIDTH/4, 0, UISCREENWIDTH/4, UISCREENWIDTH/8);
    [clearBtn setTitle:@"清屏" forState:UIControlStateNormal];
    [clearBtn setTitleColor:mainColor forState:UIControlStateNormal];
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:15*aspect];
    [topView addSubview:clearBtn];
    [clearBtn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    
    //回退按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(UISCREENWIDTH/2, 0, UISCREENWIDTH/4, UISCREENWIDTH/8);
    [backBtn setTitle:@"回退" forState:UIControlStateNormal];
    [backBtn setTitleColor:mainColor forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:15*aspect];
    [topView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    //保存按钮
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(3*UISCREENWIDTH/4, 0, UISCREENWIDTH/4, UISCREENWIDTH/8);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:mainColor forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:15*aspect];
    [topView addSubview:saveBtn];
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)selectLineWidth{
//    if ([_lineTableView.superview isEqual:self.view]) {
//        [_lineTableView removeFromSuperview];
//    }else{
//        [self.view addSubview:_lineTableView];
//    }
    
    self.popover = [DXPopover new];
    self.popover.maskType = DXPopoverMaskTypeBlack;
    self.popover.contentInset = UIEdgeInsetsZero;
    self.popover.backgroundColor = [UIColor whiteColor];
    
    [self.popover showAtPoint:CGPointMake(CGRectGetMidX(_lineWidthBtn.frame), CGRectGetMaxY(_lineWidthBtn.frame)+64)
               popoverPostion:DXPopoverPositionDown
              withContentView:_lineTableView
                       inView:self.tabBarController.view];
    __weak typeof(self) weakSelf = self;
    self.popover.didDismissHandler = ^{
        [weakSelf bounceTargetView:weakSelf.lineTableView];
    };
}

- (void)bounceTargetView:(UIView *)targetView {
    targetView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.3
          initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         targetView.transform = CGAffineTransformIdentity;
                     }
                     completion:nil];
}

- (void)clear{
    [self.drawView clearView];
}

- (void)back{
    [self.drawView backView];
}

- (void)save{
    UIImage *newImage = [UIImage captureImageWithView:self.drawView];
    // 4.保存到相册
    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showError:@"保存失败"];
    }else
    {
        [MBProgressHUD showSuccess:@"保存成功"];
    }
}

- (void)getColor:(UIButton *)btn{
    _drawView.penColor = _colorArr[btn.tag];
}


#pragma mark --tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _lineWidthArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UISCREENWIDTH/8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = _lineWidthArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_lineWidthBtn setTitle:_lineWidthArr[indexPath.row] forState:UIControlStateNormal];
    self.drawView.penWidth = [_lineWidthArr[indexPath.row] floatValue];
//    [_lineTableView removeFromSuperview];
    [self.popover dismiss];
}

@end
