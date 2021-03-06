//
//  UIImage+Helpers.m
//  JSONPlaceholder
//
//  Created by Leonid Kokhnovych on 2018-06-02.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

#import "UIImage+Helpers.h"

@implementation UIImage (Helpers)

// Implementation based on the code snippet from here: https://gist.github.com/steipete/1144242
- (UIImage *)preloadedImage {
    CGImageRef image = self.CGImage;
    
    // make a bitmap context of a suitable size to draw to, forcing decode
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef imageContext =  CGBitmapContextCreate(NULL, width, height, 8, width*4, colourSpace,
                                                       kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    CGColorSpaceRelease(colourSpace);
    
    // draw the image to the context, release it
    CGContextDrawImage(imageContext, CGRectMake(0, 0, width, height), image);
    
    // now get an image ref from the context
    CGImageRef outputImage = CGBitmapContextCreateImage(imageContext);
    
    UIImage *cachedImage = [UIImage imageWithCGImage:outputImage];
    
    // clean up
    CGImageRelease(outputImage);
    CGContextRelease(imageContext);
    
    return cachedImage;
}

@end
