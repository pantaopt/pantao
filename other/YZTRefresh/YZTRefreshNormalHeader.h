//
//  YZTRefreshNormalHeader.h
//
//  Created by Chuckon Yin on 16/2/24.
//  Copyright (c) 2015年 PingAn. All rights reserved.
//

//#import "MJRefreshStateHeader.h"
#import "YZTRefreshCircle.h"
#import "MJRefresh.h"

@interface YZTRefreshNormalHeader : MJRefreshNormalHeader

@property (nonatomic, strong) YZTRefreshCircle *circle;

@property (nonatomic, strong) UIColor *circleColor;

@property (nonatomic, strong) UIColor *stateTextColor;

@property (nonatomic, assign) CGFloat offSetY;

@end

//const CGFloat MJRefreshHeaderHeight = 35.0;
//const CGFloat MJRefreshFooterHeight = 35.0;
//const CGFloat MJRefreshFastAnimationDuration = 0.25;
//const CGFloat MJRefreshSlowAnimationDuration = 0.4;
//
//NSString *const MJRefreshKeyPathContentOffset = @"contentOffset";
//NSString *const MJRefreshKeyPathContentInset = @"contentInset";
//NSString *const MJRefreshKeyPathContentSize = @"contentSize";
//NSString *const MJRefreshKeyPathPanState = @"state";
//
//NSString *const MJRefreshHeaderLastUpdatedTimeKey = @"MJRefreshHeaderLastUpdatedTimeKey";
//
//NSString *const MJRefreshHeaderIdleText = @"下拉刷新";
//NSString *const MJRefreshHeaderPullingText = @"放手，是一种态度";
//NSString *const MJRefreshHeaderRefreshingText = @"正在加载...";
//
//NSString *const MJRefreshAutoFooterIdleText = @"点击或上拉加载更多";
//NSString *const MJRefreshAutoFooterRefreshingText = @"正在加载...";
//NSString *const MJRefreshAutoFooterNoMoreDataText = @"已显示全部";
//
//NSString *const MJRefreshBackFooterIdleText = @"上拉可加载更多";
//NSString *const MJRefreshBackFooterPullingText = @"放手，是一种态度";
//NSString *const MJRefreshBackFooterRefreshingText = @"正在加载...";
//NSString *const MJRefreshBackFooterNoMoreDataText = @"已显示全部";



