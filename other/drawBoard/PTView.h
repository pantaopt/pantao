//
//  NYView.h
//  画画板
//
//  Created by apple on 15-5-6.
//  Copyright (c) 2015年 znycat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTView : UIView

- (void)clearView;
- (void)backView;
@property (nonatomic, strong) UIColor *penColor;// 线色
@property (nonatomic, assign) float penWidth;// 线宽
@property (nonatomic, assign) NSInteger pathIndex;// 记更换颜色(或线宽)时候此刻path数组最后一个元素的下标
@property (nonatomic, strong) NSMutableArray *colorArr;
@end
