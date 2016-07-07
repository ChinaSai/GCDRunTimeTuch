//
//  Person.m
//  TestView
//
//  Created by leotao on 16/3/16.
//  Copyright © 2016年 ZS. All rights reserved.
//

#import "Person.h"

//#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@implementation Person
typedef struct objc_property *objc_property_t;

- (NSArray *)allProperties {
    unsigned int count;
    
    
    // 获取类的所有属性
    // 如果没有属性，则count为0，properties为nil
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (NSUInteger i = 0; i < count; i++) {
        // 获取属性名称
        const char *propertyName = property_getName(properties[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        
        [propertiesArray addObject:name];
    }
    
    // 注意，这里properties是一个数组指针，是C的语法，
    // 我们需要使用free函数来释放内存，否则会造成内存泄露
    free(properties);
    


    
    
    return propertiesArray;
}

- (NSArray *)allMemberVariables {
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < count; ++i) {
        Ivar variable = ivars[i];
        
        const char *name = ivar_getName(variable);
        NSString *varName = [NSString stringWithUTF8String:name];
        
        [results addObject:varName];
    }
    
    free(ivars);
    
    return results;
}

- (void)allMethods {
    unsigned int outCount = 0;
    Method *methods = class_copyMethodList([self class], &outCount);
    
    for (int i = 0; i < outCount; ++i) {
        Method method = methods[i];
        
        // 获取方法名称，但是类型是一个SEL选择器类型
        SEL methodSEL = method_getName(method);
        // 需要获取C字符串
        const char *name = sel_getName(methodSEL);
        // 将方法名转换成OC字符串
        NSString *methodName = [NSString stringWithUTF8String:name];
        
        // 获取方法的参数列表
        int arguments = method_getNumberOfArguments(method);
        NSLog(@"方法名：%@, 参数个数：%d", methodName, arguments);
    }
    
    // 记得释放
    free(methods);
}


- (NSDictionary *)allPropertyNamesAndValues {
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        
        // 得到属性名
        NSString *propertyName = [NSString stringWithUTF8String:name];
        
        // 获取属性值
        id propertyValue = [self valueForKey:propertyName];
        
        if (propertyValue && propertyValue != nil) {
            [resultDict setObject:propertyValue forKey:propertyName];
        }
    }
    
    // 记得释放
    free(properties);
    
    return resultDict;
}

@end
