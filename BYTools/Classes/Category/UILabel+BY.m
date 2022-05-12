//
//  UILabel+BY.m
//  NewProject_OC
//
//  Created by Bri.Yin on 2022/5/6.
//

#import "UILabel+BY.h"
#import "UIView+BY.h"
#import "Constants.h"

@implementation UILabel (BY)

+ (UILabel *)frame:(CGRect)frame title:(NSString *)title font:(UIFont *)font color:(UIColor *)color line:(NSInteger)line addView:(UIView *)addView {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = font;
    if (color) {
        label.textColor = color;
    }
    label.text = title;
    label.numberOfLines = line;
    [addView addSubview:label];
    return label;
}

- (void)delLineStr:(NSString *)string {
    if (BYStrIsEmpty(string)) return;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, string.length)];
    [self setAttributedText:attrString];
}

- (void)underlineStr:(NSString *)string {
    if (BYStrIsEmpty(string)) return;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, string.length)];
    [self setAttributedText:attrString];
}

- (void)settingLabelHeightOfRowString:(NSString *)string {
    [self settingLabelRowHeight:10 string:string];
}

- (void)settingLabelRowHeight:(CGFloat)height string:(NSString *)string {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:height];
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    self.attributedText = attrString;
    [self sizeToFit];
}

- (void)htmlString:(NSString *)string {
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    self.attributedText = attrString;
}

- (void)htmlString:(NSString *)string labelRowOfHeight:(CGFloat)height {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:height];
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attrString length])];
    self.attributedText = attrString;
    [self sizeToFit];
}

- (void)setText:(NSString *)text lineSpacing:(CGFloat)lineSpacing {
    if (lineSpacing < 0.01 || !text) {
        self.text = text;
        return;
    }
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    [attrString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, text.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    self.attributedText = attrString;
}

+ (CGFloat)text:(NSString *)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.numberOfLines = 0;
    [label setText:text lineSpacing:lineSpacing];
    [label sizeToFit];
    return label.height;
}

@end
