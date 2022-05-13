//
//  UIImage+BY.m
//  NewProject_OC
//
//  Created by Bri.Yin on 2022/5/7.
//

#import "UIImage+BY.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <objc/runtime.h>

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
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShot;
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
    if (MAX(height, width) > maxHW) { // scale compress
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

- (CGSize)resetMaxWH:(CGFloat)WH {
    if (self == nil) {
        return CGSizeZero;
    }
    CGFloat height = self.size.height / self.scale;
    CGFloat width = self.size.width / self.scale;
    CGFloat maxHW = WH;
    if (MAX(height, width) < maxHW) {
        return self.size;
    }
    if (MAX(height, width) > maxHW) {
        CGFloat max = MAX(height, width);
        height = height * (maxHW / max);
        width = width * (maxHW / max);
    }
    return CGSizeMake(width, height);
}

- (void)savedToAlbumWithName:(NSString *)albumName successBlock:(void (^)(void))completeBlock failBlock:(void (^)(void))failBlock {
    ALAssetsLibrary *assets = [[ALAssetsLibrary alloc] init];
    [assets writeImageToSavedPhotosAlbum:self.CGImage orientation:(ALAssetOrientation)self.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        __block BOOL albumWasFound = NO;
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            // exist
            if ([albumName compare:[group valueForProperty:ALAssetsGroupPropertyName]] == NSOrderedSame) {
                albumWasFound = YES;
                [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    if ([group addAsset:asset]) {
                        completeBlock();
                    }
                } failureBlock:^(NSError *error) {
                    failBlock();
                }];
            }
            // inexistence
            if (group == nil && albumWasFound == NO) {
                __weak ALAssetsLibrary *weakSelf = assetsLibrary;
                [assetsLibrary addAssetsGroupAlbumWithName:albumName resultBlock:^(ALAssetsGroup *group) {
                    [weakSelf assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        if ([group addAsset:asset]) {
                            completeBlock();
                        }
                    } failureBlock:^(NSError *error) {
                        failBlock();
                    }];
                } failureBlock:^(NSError *error) {
                    failBlock();
                }];
                return;
            }
        } failureBlock:^(NSError *error) {
            failBlock();
        }];
    }];
}

- (void)savedToAlbumSuccessBlock:(void (^)(void))completeBlock failBlock:(void (^)(void))failBlock {
    UIImageWriteToSavedPhotosAlbum(self, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        if (self.completeBlock != nil) self.completeBlock();
    } else {
        if (self.failBlock != nil) self.failBlock();
    }
}

- (void (^)(void))failBlock {
    return objc_getAssociatedObject(self, failBlockKey);
}

- (void)setFailBlock:(void (^)(void))failBlock {
    objc_setAssociatedObject(self, failBlockKey, failBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(void))completeBlock {
    return objc_getAssociatedObject(self, completeBlockKey);
}

- (void)setCompleteBlock:(void (^)(void))completeBlock {
    objc_setAssociatedObject(self, completeBlockKey, completeBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)waterWithText:(NSString *)text direction:(ImageWaterDirect)direction fontColor:(UIColor *)fontColor fontPoint:(CGFloat)fontPoint marginXY:(CGPoint)marginXY {
    CGSize size = self.size;
    CGRect rect = (CGRect){CGPointZero, size};
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    [self drawInRect:rect];
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:fontPoint], NSForegroundColorAttributeName : fontColor};
    CGRect strRect = [self calWidth:text attr:attr direction:direction rect:rect marginXY:marginXY];
    [text drawInRect:strRect withAttributes:attr];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (CGRect)calWidth:(NSString *)str attr:(NSDictionary *)attr direction:(ImageWaterDirect)direction rect:(CGRect)rect marginXY:(CGPoint)marginXY {
    CGSize size = [str sizeWithAttributes:attr];
    CGRect calRect = [self rectWithRect:rect size:size direction:direction marginXY:marginXY];
    return calRect;
}

- (CGRect)rectWithRect:(CGRect)rect size:(CGSize)size direction:(ImageWaterDirect)direction marginXY:(CGPoint)marginXY {
    CGPoint point = CGPointZero;
    if (ImageWaterDirectTopRight == direction) point = CGPointMake(rect.size.width - size.width, 0);
    if (ImageWaterDirectBottomLeft == direction) point = CGPointMake(0, rect.size.height - size.height);
    if (ImageWaterDirectBottomRight == direction) point = CGPointMake(rect.size.width - size.width, rect.size.height - size.height);
    if (ImageWaterDirectCenter == direction) point = CGPointMake((rect.size.width - size.width) * .5f, (rect.size.height - size.height) * .5f);
    point.x += marginXY.x;
    point.y += marginXY.y;
    CGRect calRect = (CGRect){point, size};
    return calRect;
}

- (UIImage *)waterWithWaterImage:(UIImage *)waterImage direction:(ImageWaterDirect)direction waterSize:(CGSize)waterSize marginXY:(CGPoint)marginXY {
    CGSize size = self.size;
    CGRect rect = (CGRect){CGPointZero, size};
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    [self drawInRect:rect];
    CGSize waterImageSize = CGSizeEqualToSize(waterSize, CGSizeZero) ? waterImage.size : waterSize;
    CGRect calRect = [self rectWithRect:rect size:waterImageSize direction:direction marginXY:marginXY];
    [waterImage drawInRect:calRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)fixOrientation {
    if (self.imageOrientation == UIImageOrientationUp) return self;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
