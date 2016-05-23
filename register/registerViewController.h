//
//  registerViewController.h
//  pantao
//
//  Created by wkr on 16/5/5.
//  Copyright © 2016年 pantao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ptRegisterShowType) {
    ptRegisterShowType_NONE,
    ptRegisterShowType_USER,
    ptRegisterShowType_PASS
};

@protocol registerBackDelegate <NSObject>

- (void)registerBack:(NSString *)userName :(NSString *)passWord;

@end

@interface registerViewController : UIViewController

@property (nonatomic, weak) id<registerBackDelegate>delegate;

@end
