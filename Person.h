//
//  Person.h
//  TestView
//
//  Created by leotao on 16/3/16.
//  Copyright © 2016年 ZS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject{
    NSString *_variableString;
}

// 默认会是什么呢？
@property (nonatomic, copy) NSString *name;

// 默认是strong类型
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *ce;

// 获取所有的属性名
- (NSArray *)allProperties;
//获取对象的成员变量名称
- (NSArray *)allMemberVariables;
//获取对象的所有方法名
- (void)allMethods;
//获取对象的所有属性名和属性值
- (NSDictionary *)allPropertyNamesAndValues;

@end

