//
//  loginViewController.h
//  pantao
//
//  Created by wkr on 16/5/5.
//  Copyright © 2016年 pantao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ptLoginShowType) {
    ptLoginShowType_NONE,
    ptLoginShowType_USER,
    ptLoginShowType_PASS
};

@protocol loginBackDelegate <NSObject>

- (void)loginBack;

- (void)makeMPMoviePlayertoNil;

@end

@interface loginViewController : UIViewController

@property (nonatomic, weak) id<loginBackDelegate>delegate;

@property (nonatomic, strong) NSString *userNameTXT;

@property (nonatomic, strong) NSString *passWordTXT;

@end
