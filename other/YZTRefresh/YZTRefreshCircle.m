//
//  YZTRefreshCircle.m
//  0219下拉刷新动画
//
//  Created by ChuckonYin on 16/2/19.
//  Copyright © 2016年 PingAn. All rights reserved.
//


#import "YZTRefreshCircle.h"

static CGFloat yztRefreshCircleMaxAngle = 0.96f;

@interface YZTRefreshCircle ()
{
    CGFloat _mWidth;
    CGFloat _mHeight;
    CGFloat _r;
}
@property (nonatomic, assign) CGFloat currentAngle;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) CGFloat timerRec;

@end

@implementation YZTRefreshCircle

- (instancetype)initWithFrame:(CGRect)frame andTotoalTurns:(CGFloat)turns circleColor:(UIColor*)circleColor{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.totoalTurns = 1.0f;
        self.circleBoderWidth = 0.7f;
        self.circleColor = circleColor;
        self.currentAngle = -M_PI/2;
        [self resetCircleFrame:frame];
        
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}


- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
}
- (void)resetCircleFrame:(CGRect)frame{
    _mWidth = frame.size.width;
    _mHeight = frame.size.height;
    _r = _mWidth/2-6;
}


- (void)resetCurrentRotationAngle:(CGFloat)angle{
//    NSLog(@"++++++%f", angle);
    if (self.circleState == YZTRefreshCircleStateTurnning) {
        return ;
    }
    angle = (angle - 0.3)*1/0.7;
    if (angle<=0.1) {
        self.currentAngle = -M_PI/2;
        self.transform = CGAffineTransformMakeRotation(0);
        [self setNeedsDisplay];
    }
    else if (angle>0 && angle <= yztRefreshCircleMaxAngle){
        //-M_PI/2 + (angle)*self.totoalTurns*2*M_PI
        //将0-1的范围映射到0.5-1。优化动画效果
        self.currentAngle = -M_PI/2 + angle*self.totoalTurns*2*M_PI;
        if (self.currentAngle <= -M_PI/2) {
            self.currentAngle = -M_PI/2;
        }
        [self setNeedsDisplay];
    }
    else if (angle > yztRefreshCircleMaxAngle){
        self.currentAngle = -M_PI/2 + yztRefreshCircleMaxAngle*self.totoalTurns*2*M_PI;
        [self setNeedsDisplay];
    }
}
/**
 *  开始高速旋转
 */
- (void)startTurnningFast{
    if (self.circleState == YZTRefreshCircleStateTurnning) return;
    self.circleState = YZTRefreshCircleStateTurnning;
    _timer = [NSTimer timerWithTimeInterval:0.025 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer setFireDate:[NSDate date]];
    if (self.currentAngle < -M_PI/2 + yztRefreshCircleMaxAngle*self.totoalTurns*2*M_PI) {
        self.currentAngle = -M_PI/2 + yztRefreshCircleMaxAngle*self.totoalTurns*2*M_PI;
        [self setNeedsDisplay];
    }
    
}
/**
 *  停止旋转
 */
- (void)stopTurnning{
    self.circleState = YZTRefreshCircleStateStatic;
    [_timer setFireDate:[NSDate distantFuture]];
    [_timer invalidate];
    _timerRec = 0;
    self.currentAngle = - M_PI/2;
}

- (void)drawRect:(CGRect)rect {
//    NSLog(@"\\\\\\\\%f", self.currentAngle);
    UIBezierPath *ciclePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_mWidth/2, _mHeight/2) radius:_r startAngle:-M_PI/2 endAngle:self.currentAngle clockwise:YES];
    [self.circleColor setStroke];
    NSLog(@"%@", [UIColor blackColor]);
    ciclePath.lineWidth = self.circleBoderWidth;
    [ciclePath stroke];
}

- (void)timerAction{
    self.transform = CGAffineTransformMakeRotation(_timerRec);
    _timerRec += 0.1;
}

- (void)dealloc{
    
}

@end







