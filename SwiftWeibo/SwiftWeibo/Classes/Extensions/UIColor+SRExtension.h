
#import <UIKit/UIKit.h>

@interface UIColor (SRExtension)

/**
 使用 16 进制数字创建 UIColor, 例如 0xFF0000 创建红色

 @param hex 16 进制无符号32位整数
 @return UIColor Object
 */
+ (instancetype)sr_colorWithHex:(uint32_t)hex;

/**
 随机颜色

 @return UIColor Object
 */
+ (instancetype)sr_randomColor;

/**
 使用 R / G / B 值创建 UIColor

 @param red R
 @param green G
 @param blue B
 @return UIColor Object
 */
+ (instancetype)sr_colorWithRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue;

@end
