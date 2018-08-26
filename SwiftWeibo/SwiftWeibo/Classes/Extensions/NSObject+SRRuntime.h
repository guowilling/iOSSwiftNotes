
#import <Foundation/Foundation.h>

@interface NSObject (SRRuntime)

/**
 通过字典数组创建当前类的对象数组

 @param dictArray 字典数组
 @return 对象数组
 */
+ (NSArray *)sr_objectsWithArray:(NSArray *)dictArray;

/**
 返回当前类的属性数组

 @return 属性数组
 */
+ (NSArray *)sr_propertiesList;

/**
 返回当前类的成员变量数组

 @return 成员变量数组
 */
+ (NSArray *)sr_ivarsList;

@end
