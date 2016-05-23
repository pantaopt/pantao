//
//  YZTRefreshBackNormalFooter.h
//
//  Created by chuckon on 15/4/24.
//  Copyright (c) 2015年 pinan. All rights reserved.
//

#import "YZTRefreshCircle.h"
#import "MJRefreshBackNormalFooter.h"

@interface YZTRefreshBackNormalFooter : MJRefreshBackNormalFooter

@property (nonatomic, strong) YZTRefreshCircle *circle;

@property (nonatomic, strong) UIColor *circleColor;

@property (nonatomic, strong) UIColor *stateTextColor;

@property (nonatomic, assign) CGFloat offSetY;

@end
