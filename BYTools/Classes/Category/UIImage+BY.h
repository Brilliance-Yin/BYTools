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

/** Screenshot */
+ (UIImage *)captureWithView:(UIView *)view;
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;

/** 纯色Image */
+ (UIImage *)colorImage:(UIColor *)color;
+ (UIImage *)colorImage:(UIColor *)color size:(CGSize)size;

/** 按固定的最大比例压缩图片 */
- (UIImage *)allowMaxImg;
- (UIImage *)allowMaxImg_thum:(BOOL)thumbnail;

/** 图片要求的最大长宽 */
- (CGSize *)resetMaxWH:(CGFloat)WH;

/** 按比例重设图片大小 */
- (UIImage *)resizeRate:(CGFloat)rate;

/** 按比例、质量重设图片大小 */
- (UIImage *)resizeRate:(CGFloat)rate quality:(CGInterpolationQuality)quality;

/** save to album */
- (void)savedToAlbumSuccessBlock:(void (^)())completeBlock failBlock:(void (^)())failBlock;

/** save to the specified name album */
- (void)savedToAlbumWithName:(NSString *)albumName successBlock:(void (^)())completeBlock failBlock:(void (^)())failBlock;

/** watermark orientation */
typedef NS_ENUM(NSInteger, ImageWaterDirect) {
    ImageWaterDirectTopLeft = 0,
    ImageWaterDirectTopRight,
    ImageWaterDirectBottomLeft,
    ImageWaterDirectBottomRight,
    ImageWaterDirectCenter
}

/** Text水印 */
- (UIImage *)waterWithText:(NSString *)text direction:(ImageWaterDirect)direction fontColor:(UIColor *)fontColor fontPoint:(CGFloat)fontPoint marginXY:(CGPoint)marginXY;

/** Image水印 */
- (UIImage *)waterWithWaterImage:(UIImage *)waterImage direction:(ImageWaterDirect)direction waterSize:(CGSize)waterSize marginXY:(CGPoint)marginXY;

/** 旋转方向 */
- (UIImage *)fixOrientation;

@end

NS_ASSUME_NONNULL_END
