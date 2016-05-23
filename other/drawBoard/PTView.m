//
//  NYView.m
//  画画板
//
//  Created by apple on 15-5-6.
//  Copyright (c) 2015年 znycat. All rights reserved.
//

#import "PTView.h"

@interface PTView ()

@property (nonatomic, strong) NSMutableArray *paths;

@end

@implementation PTView

- (NSMutableArray *)paths
{
    if (_paths == nil) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}

- (NSMutableArray *)colorArr
{
    if (_colorArr == nil) {
        _colorArr = [NSMutableArray array];
    }
    return _colorArr;
}

// 开始触摸
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    // 1.获取手指对应UITouch对象
    UITouch *touch = [touches anyObject];
    // 2.通过UITouch对象获取手指触摸的位置
    CGPoint startPoint = [touch locationInView:touch.view];
    
    // 3.当用户手指按下的时候创建一条路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 3.1设置路径的相关属性
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineCapStyle:kCGLineCapRound];
    [path setLineWidth:_penWidth];
    [self.colorArr addObject:_penColor];
    // 4.设置当前路径的起点
    [path moveToPoint:startPoint];
    // 5.将路径添加到数组中
    [self.paths addObject:path];
    
}
// 移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 1.获取手指对应UITouch对象
    UITouch *touch = [touches anyObject];
    // 2.通过UITouch对象获取手指触摸的位置
    CGPoint movePoint = [touch locationInView:touch.view];
    
    // 3.取出当前的path
    UIBezierPath *currentPaht = [self.paths lastObject];
    // 4.设置当前路径的终点
    [currentPaht addLineToPoint:movePoint];
    
    // 6.调用drawRect方法重回视图
    [self setNeedsDisplay];
    
}

// 离开view(停止触摸)
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self touchesMoved:touches withEvent:event];
    /*
     // 1.获取手指对应UITouch对象
     UITouch *touch = [touches anyObject];
     // 2.通过UITouch对象获取手指触摸的位置
     CGPoint endPoint = [touch locationInView:touch.view];
     
     // 3.取出当前的path
     UIBezierPath *currentPaht = [self.paths lastObject];
     // 4.设置当前路径的终点
     [currentPaht addLineToPoint:endPoint];
     
     // 6.调用drawRect方法重回视图
     [self setNeedsDisplay];
     */
    
}

// 画线
- (void)drawRect:(CGRect)rect
{
    
    // 边路数组绘制所有的线段
    for (UIBezierPath *path in self.paths) {
        UIColor *color = [self.colorArr objectAtIndex:[self.paths indexOfObject:path]];
        [color set];
        [path stroke];
    }
}


- (void)clearView
{
    [self.paths removeAllObjects];
    [self.colorArr removeAllObjects];
    [self setNeedsDisplay];
}
- (void)backView
{
    [self.paths removeLastObject];
    [self.colorArr removeLastObject];
    [self setNeedsDisplay];
}



@end
