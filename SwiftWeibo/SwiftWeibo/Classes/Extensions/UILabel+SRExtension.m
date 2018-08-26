
#import "UILabel+SRExtension.h"

@implementation UILabel (SRExtension)

+ (instancetype)sr_labelWithText:(NSString *)text
                    textFontSize:(CGFloat)fontSize
                       textColor:(UIColor *)color
{
    UILabel *label = [[self alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = color;
    label.numberOfLines = 0;
    [label sizeToFit];
    return label;
}

@end
