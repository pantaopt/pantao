//
//  UIImage+captureView.m
//  02-画画板
//
//  Created by apple on 14-6-12.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "UIImage+captureView.h"

@implementation UIImage (CaptureView)

+ (UIImage *)captureImageWithView:(UIView *)view
{
    // 1.创建bitmap上下文
    UIGraphicsBeginImageContext(view.frame.size);
    // 2.将要保存的view的layer绘制到bitmap上下文中
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    // 3.取出绘制号的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    return newImage;
}


@end
