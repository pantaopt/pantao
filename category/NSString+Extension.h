//
//  NSString+Extension.h
//  pantao
//
//  Created by wkr on 16/5/16.
//  Copyright © 2016年 pantao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 *  检测一个是否唯恐
 *
 *  @param object 输入
 *
 *  @return 为空YES,不为空NO
 */
+ (BOOL)checkConvertNull:(NSString *)object;

@end
