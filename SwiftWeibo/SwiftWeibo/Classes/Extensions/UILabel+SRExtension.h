
#import <UIKit/UIKit.h>

@interface UILabel (SRExtension)

+ (instancetype)sr_labelWithText:(NSString *)text
                    textFontSize:(CGFloat)fontSize
                       textColor:(UIColor *)color;

@end
