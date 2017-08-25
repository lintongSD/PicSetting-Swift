
//
//  UIImage+ImageRotate.m
//  GIFViewPlayer
//
//  Created by 林_同 on 2017/7/27.
//  Copyright © 2017年 林_同. All rights reserved.
//

#import "UIImage+ImageRotate.h"
//#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@implementation UIImage (ImageRotate)

- (UIImage *)imageRotateIndegree:(float)degree{
    
    size_t width = self.size.width * self.scale;
    size_t height = self.size.height * self.scale;
    
    size_t bytesPerRow = width * 4;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGImageAlphaInfo alphaInfo = kCGImageAlphaPremultipliedFirst;
    
    //配置上下文属性
    CGContextRef contextRef = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrderDefault | alphaInfo);
    if (!contextRef) {
        return nil;
    }
    //图像缩放
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), self.CGImage);
    
    //图像旋转
    UInt8 *data = (UInt8 *)CGBitmapContextGetData(contextRef);
    vImage_Buffer src = {data, height, width, bytesPerRow};
    vImage_Buffer dest = {data, height, width, bytesPerRow};
    Pixel_8888 bgColor = {0, 0, 0, 0};
    
    vImageRotate_ARGB8888(&src, &dest, NULL, degree*M_PI/180, bgColor, kvImageBackgroundColorFill);
    
    CGImageRef lastImage = CGBitmapContextCreateImage(contextRef);
    
    UIImage *newImage = [UIImage imageWithCGImage:lastImage scale:self.scale orientation:UIImageOrientationUp];
    
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(contextRef);
    
    return newImage;
}

@end
