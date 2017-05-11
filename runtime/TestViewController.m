//
//  TestViewController.m
//  runtime
//
//  Created by 一天 on 2017/5/11.
//  Copyright © 2017年 肖振阳. All rights reserved.
//

#import "TestViewController.h"
#import <objc/runtime.h>
#import "RuntimeCategoryClass.h"
#import "Person.h"


@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    test29();
}

-(void)testRuntimeCategoryClass{

#pragma mark -
    
    NSLog(@"测试objc_class中的方法列表是否包含分类中的方法");
    unsigned int outCount = 0;
    Method *methodList = class_copyMethodList(RuntimeCategoryClass.class, &outCount);
    
    for (int i = 0; i < outCount; i++) {
        Method method = methodList[i];
        
        const char *name = sel_getName(method_getName(method));
        
        NSLog(@"RuntimeCategoryClass's method: %s", name);
        
        if (strcmp(name, sel_getName(@selector(method2)))) {
            NSLog(@"分类方法method2在objc_class的方法列表中");
        }
    }
}
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(xxx_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling

- (void)xxx_viewWillAppear:(BOOL)animated {
    [self xxx_viewWillAppear:animated];
    NSLog(@"viewWillAppear: %@", self);
}


@end
