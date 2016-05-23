//
//  netWorking.m
//  afnTest
//
//  Created by ma c on 15/12/8.
//  Copyright (c) 2015年 chunxiang. All rights reserved.
//

#import "netWorking.h"

@implementation netWorking

+(netWorking *)sharedManager
{
    static netWorking *sharedNetworing = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedNetworing = [[self alloc]init];
    });
    return sharedNetworing;
}

-(AFHTTPRequestOperationManager *)baseHttpRequest
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setTimeoutInterval:20];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html",@"application/javascript",@"application/json", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    return manager;
}

-(void)getResultWithParameter:(NSDictionary *)paramer url:(NSString *)url successBlock:(SuccessBlock)successblock failureBlock:(FailureBlock)failureblock
{
    AFHTTPRequestOperationManager *manager = [self baseHttpRequest];
    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:urlStr parameters:paramer success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successblock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureblock(error.userInfo);
    }];
}

-(void)postResultWithParameter:(NSDictionary *)paramer url:(NSString *)url successBlock:(SuccessBlock)successblock failureBlock:(FailureBlock)failureblock
{
    AFHTTPRequestOperationManager *manager = [self baseHttpRequest];
    NSString *urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:urlStr parameters:paramer success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successblock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureblock(error.userInfo);
    }];
}

@end
