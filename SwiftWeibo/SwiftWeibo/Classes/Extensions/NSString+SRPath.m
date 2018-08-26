
#import "NSString+SRPath.h"

@implementation NSString (SRPath)

- (NSString *)sr_appendDocumentDir {
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}

- (NSString *)sr_appendCacheDir {
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}

- (NSString *)sr_appendTempDir {
    NSString *dir = NSTemporaryDirectory();
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}

@end
