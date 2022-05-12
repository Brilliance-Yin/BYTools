//
//  UIImage+BY.m
//  NewProject_OC
//
//  Created by Bri.Yin on 2022/5/7.
//

#import "UIImage+BY.h"

@implementation UIImage (BY)

+ (UIImage *)captureWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [UIScreen mainScreen].scale);
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]];
        [invocation setTarget:self];
        [invocation setSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)];
        CGRect rect = view.bounds;
        BOOL arg = YES;
        [invocation setArgument:&rect atIndex:2];
        [invocation setArgument:&arg atIndex:3];
        [invocation invoke];
    }else {
        // before IOS7
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
}

- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return newImage;
}

+ (UIImage *)colorImage:(UIColor *)color size:(CGSize)size {
    CGRect rect = (CGRect){{0.0f, 0.0f}, size};
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)colorImage:(UIColor *)color {
    CGSize size = CGSizeMake(1.0f, 1.0f);
    return [self colorImage:color size:size];
}

- (UIImage *)resizeRate:(CGFloat)rate quality:(CGInterpolationQuality)quality {
    UIImage *resizeImage = nil;
    CGFloat width = self.size.width * rate;
    CGFloat height = self.size.height *rate;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [self drawInRect:CGRectMake(0, 0, width, height)];
    resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizeImage;
}

- (UIImage *)allowMaxImg_thum:(BOOL)thumbnail {
    if (self == nil) {
        return nil;
    }
    CGFloat height = self.size.height;
    CGFloat width = self.size.width;
    CGFloat maxHW = 800;
    if (thumbnail) {
        maxHW = 150; // thumbnail
    }
    if (MAX(height, width) > maxHW) { // 超过限制 比例压缩
        CGFloat max = MAX(height, width);
        height = height * (maxHW/max);
        width = width * (maxHW/max);
    }
    UIImage *newImage;
    UIGraphicsBeginImageContext(CGSizeMake((int)width, (int)height));
    [self drawInRect:CGRectMake(0, 0, (int)width, (int)height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)allowMaxImg {
    return [self allowMaxImg_thum:NO];
}

//- (CGSize *)resetMaxWH:(CGFloat)WH {
//    
//}

@end
