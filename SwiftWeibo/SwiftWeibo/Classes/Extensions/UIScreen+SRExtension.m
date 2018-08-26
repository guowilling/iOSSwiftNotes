
#import "UIScreen+SRExtension.h"

@implementation UIScreen (SRExtension)

+ (CGFloat)sr_screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)sr_screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)sr_scale {
    return [UIScreen mainScreen].scale;
}

@end
