//
//  netWorking.h
//  afnTest
//
//  Created by ma c on 15/12/8.
//  Copyright (c) 2015年 chunxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^SuccessBlock)(id responseBody);

typedef void(^FailureBlock)(NSDictionary *error);

@interface netWorking : NSObject

+(netWorking *)sharedManager;
-(AFHTTPRequestOperationManager *)baseHttpRequest;

#pragma mark get
-(void)getResultWithParameter:(NSDictionary *)paramer url:(NSString *)url successBlock:(SuccessBlock)successblock failureBlock:(FailureBlock)failureblock;

#pragma mark post
-(void)postResultWithParameter:(NSDictionary *)paramer url:(NSString *)url successBlock:(SuccessBlock)successblock failureBlock:(FailureBlock)failureblock;

@end
