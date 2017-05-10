//
//  ViewController.m
//  runtime
//
//  Created by 一天 on 2017/5/10.
//  Copyright © 2017年 肖振阳. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "MyClass.h"
#import "Person.h"
static char myKey;
static char kDTActionHandlerTapGestureKey;
static char kDTActionHandlerTapBlockKey;
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
  
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    
    [self test6];
    
//    
//    TestClass *class = [[TestClass alloc]init];
//    
//    [class ex_registerClassPair];
    
    //NSArray *array = [[NSArray array]init];
    /**
     [NSArray alloc]先被执行。因为NSArray没有+alloc方法，于是去父类NSObject去查找。
     
     检测NSObject是否响应+alloc方法，发现响应，于是检测NSArray类，并根据其所需的内存空间大小开始分配内存空间，然后把isa指针指向NSArray类。同时，+alloc也被加进cache列表里面。
     
     接着，执行-init方法，如果NSArray响应该方法，则直接将其加入cache；如果不响应，则去父类查找。
     
     在后期的操作中，如果再以[[NSArray alloc] init]这种方式来创建数组，则会直接从cache中取出相应的方法，直接调用
     */
}

//成员变量、属性的操作方法 实例
-(void)test7{

    //假定这样一个场景，我们从服务端两个不同的接口获取相同的字典数据，但这两个接口是由两个人写的，相同的信息使用了不同的字段表示。我们在接收到数据时，可将这些数据保存在相同的对象中。对象类如下定义：

}

//实例演示一下关联对象的使用方法
-(void)test6{

    //假定我们想要动态地将一个Tap手势操作连接到任何UIView中，并且根据需要指定点击后的实际操作。这时候我们就可以将一个手势对象及操作的block对象关联到我们的UIView对象中。这项任务分两部分。首先，如果需要，我们要创建一个手势识别对象并将它及block做为关联对象。如下代码所示：
    
    
    [self setTapActionWithBlock:^{
        
        NSLog(@"setTapActionWithBlock");
    }];
    
    //我们需要检测手势识别对象的状态，因为我们只需要在点击手势被识别出来时才执行操作。
    
    //从上面的例子我们可以看到，关联对象使用起来并不复杂。它让我们可以动态地增强类现有的功能。我们可以在实际编码中灵活地运用这一特性。
}
- (void)setTapActionWithBlock:(void (^)(void))block{
    
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerTapGestureKey);
    
    if (!gesture){
        
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        [self.view addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kDTActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    
    objc_setAssociatedObject(self, &kDTActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForTapGesture:(UITapGestureRecognizer *)gesture{
    
    if (gesture.state == UIGestureRecognizerStateRecognized){
        
        void(^action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerTapBlockKey);
        
        if (action){
            
            action();
        }
    }
}
//关联对象(Associated Object)
-(void)test5{
    
    id anObject = objc_getAssociatedObject(self, &myKey);
    NSLog(@"%@",anObject);
    //我们可以使用objc_removeAssociatedObjects函数来移除一个关联对象，或者使用objc_setAssociatedObject函数将key指定的关联对象设置为nil。
    
}
//关联对象(Associated Object)
-(void)test4{

    //我们将一个对象连接到其它对象所需要做的就是下面两行代码：
    
    id anObject = [[NSObject alloc]init];
    
    objc_setAssociatedObject(self, &myKey, anObject, OBJC_ASSOCIATION_RETAIN);
    
    //在这种情况下，self对象将获取一个新的关联的对象anObject，且内存管理策略是自动retain关联对象，当self对象释放时，会自动release关联对象。另外，如果我们使用同一个key来关联另外一个对象时，也会自动释放之前关联的对象，这种情况下，先前的关联对象会被妥善地处理掉，并且新的对象会使用它的内存。
}

//实例操作函数
-(void)test3{

//    //有这样一种场景，假设我们有类A和类B，且类B是类A的子类。类B通过添加一些额外的属性来扩展类A。现在我们创建了一个A类的实例对象，并希望在运行时将这个对象转换为B类的实例对象，这样可以添加数据到B类的属性中。这种情况下，我们没有办法直接转换，因为B类的实例会比A类的实例更大，没有足够的空间来放置对象。此时，我们就要以使用以上几个函数来处理这种情况，如下代码所示：
//    
//    NSObject *a = [[NSObject alloc] init];
//    id newB = object_copy(a, class_getInstanceSize(MyClass.class));
//    object_setClass(newB, MyClass.class);
//    object_dispose(a);

}

//动态创建对象
-(void)test2{

//    //调用class_createInstance的效果与+alloc方法类似。不过在使用class_createInstance时，我们需要确切的知道我们要用它来做什么。在下面的例子中，我们用NSString来测试一下该函数的实际效果：
//    id theObject = class_createInstance(NSString.class, sizeof(unsigned));
//    id str1 = [theObject init];
//    
//    NSLog(@"%@", [str1 class]);
//    
//    id str2 = [[NSString alloc] initWithString:@"test"];
//    NSLog(@"%@", [str2 class]);
//    
    /**
     2017-05-10 14:54:20.019 runtime[1852:1108001] NSString
     2017-05-10 14:54:20.019 runtime[1852:1108001] __NSCFConstantString
     
     可以看到，使用class_createInstance函数获取的是NSString实例，而不是类簇中的默认占位符类__NSCFConstantString。
     
     */
}

//动态创建类
-(void) test1{
    
    
    Class cls = objc_allocateClassPair(MyClass.class, "MySubClass", 0);
    class_addMethod(cls, @selector(submethod1), (IMP)imp_submethod1, "v@:");
    class_replaceMethod(cls, @selector(method1), (IMP)imp_submethod1, "v@:");
    class_addIvar(cls, "_ivar1", sizeof(NSString *), log(sizeof(NSString *)), "i");
    
    objc_property_attribute_t type = {"T", "@\"NSString\""};
    objc_property_attribute_t ownership = { "C", "" };
    objc_property_attribute_t backingivar = { "V", "_ivar1"};
    objc_property_attribute_t attrs[] = {type, ownership, backingivar};
    
    class_addProperty(cls, "property2", attrs, 3);
    objc_registerClassPair(cls);
    
    id instance = [[cls alloc] init];
    [instance performSelector:@selector(submethod1)];
    [instance performSelector:@selector(method1)];

}
-(void) submethod1{


}
//实例(Example)
-(void) test0{

    MyClass *myClass = [[MyClass alloc] init];
    unsigned int outCount = 0;
    
    Class cls = myClass.class;
    
    // 类名
    NSLog(@"class name: %s", class_getName(cls));
    
    NSLog(@"==========================================================");
    
    // 父类
    NSLog(@"super class name: %s", class_getName(class_getSuperclass(cls)));
    NSLog(@"==========================================================");
    
    // 是否是元类
    NSLog(@"MyClass is %@ a meta-class", (class_isMetaClass(cls) ? @"" : @"not"));
    NSLog(@"==========================================================");
    
    Class meta_class = objc_getMetaClass(class_getName(cls));
    NSLog(@"%s's meta-class is %s", class_getName(cls), class_getName(meta_class));
    NSLog(@"==========================================================");
    
    // 变量实例大小
    NSLog(@"instance size: %zu", class_getInstanceSize(cls));
    NSLog(@"==========================================================");
    
    // 成员变量
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"instance variable's name: %s at index: %d", ivar_getName(ivar), i);
    }
    
    free(ivars);
    
    Ivar string = class_getInstanceVariable(cls, "_string");
    if (string != NULL) {
        NSLog(@"instace variable %s", ivar_getName(string));
    }
    
    NSLog(@"==========================================================");
    
    // 属性操作
    objc_property_t * properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"property's name: %s", property_getName(property));
    }
    
    free(properties);
    
    objc_property_t array = class_getProperty(cls, "array");
    if (array != NULL) {
        NSLog(@"property %s", property_getName(array));
    }
    
    NSLog(@"==========================================================");
    
    // 方法操作
    Method *methods = class_copyMethodList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Method method = methods[i];
        NSLog(@"method's signature: %s", method_getName(method));
    }
    
    free(methods);
    
    Method method1 = class_getInstanceMethod(cls, @selector(method1));
    if (method1 != NULL) {
        NSLog(@"method %s", method_getName(method1));
    }
    
    Method classMethod = class_getClassMethod(cls, @selector(classMethod1));
    if (classMethod != NULL) {
        NSLog(@"class method : %s", method_getName(classMethod));
    }
    
    NSLog(@"MyClass is%@ responsd to selector: method3WithArg1:arg2:", class_respondsToSelector(cls, @selector(method3WithArg1:arg2:)) ? @"" : @" not");
    
    IMP imp = class_getMethodImplementation(cls, @selector(method1));
    imp();
    
    NSLog(@"==========================================================");
    
    // 协议
    Protocol * __unsafe_unretained * protocols = class_copyProtocolList(cls, &outCount);
    Protocol * protocol;
    for (int i = 0; i < outCount; i++) {
        protocol = protocols[i];
        NSLog(@"protocol name: %s", protocol_getName(protocol));
    }
    
    NSLog(@"MyClass is%@ responsed to protocol %s", class_conformsToProtocol(cls, protocol) ? @"" : @" not", protocol_getName(protocol));
    
    NSLog(@"==========================================================");

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
