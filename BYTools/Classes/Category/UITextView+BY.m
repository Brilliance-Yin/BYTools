//
//  UITextView+BY.m
//  NewProject_OC
//
//  Created by Bri.Yin on 2022/5/5.
//

#import "UITextView+BY.h"
#import "UIView+BY.h"

@implementation UITextView (BY)

- (void)insertAttributedText:(NSAttributedString *)text {
    [self insertAttributedText:text settingBlock:nil];
}

- (void)insertAttributedText:(NSAttributedString *)text settingBlock:(void (^)(NSMutableAttributedString * _Nonnull))settingBlock {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    [attributedText appendAttributedString:self.attributedText];
    // 拼接其他文字
    NSUInteger loc = self.selectedRange.location;
    // 替换选中的内容
    [attributedText replaceCharactersInRange:self.selectedRange withAttributedString:text];
    if (settingBlock) {
        settingBlock(attributedText);
    }
    self.attributedText = attributedText;
    // 移除光标到表情后
    self.selectedRange = NSMakeRange(loc + 1, 0);
}

- (void)setText:(NSString *)text lineSpacing:(CGFloat)lineSpacing {
    if (lineSpacing < 0.01 || !text) {
        self.text = text;
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, text.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    
    self.attributedText = attributedString;
}

+ (CGFloat)text:(NSString *)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing {
    UITextView *textView = [[UITextView alloc] init];
    textView.font = [UIFont systemFontOfSize:fontSize];
    [textView setText:text lineSpacing:lineSpacing];
    [textView sizeToFit];
    return textView.height;
}

@end
