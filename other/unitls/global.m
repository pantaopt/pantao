//
//  global.m
//  pantao
//
//  Created by wkr on 16/5/6.
//  Copyright © 2016年 pantao. All rights reserved.
//

#import "global.h"

@implementation global

+(global *)shareManager
{
    static global *shareGlobal = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        shareGlobal = [[self alloc]init];
    });
    return shareGlobal;
}

@end
