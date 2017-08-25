//
//  ViewController.m
//  图片处理
//
//  Created by 林_同 on 2017/7/17.
//  Copyright © 2017年 林_同. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "UIImage+ImageRotate.h"

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView5;
@property (weak, nonatomic) IBOutlet UIImageView *imageView6;
@property (weak, nonatomic) IBOutlet UIImageView *imageView7;
@property (weak, nonatomic) IBOutlet UIImageView *imageView8;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self convertFormatTest];
    [self testImageGary];
    [self testImageReColor];
    [self testImageReColor2];
    [self testImageHighlight];
    [self imageRotate];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self configImageController];
}

- (void)convertFormatTest{
    
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    unsigned char *data = [self convertUIImageToData:image];
    UIImage *imageNew = [self convertDatatoUIImage:data image:image];
    self.imageView2.image = imageNew;
}

- (void)testImageGary{
    
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    unsigned char *imageData = [self convertUIImageToData:image];
    unsigned char *imageDataNew = [self imageCrayWithData:imageData width:image.size.width height:image.size.height];
    UIImage *imageNew = [self convertDatatoUIImage:imageDataNew image:image];
    self.imageView3.image = imageNew;
    
}

- (void)testImageReColor{
    
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    unsigned char *imageData = [self convertUIImageToData:image];
    unsigned char *imageDataNew = [self imageReColorWithData:imageData width:image.size.width height:image.size.height];
    UIImage *imageNew = [self convertDatatoUIImage:imageDataNew image:image];
    self.imageView4.image = imageNew;
    
}

- (void)testImageReColor2{
    
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    unsigned char *imageData = [self convertUIImageToData:image];
    unsigned char *imageGrayData = [self imageCrayWithData:imageData width:image.size.width height:image.size.height];
    unsigned char *imageDataNew = [self imageReColorWithData:imageGrayData width:image.size.width height:image.size.height];
    UIImage *imageNew = [self convertDatatoUIImage:imageDataNew image:image];
    self.imageView5.image = imageNew;
    
}

- (void)testImageHighlight{
    
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    unsigned char *imageData = [self convertUIImageToData:image];
    
    unsigned char *imageDataNew = [self imageHighlitWithData:imageData width:image.size.width height:image.size.height];
    
    UIImage *imageNew = [self convertDatatoUIImage:imageDataNew image:image];
    
    self.imageView6.image = imageNew;
    
}

- (void)imageRotate{
    self.imageView7.image = [[UIImage imageNamed:@"1.jpg"] imageRotateIndegree:45];
}

/*
 *    image转data
 */
- (unsigned char *)convertUIImageToData:(UIImage *)image{
    
    CGImageRef imageRef = [image CGImage];
    
    CGSize size = image.size;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //每个像素点4个Byte RGBA 像素点个数=宽*高
    void *data = malloc(size.width * size.height * 4);
    
    //每个像素点占多少字节    通过bitmap转换成Data
    CGContextRef context = CGBitmapContextCreate(data, size.width, size.height, 8, size.width * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGImageByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), imageRef);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    return (unsigned char *)data;
}

//将data转换成原image
- (UIImage *)convertDatatoUIImage:(unsigned char *)imageData image:(UIImage *)imageSource{
    
    CGFloat width = imageSource.size.width;
    CGFloat height = imageSource.size.height;
    NSInteger dataLength = width * height * 4;
    
    CGDataProviderRef provide = CGDataProviderCreateWithData(NULL, imageData, dataLength, NULL);
    
    //每个元素所占字节数
    int bitPerComponent = 8;
    //每个点所占字节数
    int bitPerPixe = 32;
    int bytesPerRow = 4 * width;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo info = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderIntent = kCGRenderingIntentDefault;
    
    //将数据转成CGImage
    CGImageRef imageRef = CGImageCreate(width, height, bitPerComponent, bitPerPixe, bytesPerRow , colorSpace, info, provide, NULL, NO, renderIntent);
    
    UIImage *imageNew = [UIImage imageWithCGImage:imageRef];
    
    CFRelease(imageRef);
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(provide);
    
    return imageNew;
}

//将图片转成灰色图片
- (unsigned char *)imageCrayWithData:(unsigned char *)imageData width:(CGFloat)width height:(CGFloat)height{
    
    unsigned char *resultData = malloc(width * height * sizeof(unsigned char *) * 4);
    memset(resultData, 0, width * height * sizeof(unsigned char *) * 4);
    
    //取像素点
    for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
            unsigned int imageIndex = h * width + w;
            unsigned char bitMapRed = *(imageData+imageIndex * 4);
            unsigned char bitMapGreen = *(imageData+imageIndex * 4 + 1);
            unsigned char bitMapBlue = *(imageData+imageIndex * 4 + 2);
            
            int bitMap = bitMapRed *77/255+bitMapGreen*151/255+bitMapBlue*88/255;
            unsigned char newBitMap = (bitMap > 255)?255:bitMap;
            
            memset(resultData+imageIndex*4, newBitMap, 1);//1像素
            memset(resultData+imageIndex*4+1, newBitMap, 1);
            memset(resultData+imageIndex*4+2, newBitMap, 1);
            
        }
    }
    return resultData;
}


//将图片颜色进行反转
- (unsigned char *)imageReColorWithData:(unsigned char *)imageData width:(CGFloat)width height:(CGFloat)height{
    unsigned char *resultData = malloc(width * height * sizeof(unsigned char *) * 4);
    memset(resultData, 0, width * height * sizeof(unsigned char *) * 4);
    
    //取像素点
    for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
            unsigned int imageIndex = h * width + w;
            unsigned char bitMapRed = *(imageData+imageIndex * 4);
            unsigned char bitMapGreen = *(imageData+imageIndex * 4 + 1);
            unsigned char bitMapBlue = *(imageData+imageIndex * 4 + 2);
            
            
            unsigned char bitMapRedNew = 255 - bitMapRed;
            unsigned char bitMapGreenNew = 255 - bitMapGreen;
            unsigned char bitMapBlueNew = 255 - bitMapBlue;
            
            memset(resultData+imageIndex*4, bitMapRedNew, 1);//1像素
            memset(resultData+imageIndex*4+1, bitMapGreenNew, 1);
            memset(resultData+imageIndex*4+2, bitMapBlueNew, 1);
            
        }
    }
    return resultData;
}

//高亮美白(抛物线)
- (unsigned char *)imageHighlitWithData:(unsigned char *)imageData width:(CGFloat)width height:(CGFloat)height{
    
    unsigned char *resultData = malloc(width * height * sizeof(unsigned char *) * 4);
    memset(resultData, 0, width * height * sizeof(unsigned char *) * 4);
    
    NSArray *colorArrayBase = @[@"55", @"110", @"155", @"185", @"220", @"240", @"250", @"255"];
    NSMutableArray *colorArray = [NSMutableArray array];
    
    int beforNum = 0;
    //取像素点
    for (int i = 0; i < colorArrayBase.count; i++) {
        NSString *numStr = colorArrayBase[i];
        int num = numStr.intValue;
        CGFloat step = 0;
        if (i == 0) {
            step = num/32.0;
        }else{
            step = (num - beforNum)/32.0;
        }
        for (int j = 0; j < 32; j++) {
            int newNum = 0;
            if (i == 0) {
                newNum = (int)(j*step);
            }else{
                newNum = (int)(beforNum+j*step);
            }
            NSString *newNumStr = [NSString stringWithFormat:@"%d", newNum];
            [colorArray addObject:newNumStr];
        }
        beforNum = num;
    }
    
    
    //取像素点
    for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
            unsigned int imageIndex = h * width + w;
            unsigned char bitMapRed = *(imageData+imageIndex * 4);
            unsigned char bitMapGreen = *(imageData+imageIndex * 4 + 1);
            unsigned char bitMapBlue = *(imageData+imageIndex * 4 + 2);
            
            
            NSString *redStr = [colorArray objectAtIndex:bitMapRed];
            NSString *greenStr = [colorArray objectAtIndex:bitMapGreen];
            NSString *blueStr = [colorArray objectAtIndex:bitMapBlue];
            
            unsigned char bitMapRedNew = redStr.intValue;
            unsigned char bitMapGreenNew = greenStr.intValue;
            unsigned char bitMapBlueNew = blueStr.intValue;
            
            memset(resultData+imageIndex*4, bitMapRedNew, 1);//1像素
            memset(resultData+imageIndex*4+1, bitMapGreenNew, 1);
            memset(resultData+imageIndex*4+2, bitMapBlueNew, 1);
            
        }
    }
    
    return resultData;
}

#pragma mark----相机
- (void)configImageController{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSString *mediaType = (__bridge NSString *)kUTTypeImage;
    picker.mediaTypes = @[mediaType];
    picker.delegate = self;
    
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        unsigned char *imageData = [self convertUIImageToData:[self fixOrientation:image]];
        unsigned char *imageDataNew = [self imageReColorWithData:imageData width:image.size.width height:image.size.height];
        
        UIImage *imageNew = [self convertDatatoUIImage:imageDataNew image:image];
        
        UIImageWriteToSavedPhotosAlbum(imageNew, nil, nil, nil);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


//图片超过3M会自动旋转
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation ==UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform =CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx =CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                            CGImageGetBitsPerComponent(aImage.CGImage),0,
                                            CGImageGetColorSpace(aImage.CGImage),
                                            CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg =CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
