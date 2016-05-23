//
//  tabBar.h
//  weibo_myTest
//
//  Created by wkr on 16/3/14.
//  Copyright © 2016年 wkr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class tabBar;

@protocol tabBarDelegate <UITabBarDelegate>

@optional

- (void)tabBarDidClickPlusButton:(tabBar *)tabBar;

@end

@interface tabBar : UITabBar

@property (nonatomic, weak)id<tabBarDelegate>delegate;

@end
