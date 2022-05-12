//
//  UIView+BY.h
//  NewProject_OC
//
//  Created by Bri.Yin on 2022/5/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

CGPoint CGRectGetCenter(CGRect rect);
CGRect CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (BY)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, readonly) CGPoint bottomLeft;
@property (nonatomic, readonly) CGPoint bottomRight;
@property (nonatomic, readonly) CGPoint topRight;

- (void)moveBy:(CGPoint)delta;
- (void)scaleBy:(CGFloat)scaleFactor;
- (void)fitInSize:(CGSize)kSize;

/** 当前view所在控制器 */
- (UIViewController *)viewController;

// MARK: 其他效果
/** 变圆 */
- (UIView *)roundView;
/** 加阴影 */
- (void)addShadow;

typedef void (^ GestureActionBlock)(UIGestureRecognizer *gesture);
/** 单点手势 */
- (void)tapGesture:(GestureActionBlock)block;
/** 有次数的单击手势 tapsCount:点击次数 */
- (void)tapGesture:(GestureActionBlock)block numberOfTapsRequired:(NSUInteger)tapsCount;
/** 长按手势 */
- (void)longPressGesture:(GestureActionBlock)block;

/** 添加边框:四边 */
- (void)border:(UIColor *)color width:(CGFloat)width cornerRadius:(CGFloat)radius;
/** 添加边框:四边 默认4 */
- (void)border:(UIColor *)color width:(CGFloat)width;
/** 四边变圆 */
- (void)borderRoundCornerRadius:(CGFloat)radius;
/** 四边变圆 默认4*/
- (void)borderRound;

- (void)debug:(UIColor *)color width:(CGFloat)width;
/** 移除对应的View */
- (void)removeClassView:(Class)classView;

/** 画线 */
+ (CAShapeLayer *)drawLine:(CGPoint)points to:(CGPoint)point withColor:(UIColor *)color;
/** 画框框线 */
+ (CAShapeLayer *)drawRect:(CGRect)rect radius:(CGFloat)radius withColor:(UIColor *)color;
/** 画圆 */
+ (CAShapeLayer *)drawCircle:(CGPoint)point radius:(CGFloat)radius start:(CGFloat)start end:(CGFloat)end color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
