//
//  TestClass.m
//  runtime
//
//  Created by 一天 on 2017/5/10.
//  Copyright © 2017年 肖振阳. All rights reserved.
//

#import "TestClass.h"
#import <objc/runtime.h>

void TestMetaClass(id self, SEL _cmd) {
    
    NSLog(@"This objcet is %p", self);
    NSLog(@"Class is %@, super class is %@", [self class], [self superclass]);
    
    Class currentClass = [self class];
    for (int i = 0; i < 4; i++) {
        NSLog(@"Following the isa pointer %d times gives %p", i, currentClass);
        currentClass = objc_getClass((__bridge void *)currentClass);
    }
    
    NSLog(@"NSObject's class is %p", [NSObject class]);
    NSLog(@"NSObject's meta class is %p", objc_getClass((__bridge void *)[NSObject class]));
    
    
    /**
     2017-05-10 10:18:40.370 runtime[1039:297112] This objcet is 0x61000004d260
     2017-05-10 10:18:40.371 runtime[1039:297112] Class is TestMetaClass, super class is NSError
     2017-05-10 10:18:40.371 runtime[1039:297112] Following the isa pointer 0 times gives 0x61000004cf90
     2017-05-10 10:18:40.371 runtime[1039:297112] Following the isa pointer 1 times gives 0x0
     2017-05-10 10:18:40.371 runtime[1039:297112] Following the isa pointer 2 times gives 0x0
     2017-05-10 10:18:40.371 runtime[1039:297112] Following the isa pointer 3 times gives 0x0
     2017-05-10 10:18:40.371 runtime[1039:297112] NSObject's class is 0x104514e88
     2017-05-10 10:18:40.372 runtime[1039:297112] NSObject's meta class is 0x0
     
     我们在for循环中，我们通过objc_getClass来获取对象的isa，并将其打印出来，依此一直回溯到NSObject的meta-class。分析打印结果，可以看到最后指针指向的地址是0x0，即NSObject的meta-class的类地址。
     
     这里需要注意的是：我们在一个类对象调用class方法是无法获取meta-class，它只是返回类而已。
     */
}


@implementation TestClass




- (void)ex_registerClassPair {
    
    Class newClass = objc_allocateClassPair([NSError class], "TestMetaClass", 0);
    class_addMethod(newClass, @selector(testMetaClass), (IMP)TestMetaClass, "v@:");
    objc_registerClassPair(newClass);
    
    id instance = [[newClass alloc] initWithDomain:@"some domain" code:0 userInfo:nil];
    [instance performSelector:@selector(testMetaClass)];
}





@end
