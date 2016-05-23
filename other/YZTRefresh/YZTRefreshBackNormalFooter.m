//
//  YZTRefreshBackNormalFooter.m
//
//  Created by chuckon on 15/4/24.
//  Copyright (c) pinan. All rights reserved.
//

#import "YZTRefreshBackNormalFooter.h"

@interface YZTRefreshBackNormalFooter()

@end

@implementation YZTRefreshBackNormalFooter
#pragma mark - 懒加载子控件

- (instancetype)init{
    if (self = [super init]) {
        self.circleColor = [UIColor grayColor];
        self.stateTextColor = [UIColor grayColor];
    }
    return self;
}

- (YZTRefreshCircle *)circle
{
    if (!_circle) {
        _circle = [[YZTRefreshCircle alloc] initWithFrame:CGRectMake(0, 0, 35, 35) andTotoalTurns:1 circleColor:self.circleColor];
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
    CGFloat arrowCenterY = self.mj_h * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX+40, arrowCenterY);//改变菊花的位置
    // 箭头
    self.circle.center = arrowCenter;
    
    //必须在父类方法执行完才进行修改
    self.stateLabel.frame = CGRectMake(20, 0, self.stateLabel.mj_w, self.stateLabel.mj_h);     //改变状态条的位置
    self.stateLabel.textColor = self.stateTextColor;
    self.circle.circleColor = self.circleColor;
}

- (void)setState:(MJRefreshState)state
{
    //父类除了对动画的处理，没有任何其他操作
    MJRefreshCheckState;
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
    
    // 如果正在刷新，直接返回
    if (self.state == MJRefreshStateRefreshing) return;
    
    _scrollViewOriginalInset = self.scrollView.contentInset;
    
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.mj_offsetY;
    // 尾部控件刚好出现的offsetY
    CGFloat happenOffsetY = [self happenOffsetY];
    // 如果是向下滚动到看不见尾部控件，直接返回
    if (currentOffsetY <= happenOffsetY) return;
    
    CGFloat pullingPercent = (currentOffsetY - happenOffsetY) / self.mj_h;
    
    if (self.scrollView.isDragging) {
        //设置旋转角度
        [self.circle resetCurrentRotationAngle:pullingPercent];
    }
    else if (self.state == MJRefreshStatePulling) {// 即将刷新 && 手松开
    }
    else if (pullingPercent < 1) {
    }
}

#pragma mark - 截取MJ状态

- (void)beginRefreshing{
    [super beginRefreshing];
    [self.circle startTurnningFast];
}

- (void)endRefreshing{
    [super endRefreshing];
    [self.circle stopTurnning];
}

#pragma mark - 截获MJ获取原生控件，破坏原生控件

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
    label.textColor = self.stateTextColor;
    return label;
}

- (void)setCircleColor:(UIColor *)circleColor{
    _circleColor = circleColor;
    if (_circle) {
        _circle.circleColor = _circleColor;
    }
}

#pragma mark - 私有方法
#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)heightForContentBreakView
{
    CGFloat h = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
    return self.scrollView.contentSize.height - h;
}

#pragma mark 刚好看到上拉刷新控件时的contentOffset.y
- (CGFloat)happenOffsetY
{
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0) {
        return deltaH - self.scrollViewOriginalInset.top;
    } else {
        return - self.scrollViewOriginalInset.top;
    }
}

@end

