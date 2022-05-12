//
//  UILabel+BY.h
//  NewProject_OC
//
//  Created by Bri.Yin on 2022/5/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (BY)

+ (UILabel *)frame:(CGRect)frame title:(NSString *)title font:(UIFont *)font color:(UIColor *)color line:(NSInteger)line addView:(UIView *)addView;

/** 删除线 */
- (void)delLineStr:(NSString *)string;
/** 下划线 */
- (void)underlineStr:(NSString *)string;
/** 设置行高 默认：10 */
- (void)settingLabelHeightOfRowString:(NSString *)string;
/** 设置行高 */
- (void)settingLabelRowHeight:(CGFloat)height string:(NSString *)string;
/** 设置html代码格式string */
- (void)htmlString:(NSString *)string;
/** 设置html代码格式string & 行高 */
- (void)htmlString:(NSString *)string labelRowOfHeight:(CGFloat)height;
/** 设置行距 */
- (void)setText:(NSString *)text lineSpacing:(CGFloat)lineSpacing;
/** 计算行高 */
+ (CGFloat)text:(NSString *)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;

@end

NS_ASSUME_NONNULL_END
