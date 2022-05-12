//
//  UIImage+BY.h
//  NewProject_OC
//
//  Created by Bri.Yin on 2022/5/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static const void *completeBlockKey = &completeBlockKey;
static const void *failBlockKey = &failBlockKey;

@interface UIImage ()

@property (nonatomic, copy) void (^completeBlock)(void);
@property (nonatomic, copy) void (^failBlock)(void);

@end

@interface UIImage (BY)

/** 截图 */
//+ (UIImage *)captureWithView:(UIView *)view;
//- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;
//
///** 纯色 图 */
//+ (UIImage *)colorImage:(UIColor *)color;
//+ (UIImage *)colorImage:(UIColor *)color size:(CGSize)size;
//
///** 按固定的最大比例压缩图片 */
//- (UIImage *)allowMaxImg;
//- (UIImage *)allowMaxImg_thum:(BOOL)thumbnail;


@end

NS_ASSUME_NONNULL_END
