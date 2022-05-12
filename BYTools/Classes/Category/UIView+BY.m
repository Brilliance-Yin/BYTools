//
//  UIView+BY.m
//  NewProject_OC
//
//  Created by Bri.Yin on 2022/5/5.
//

#import "UIView+BY.h"
#import <objc/runtime.h>

CGPoint CGRectGetCenter(CGRect rect) {
    CGPoint point;
    point.x = CGRectGetMidX(rect);
    point.y = CGRectGetMidY(rect);
    return point;
}

CGRect CGRectMoveToCenter(CGRect rect, CGPoint center) {
    CGRect newRect = CGRectZero;
    newRect.origin.x = center.x - CGRectGetMidX(rect);
    newRect.origin.y = center.y - CGRectGetMidY(rect);
    newRect.size = rect.size;
    return newRect;
}

@implementation UIView (BY)

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    CGRect newFrame = self.frame;
    newFrame.origin.x = x;
    self.frame = newFrame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    CGRect newFrame = self.frame;
    newFrame.origin.y = y;
    self.frame = newFrame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)radius {
    return self.layer.cornerRadius;
}

- (void)setRadius:(CGFloat)radius {
    if (radius <= 0) {
        radius = self.width * 0.5f;
    }
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect newFrame = self.frame;
    newFrame.origin = origin;
    self.frame = newFrame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect newFrame = self.frame;
    newFrame.size = size;
    self.frame = newFrame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect newFrame = self.frame;
    newFrame.size.height = height;
    self.frame = newFrame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    self.frame = newFrame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    CGRect newFrame = self.frame;
    newFrame.origin.y = top;
    self.frame = newFrame;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    CGRect newFrame = self.frame;
    newFrame.origin.x = left;
    self.frame = newFrame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect newFrame = self.frame;
    newFrame.origin.y = bottom - self.frame.size.height;
    self.frame = newFrame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGFloat delta = right - (self.frame.origin.x + self.frame.size.width);
    CGRect newFrame = self.frame;
    newFrame.origin.x += delta;
    self.frame = newFrame;
}

- (CGPoint)topRight {
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}

- (CGPoint)bottomRight {
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)bottomLeft {
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (void)moveBy:(CGPoint)delta {
    CGPoint newCenter = self.center;
    newCenter.x += delta.x;
    newCenter.y += delta.y;
    self.center = newCenter;
}

- (void)scaleBy:(CGFloat)scaleFactor {
    CGRect newFrame = self.frame;
    newFrame.size.width *= scaleFactor;
    newFrame.size.height *= scaleFactor;
    self.frame = newFrame;
}

- (void)fitInSize:(CGSize)kSize {
    CGFloat scale;
    CGRect newFrame = self.frame;
    if (newFrame.size.height && (newFrame.size.height > kSize.height)) {
        scale = kSize.height / newFrame.size.height;
        newFrame.size.width *= scale;
        newFrame.size.height *= scale;
    }
    if (newFrame.size.width && (newFrame.size.width > kSize.width)) {
        scale = kSize.width / newFrame.size.width;
        newFrame.size.width *= scale;
        newFrame.size.height *= scale;
    }
    self.frame = newFrame;
}

- (UIViewController *)viewController {
    UIResponder *next = self.nextResponder;
    while (next != nil) {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }
    return nil;
}

- (UIView *)roundView {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.width / 2;
    return self;
}

// MARK: 加阴影
- (void)addShadow {
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.24;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, self.height - 2, self.width == 320 ? [UIScreen mainScreen].bounds.size.width : self.width, 2)].CGPath;
}

// MARK: 添加边框:四边
- (void)border:(UIColor *)color width:(CGFloat)width cornerRadius:(CGFloat)radius {
    if (radius == 0) {
        [self border:color width:width];
    }else {
        CALayer *layer = self.layer;
        if (color != nil) {
            layer.borderColor = color.CGColor;
        }
        layer.cornerRadius = radius;
        layer.masksToBounds = YES;
        layer.borderWidth = width;
    }
}

// MARK: 四边变圆
- (void)borderRoundCornerRadius:(CGFloat)radius {
    CALayer *layer = self.layer;
    layer.cornerRadius = radius;
    layer.masksToBounds = YES;
}

// MARK: 添加边框
- (void)border:(UIColor *)color width:(CGFloat)width {
    CALayer *layer = self.layer;
    if (color != nil) {
        layer.borderColor = color.CGColor;
    }
    layer.cornerRadius = 4;
    layer.masksToBounds = YES;
    layer.borderWidth = width;
}

- (void)borderRound {
    CALayer *layer = self.layer;
    layer.cornerRadius = 4;
    layer.masksToBounds = YES;
}

// MARK: 移除对应的View
- (void)removeClassView:(Class)classView {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:classView]) {
            [view removeFromSuperview];
        }
    }
}

// MARK: 调试
- (void)debug:(UIColor *)color width:(CGFloat)width {
#ifdef DEBUG
    if (color == nil) {
        [self border:[UIColor colorWithRed:(arc4random() % 255) / 255.0f green:(arc4random() % 255) / 255.0f blue:(arc4random() % 255) / 255.0f alpha:1] width:width];
        return;
    }
    [self border:color width:width];
#endif
}

static char kActionHandlerTapBlockKey;
static char kActionHandlerTapGestureKey;
static char kActionHandlerLongPressBlockKey;
static char kActionHandlerLongPressGestureKey;

// MARK: 单击手势
- (void)tapGesture:(GestureActionBlock)block {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kActionHandlerTapGestureKey);
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kActionHandlerTapBlockKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)tapGesture:(GestureActionBlock)block numberOfTapsRequired:(NSUInteger)tapsCount {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kActionHandlerTapGestureKey);
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        gesture.numberOfTapsRequired = tapsCount;
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForTapGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        GestureActionBlock block = objc_getAssociatedObject(self, &kActionHandlerTapBlockKey);
        if (block) {
            block(gesture);
        }
    }
}

- (void)longPressGesture:(GestureActionBlock)block {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &kActionHandlerLongPressGestureKey);
    if (!gesture) {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForLongPressGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForLongPressGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        GestureActionBlock block = objc_getAssociatedObject(self, &kActionHandlerLongPressBlockKey);
        if (block) {
            block(gesture);
        }
    }
}

// MARK: 画线
+ (CAShapeLayer *)drawLine:(CGPoint)points to:(CGPoint)point withColor:(UIColor *)color {
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:points];
    [path addLineToPoint:point];
    [path closePath];
    layer.path = path.CGPath;
    layer.strokeColor = color.CGColor;
    layer.fillColor = UIColor.whiteColor.CGColor;
    layer.lineWidth = 1;
    return layer;
}

+ (CAShapeLayer *)drawRect:(CGRect)rect radius:(CGFloat)radius withColor:(UIColor *)color {
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *solidPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    layer.lineWidth = 1.0f;
    layer.strokeColor = color.CGColor;
    layer.fillColor = UIColor.clearColor.CGColor;
    layer.path = solidPath.CGPath;
    return layer;
}

+ (CAShapeLayer *)drawCircle:(CGPoint)point radius:(CGFloat)radius start:(CGFloat)start end:(CGFloat)end color:(UIColor *)color {
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:radius startAngle:start endAngle:end clockwise:YES];
    layer.lineWidth = 1.0f;
    layer.strokeColor = color.CGColor;
    layer.fillColor = UIColor.clearColor.CGColor;
    layer.path = path.CGPath;
    return layer;
}

@end
