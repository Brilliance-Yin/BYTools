//
//  UITextView+BY.h
//  NewProject_OC
//
//  Created by Bri.Yin on 2022/5/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (BY)

- (void)insertAttributedText:(NSAttributedString *)text;
- (void)insertAttributedText:(NSAttributedString *)text settingBlock:(void (^ __nullable)(NSMutableAttributedString *attributedText))settingBlock;

/** 设置行距 */
- (void)setText:(NSString *)text lineSpacing:(CGFloat)lineSpacing;

/** 计算行高 */
+ (CGFloat)text:(NSString *)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;

@end

NS_ASSUME_NONNULL_END
