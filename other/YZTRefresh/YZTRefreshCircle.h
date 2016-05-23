//
//  YZTRefreshCircle.h
//  0219下拉刷新动画
//
//  Created by ChuckonYin on 16/2/19.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YZTRefreshCircleState){
    YZTRefreshCircleStateStatic = 0,//静止状态
    YZTRefreshCircleStatePulling, //下拉状态
    YZTRefreshCircleStateTurnning,//高速选装状态
    YZTRefreshCircleStateStopRefreshing//下拉头回收进行中
};

@interface YZTRefreshCircle : UIView

/**
 *  圆圈边缘宽度
 */
@property (nonatomic, assign) CGFloat circleBoderWidth;
/**
 *  圆圈颜色
 */
@property (nonatomic, strong) UIColor *circleColor;
/**
 *  旋转状态
 */
@property (nonatomic, assign) YZTRefreshCircleState circleState;
/**
 *  从开始下拉到开始刷新总共旋转圈数，默认为1
 */
@property (nonatomic, assign) CGFloat totoalTurns;


- (instancetype)initWithFrame:(CGRect)frame andTotoalTurns:(CGFloat)turns circleColor:(UIColor*)circleColor;
/**
 *  下拉时设置当前旋转圈数,此处1为整圈。
 */
- (void)resetCurrentRotationAngle:(CGFloat)angle;
/**
 *  开始高速旋转
 */
- (void)startTurnningFast;
/**
 *  停止旋转
 */
- (void)stopTurnning;

@end






