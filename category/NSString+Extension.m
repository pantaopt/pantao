//
//  NSString+Extension.m
//  pantao
//
//  Created by wkr on 16/5/16.
//  Copyright © 2016年 pantao. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+ (BOOL)checkConvertNull:(NSString *)object{
    if ([object isEqual:[NSNull null]] || [object isKindOfClass:[NSNull class]] ||object==nil || [object isEqualToString:@""]) {
        return YES;
    }else{
        return NO;
    }
}

@end
