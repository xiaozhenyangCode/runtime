//
//  SUTRuntimeMethodHelper.m
//  runtime
//
//  Created by 一天 on 2017/5/11.
//  Copyright © 2017年 肖振阳. All rights reserved.
//

#import "SUTRuntimeMethodHelper.h"
@interface SUTRuntimeMethodHelper : NSObject
- (void)method2;
@end


@implementation SUTRuntimeMethodHelper

- (void)method2 {
    NSLog(@"%@, %p", self, _cmd);
}
@end

@interface SUTRuntimeMethod () {
    SUTRuntimeMethodHelper *_helper;
}
@end


@implementation SUTRuntimeMethod
+ (instancetype)object {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _helper = [[SUTRuntimeMethodHelper alloc] init];
    }
    
    return self;
}

- (void)test {
    [self performSelector:@selector(method2)];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    
    NSLog(@"forwardingTargetForSelector");
    
    NSString *selectorString = NSStringFromSelector(aSelector);
    
    // 将消息转发给_helper来处理
    if ([selectorString isEqualToString:@"method2"]) {
        return _helper;
    }
    
    return [super forwardingTargetForSelector:aSelector];
    
    //这一步合适于我们只想将消息转发到另一个能处理该消息的对象上。但这一步无法对消息进行处理，如操作消息的参数和返回值。
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    
    if (!signature) {
        if ([SUTRuntimeMethodHelper instancesRespondToSelector:aSelector]) {
            signature = [SUTRuntimeMethodHelper instanceMethodSignatureForSelector:aSelector];
        }
    }
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([SUTRuntimeMethodHelper instancesRespondToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_helper];
    }
}
//NSObject的forwardInvocation:方法实现只是简单调用了doesNotRecognizeSelector:方法，它不会转发任何消息。这样，如果不在以上所述的三个步骤中处理未知消息，则会引发一个异常。
//从某种意义上来讲，forwardInvocation:就像一个未知消息的分发中心，将这些未知的消息转发给其它对象。或者也可以像一个运输站一样将所有未知消息都发送给同一个接收对象。这取决于具体的实现。


@end

