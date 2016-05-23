//
//  global.h
//  pantao
//
//  Created by wkr on 16/5/6.
//  Copyright © 2016年 pantao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface global : NSObject

+(global *)shareManager;

/**
 *     新浪微博授权后拿到的信息
 */
@property (nonatomic, strong) NSString *access_token; //采用OAuth授权方式为必填参数，OAuth授权后获得
@property (nonatomic, assign) int uid;//需要查询的用户ID。
@property (nonatomic, strong) NSString *screen_name; //需要查询的用户昵称。

@property (nonatomic, strong) NSDictionary *weiboUserInfoDict;// 用户信息

@end
