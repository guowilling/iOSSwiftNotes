
#import <Foundation/Foundation.h>

@interface NSString (SRBase64)

/// BASE 64 编码
- (NSString *)sr_base64Encode;

/// BASE 64 解码
- (NSString *)sr_base64Decode;

@end
