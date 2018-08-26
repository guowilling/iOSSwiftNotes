
#import "NSObject+SRRuntime.h"
#import <objc/runtime.h>

@implementation NSObject (SRRuntime)

+ (NSArray *)sr_objectsWithArray:(NSArray *)dictArray {
    if (!dictArray || dictArray.count == 0) {
        return nil;
    }
    NSArray *propertiesList = [self sr_propertiesList];
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in dictArray) {
        id obj = [self new];
        for (NSString *key in dict) {
            if (![propertiesList containsObject:key]) {
                continue;
            }
            [obj setValue:dict[key] forKey:key];
        }
        [arrayM addObject:obj];
    }
    return arrayM.copy;
}

void *propertiesKey = "com.willing.propertiesList";
+ (NSArray *)sr_propertiesList {
    NSArray *result = objc_getAssociatedObject(self, propertiesKey);
    if (result != nil) {
        return result;
    }
    unsigned int count = 0;
    objc_property_t *list = class_copyPropertyList([self class], &count);
    NSMutableArray *arrayM = [NSMutableArray array];
    for (unsigned int i = 0; i < count; i++) {
        objc_property_t pty = list[i];
        const char *cName = property_getName(pty);
        NSString *name = [NSString stringWithUTF8String:cName];
        [arrayM addObject:name];
    }
    free(list);
    objc_setAssociatedObject(self, propertiesKey, arrayM, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return objc_getAssociatedObject(self, propertiesKey);
}

void *ivarsKey = "com.willing.ivarsList";
+ (NSArray *)sr_ivarsList {
    NSArray *result = objc_getAssociatedObject(self, ivarsKey);
    if (result != nil) {
        return result;
    }
    unsigned int count = 0;
    Ivar *list = class_copyIvarList([self class], &count);
    NSMutableArray *arrayM = [NSMutableArray array];
    for (unsigned int i = 0; i < count; i++) {
        Ivar ivar = list[i];
        const char *cName = ivar_getName(ivar);
        NSString *name = [NSString stringWithUTF8String:cName];
        [arrayM addObject:name];
    }
    free(list);
    objc_setAssociatedObject(self, ivarsKey, arrayM, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return objc_getAssociatedObject(self, ivarsKey);
}

@end
