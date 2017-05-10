//
//  MyClass.h
//  runtime
//
//  Created by 一天 on 2017/5/10.
//  Copyright © 2017年 肖振阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyClass : NSObject <NSCopying, NSCoding>

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, copy) NSString *string;

- (void)method1;

- (void)method2;

+ (void)classMethod1;
void imp_submethod1(id self, SEL _cmd);
- (void)test4;
@end
