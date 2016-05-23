//
//  UIImage+createRoundedRectImage.h
//  pantao
//
//  Created by wkr on 16/5/9.
//  Copyright © 2016年 pantao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (createRoundedRectImage)

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;

@end
