//
//  YZTRefreshNormalHeader.m
//
//  Created by Chuckon Yin on 16/2/24.
//  Copyright (c) 2015年 Pinan. All rights reserved.
//

// 状态检查
#define YZTRefreshCheckState \
MJRefreshState oldState = self.state; \
if (state == oldState) return; \
[super setState:state];

#import "YZTRefreshNormalHeader.h"
#import "YZTRefreshCircle.h"

@interface YZTRefreshNormalHeader()

@end

@implementation YZTRefreshNormalHeader
#pragma mark - 懒加载子控件

- (instancetype)init{
    if (self = [super init]) {
        self.circleColor = [UIColor grayColor];
        self.stateTextColor = [UIColor grayColor];
        self.offSetY = 0;
    }
    return self;
}

- (YZTRefreshCircle *)circle
{
    if (!_circle) {
        _circle = [[YZTRefreshCircle alloc] initWithFrame:CGRectMake(0, 0, 35, 35) andTotoalTurns:1 circleColor:_circleColor];
        [self addSubview:_circle];
    }
    return _circle;
}

#pragma makr - 重写父类的方法
- (void)prepare
{
    //保留父类的处理
    [super prepare];
}

- (void)placeSubviews
{
    //父类处理无影响
    [super placeSubviews];
    // 箭头的中心点
    CGFloat arrowCenterX = self.mj_w * 0.5;
    if (!self.stateLabel.hidden) {
        arrowCenterX -= 100;
    }
    CGFloat arrowCenterY = self.mj_h/2 + 5 + self.offSetY;
    CGPoint arrowCenter = CGPointMake(arrowCenterX+40, arrowCenterY);//改变菊花的位置
    // 箭头
    self.circle.center = arrowCenter;
    
    //必须在父类方法执行完才进行修改
    self.stateLabel.frame = CGRectMake(15, arrowCenterY - 35.0/2.0, self.stateLabel.mj_w, 35);     //改变状态条的位置

    self.stateLabel.textColor = self.stateTextColor;
    self.stateLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:13];
    self.circle.circleColor = self.circleColor;
    
}

- (void)setState:(MJRefreshState)state
{
    //父类除了对动画的处理，没有任何其他操作
    YZTRefreshCheckState;
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        [_circle stopTurnning];
        if (oldState == MJRefreshStateRefreshing) {
        } else {
        }
    } else if (state == MJRefreshStatePulling) {
        [_circle startTurnningFast];
    } else if (state == MJRefreshStateRefreshing) {
        [_circle startTurnningFast];
    }
}

#pragma mark - 截取MJ偏移量,只截取，不做任何操作

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.mj_offsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    // >= -> >
    if (offsetY > happenOffsetY) return;
    
    // 普通 和 即将刷新 的临界点
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.mj_h;
    
    [self resetStateLabel:pullingPercent];
    
    if (self.scrollView.isDragging) { // 如果正在拖拽
        //更改圆圈角度
        [_circle resetCurrentRotationAngle:pullingPercent];
    } else if (self.state == MJRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
    } else if (pullingPercent < 1) {
    }
}

- (void)resetStateLabel:(CGFloat)pullingPercent{
    //更改显示文字透明度
    self.stateLabel.alpha = pullingPercent;
    if (pullingPercent < 0) {
        pullingPercent = 0;
    }
    if (pullingPercent > 1) {
        pullingPercent = 1;
    }
    
    self.stateLabel.layer.transform = CATransform3DMakeRotation(M_PI/2*(1-pullingPercent), 1, 0, 0);
}

#pragma mark - 截取MJ状态

- (void)beginRefreshing{
    [super beginRefreshing];
    [_circle startTurnningFast];
}

- (void)endRefreshing{
    [super endRefreshing];
    [_circle stopTurnning];
}

#pragma mark - 截获MJ获取动画控件，破坏原生控件

- (UIActivityIndicatorView *)loadingView
{
//    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
//    view.clipsToBounds = YES;
    return nil;
}

- (UIImageView *)arrowView{
//    UIImageView *imav = [[UIImageView alloc] initWithFrame:CGRectZero];
//    imav.clipsToBounds = YES;
    return nil;
}

#pragma mark - 截获MJ获取状态控件，方便更改颜色

- (UILabel *)stateLabel
{
    //调用父类方法, 提前初始化出stateLabel
    UILabel *label = [super stateLabel];
    //此处，可对状态文字进行编辑
    label.textColor = _stateTextColor;
    return label;
}

- (void)setCircleColor:(UIColor *)circleColor{
    _circleColor = circleColor;
    if (_circle) {
        _circle.circleColor = _circleColor;
    }
}


@end




