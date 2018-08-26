
#import <UIKit/UIKit.h>

@interface UIButton (SRExtension)

+ (instancetype)sr_textButton:(NSString *)title
                     fontSize:(CGFloat)fontSize
                  normalColor:(UIColor *)normalColor
             highlightedColor:(UIColor *)highlightedColor;

+ (instancetype)sr_textButton:(NSString *)title
                     fontSize:(CGFloat)fontSize
                  normalColor:(UIColor *)normalColor
             highlightedColor:(UIColor *)highlightedColor
          backgroundImageName:(NSString *)backgroundImageName;

+ (instancetype)sr_imageButton:(NSString *)imageName
           backgroundImageName:(NSString *)backgroundImageName;

@end
