
#import "UIButton+SRExtension.h"

@implementation UIButton (SRExtension)

+ (instancetype)sr_textButton:(NSString *)title
                     fontSize:(CGFloat)fontSize
                  normalColor:(UIColor *)normalColor
             highlightedColor:(UIColor *)highlightedColor
{
    return [self sr_textButton:title
                      fontSize:fontSize
                   normalColor:normalColor
              highlightedColor:highlightedColor
           backgroundImageName:nil];
}

+ (instancetype)sr_textButton:(NSString *)title
                     fontSize:(CGFloat)fontSize
                  normalColor:(UIColor *)normalColor
             highlightedColor:(UIColor *)highlightedColor
          backgroundImageName:(NSString *)backgroundImageName
{
    UIButton *button = [[self alloc] init];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    [button setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    if (backgroundImageName != nil) {
        [button setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
        NSString *backgroundImageNameHL = [backgroundImageName stringByAppendingString:@"_highlighted"];
        [button setBackgroundImage:[UIImage imageNamed:backgroundImageNameHL] forState:UIControlStateHighlighted];
    }
    [button sizeToFit];
    return button;
}

+ (instancetype)sr_imageButton:(NSString *)imageName
           backgroundImageName:(NSString *)backgroundImageName
{
    UIButton *button = [[self alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    NSString *imageNameHL = [imageName stringByAppendingString:@"_highlighted"];
    [button setImage:[UIImage imageNamed:imageNameHL] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
    NSString *backgroundImageNameHL = [backgroundImageName stringByAppendingString:@"_highlighted"];
    [button setBackgroundImage:[UIImage imageNamed:backgroundImageNameHL] forState:UIControlStateHighlighted];
    [button sizeToFit];
    return button;
}

@end
