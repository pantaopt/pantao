//
//  UIScrollView+YZTRefresh.h
//  MJ新版
//
//  Created by ChuckonYin on 16/2/22.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (YZTRefreshHeader)

/**
// *  隐藏头刷新时间， 默认隐藏
 */
@property (nonatomic, assign, readwrite) BOOL hiddenHeaderLastRefreshTime;
/**
 *  获取刷新状态
 */
@property (nonatomic, assign, readonly) BOOL headerRefreshing;
@property (nonatomic, assign, readonly) BOOL isHeaderRefreshing;
//header
- (void)yzt_addHeaderWithCallback:(void(^)())callback;
- (void)yzt_addHeaderWithTarget:(id)target action:(SEL)sel;
- (void)yzt_headerBeginRefreshing;
- (void)yzt_headerEndRefreshing;
- (void)yzt_adjustHeaderContentOffSet:(CGFloat)y;
/**
 *  please use : yzt_adjustRefreshHeaderToYZTGlobalColor:kGlobalColor
 */
- (void)yzt_setHeaderRefreshingTextColorWhite:(BOOL)isCustom;
- (void)yzt_setRefreshingArrowColorWhite:(BOOL)isCustom;
/**
 *  刷新头为橙色的，适配文字颜色和背景色
 */
- (void)yzt_adjustRefreshHeaderToYZTGlobalColor:(UIColor *)bgColors;
/**
 *  *******弃用：不再显示时间*******
 */
- (void)yzt_addHeaderWithTarget:(id)target action:(SEL)sel dateKey:(NSString*)dateKey;
/**
 *  自定义刷新动画和文字颜色
 */
- (void)yzt_setRefreshStateTextAndCircleColor:(UIColor *)color;

@end

@interface UIScrollView (YZTRefreshFooter)

@property (nonatomic, assign, readonly) BOOL footerRefreshing;
//footer
- (void)yzt_addFooterWithCallback:(void (^)())callback;
- (void)yzt_addFooterWithTarget:(id)target action:(SEL)action;
- (void)yzt_footerBeginRefreshing;
- (void)yzt_footerEndRefreshing;

/**
 *  不支持修改
 */
- (void)yzt_setFooterRefreshingText:(NSString*)text;

@end





