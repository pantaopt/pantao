//
//  cityHeaderView.h
//  pantao
//
//  Created by wkr on 16/5/16.
//  Copyright © 2016年 pantao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol clickCityBtnDelegate <NSObject>

- (void)clickCityBtn;

@end

@interface cityHeaderView : UIView

@property (nonatomic, weak) id<clickCityBtnDelegate>delegate;

@property (nonatomic, strong) UILabel *currentCity;

@end
