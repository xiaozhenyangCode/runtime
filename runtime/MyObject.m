//
//  MyObject.m
//  runtime
//
//  Created by 一天 on 2017/5/10.
//  Copyright © 2017年 肖振阳. All rights reserved.
//
#import <objc/runtime.h>
#import "MyObject.h"
static NSMutableDictionary *map = nil;
@implementation MyObject
+ (void)load{
    
    
    map = [NSMutableDictionary dictionary];
    
    map[@"name1"]                = @"name";
    map[@"status1"]              = @"status";
    map[@"name2"]                = @"name";
    map[@"status2"]              = @"status";
}
- (void)setDataWithDic:(NSDictionary *)dic{
    
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        
        NSString *propertyKey = [self propertyForKey:key];
        
        if (propertyKey){
            
            objc_property_t property = class_getProperty([self class], [propertyKey UTF8String]);
            
            // TODO: 针对特殊数据类型做处理
            NSString *attributeString = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            
            //...
            
            [self setValue:obj forKey:propertyKey];
        }
    }];
    //当然，一个属性能否通过上面这种方式来处理的前提是其支持KVC。
}
-(NSString *)propertyForKey:(NSString *)key{

    return @"";
}
@end
