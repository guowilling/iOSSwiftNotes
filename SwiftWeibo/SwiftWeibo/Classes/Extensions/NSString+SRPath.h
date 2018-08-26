
#import <Foundation/Foundation.h>

@interface NSString (SRPath)

- (NSString *)sr_appendDocumentDir;

- (NSString *)sr_appendCacheDir;

- (NSString *)sr_appendTempDir;

@end
