//
//  Person.m
//  runtime
//
//  Created by 一天 on 2017/5/10.
//  Copyright © 2017年 肖振阳. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>


@implementation Person
 // 获取类的类名
void test0(){
    
   
    //对于class_getName函数，如果传入的cls为Nil，则返回一个字字符串。
    //1.
    const char * class_getName ( Class cls );

    
    //父类(super_class)和元类(meta-class)
    
    //父类和元类操作的函数主要有：
    // 获取类的父类
    //class_getSuperclass函数，当cls为Nil或者cls为根类时，返回Nil。不过通常我们可以使用NSObject类的superclass方法来达到同样的目的。
    //1.
    Class class_getSuperclass ( Class cls );
    
    // 判断给定的Class是否是一个元类
    //class_isMetaClass函数，如果是cls是元类，则返回YES；如果否或者传入的cls为Nil，则返回NO。
    //2.
    BOOL class_isMetaClass ( Class cls );
    
    //实例变量大小操作的函数有：
    // 获取实例大小
    //实例变量大小(instance_size)
    //1.
    size_t class_getInstanceSize ( Class cls );
    
    
    //1.成员变量操作函数，主要包含以下函数：
    // 获取类中指定名称实例成员变量的信息
    //class_getInstanceVariable函数，它返回一个指向包含name指定的成员变量信息的objc_ivar结构体的指针(Ivar)。
    //a.
    Ivar class_getInstanceVariable ( Class cls, const char *name );
    
    
    
    // 获取类成员变量的信息
    //class_getClassVariable函数，目前没有找到关于Objective-C中类变量的信息，一般认为Objective-C不支持类变量。注意，返回的列表不包含父类的成员变量和属性。
    //b.
    Ivar class_getClassVariable ( Class cls, const char *name );
    
    
    // 添加成员变量
    //Objective-C不支持往已存在的类中添加实例变量，因此不管是系统库提供的提供的类，还是我们自定义的类，都无法动态添加成员变量。但如果我们通过运行时来创建一个类的话，又应该如何给它添加成员变量呢？这时我们就可以使用class_addIvar函数了。不过需要注意的是，这个方法只能在objc_allocateClassPair函数与objc_registerClassPair之间调用。另外，这个类也不能是元类。成员变量的按字节最小对齐量是1<<alignment。这取决于ivar的类型和机器的架构。如果变量的类型是指针类型，则传递log2(sizeof(pointer_type))。
    //c.
    BOOL class_addIvar ( Class cls, const char *name, size_t size, uint8_t alignment, const char *types );
    
    
    // 获取整个成员变量列表
    //class_copyIvarList函数，它返回一个指向成员变量信息的数组，数组中每个元素是指向该成员变量信息的objc_ivar结构体的指针。这个数组不包含在父类中声明的变量。outCount指针返回数组的大小。需要注意的是，我们必须使用free()来释放这个数组。
    //d.
    Ivar * class_copyIvarList ( Class cls, unsigned int *outCount );
    
    
    
    //2.属性操作函数，主要包含以下函数：
    //这一种方法也是针对ivars来操作，不过只操作那些是属性的值。我们在后面介绍属性时会再遇到这些函数。
    // 获取指定的属性
    //a.
    objc_property_t class_getProperty ( Class cls, const char *name );
    
    // 获取属性列表
    //b.
    objc_property_t * class_copyPropertyList ( Class cls, unsigned int *outCount );
    
    // 为类添加属性
    //c.
    BOOL class_addProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );
    
    // 替换类的属性
    //d.
    void class_replaceProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );
    
    
    //3.在MAC OS X系统中，我们可以使用垃圾回收器。runtime提供了几个函数来确定一个对象的内存区域是否可以被垃圾回收器扫描，以处理strong/weak引用。这几个函数定义如下：
    //但通常情况下，我们不需要去主动调用这些方法；在调用objc_registerClassPair时，会生成合理的布局。在此不详细介绍这些函数。
    const uint8_t * class_getIvarLayout ( Class cls );
    void class_setIvarLayout ( Class cls, const uint8_t *layout );
    const uint8_t * class_getWeakIvarLayout ( Class cls );
    void class_setWeakIvarLayout ( Class cls, const uint8_t *layout );
    
}
 //方法(methodLists)
void test1(){

   
    //方法操作主要有以下函数：

    
    
    //class_getInstanceMethod、class_getClassMethod函数，与class_copyMethodList不同的是，这两个函数都会去搜索父类的实现。
    // 获取实例方法
    Method class_getInstanceMethod ( Class cls, SEL name );
    // 获取类方法
    Method class_getClassMethod ( Class cls, SEL name );
    // 获取所有方法的数组
    //class_copyMethodList函数，返回包含所有实例方法的数组，如果需要获取类方法，则可以使用class_copyMethodList(object_getClass(cls), &count)(一个类的实例方法是定义在元类里面)。该列表不包含父类实现的方法。outCount参数返回方法的个数。在获取到列表后，我们需要使用free()方法来释放它。
    Method * class_copyMethodList ( Class cls, unsigned int *outCount );

    
    // 替代方法的实现
    //class_replaceMethod函数，该函数的行为可以分为两种：如果类中不存在name指定的方法，则类似于class_addMethod函数一样会添加方法；如果类中已存在name指定的方法，则类似于method_setImplementation一样替代原方法的实现。
    IMP class_replaceMethod ( Class cls, SEL name, IMP imp, const char *types );
    
    // 返回方法的具体实现
    //class_getMethodImplementation函数，该函数在向类实例发送消息时会被调用，并返回一个指向方法实现函数的指针。这个函数会比method_getImplementation(class_getInstanceMethod(cls, name))更快。返回的函数指针可能是一个指向runtime内部的函数，而不一定是方法的实际实现。例如，如果类实例无法响应selector，则返回的函数指针将是运行时消息转发机制的一部分。
    IMP class_getMethodImplementation ( Class cls, SEL name );
    IMP class_getMethodImplementation_stret ( Class cls, SEL name );
    
    
    // 类实例是否响应指定的selector
    //class_respondsToSelector函数，我们通常使用NSObject类的respondsToSelector:或instancesRespondToSelector:方法来达到相同目的。
    BOOL class_respondsToSelector ( Class cls, SEL sel );
    
    
    // 添加方法
    //class_addMethod的实现会覆盖父类的方法实现，但不会取代本类中已存在的实现，如果本类中包含一个同名的实现，则函数会返回NO。如果要修改已存在实现，可以使用method_setImplementation。一个Objective-C方法是一个简单的C函数，它至少包含两个参数—self和_cmd。所以，我们的实现函数(IMP参数指向的函数)至少需要两个参数，如下所示：
    BOOL class_addMethod ( Class cls, SEL name, IMP imp, const char *types );
    
    
}

void myMethodIMP(id self, SEL _cmd){
    
    
    // implementation ....
    //与成员变量不同的是，我们可以为类动态添加方法，不管这个类是否已存在。
    //另外，参数types是一个描述传递给方法的参数类型的字符数组，这就涉及到类型编码，我们将在后面介绍。
    
}
//协议(objc_protocol_list)
void test2(){
    
    //协议相关的操作包含以下函数：
    
    // 添加协议
    //class_conformsToProtocol函数可以使用NSObject类的conformsToProtocol:方法来替代。
    BOOL class_addProtocol ( Class cls, Protocol *protocol );
    
    // 回类是否实现指定的协议
    //class_copyProtocolList函数返回的是一个数组，在使用后我们需要使用free()手动释放。
    BOOL class_conformsToProtocol ( Class cls, Protocol *protocol );
    
    //返回类实现的协议列表
    Protocol * __unsafe_unretained *class_copyProtocolList(Class cls, unsigned int *outCount);
    
    
}
//版本(version)
void test3(){

    
    //版本相关的操作包含以下函数：
    // 获取版本号
    int class_getVersion ( Class cls );
    
    // 设置版本号
    void class_setVersion ( Class cls, int version );

    
    
    //其它
    //通常我们不直接使用这两个函数
    //runtime还提供了两个函数来供CoreFoundation的tool-free bridging使用，即：
    Class objc_getFutureClass ( const char *name );
    void objc_setFutureClass ( Class cls, const char *name );

}
//动态创建类和对象
void test4(){

    
   //runtime的强大之处在于它能在运行时创建类和对象。
   //动态创建类
   //动态创建类涉及到以下几个函数：
    
    // 创建一个新类和元类
    //objc_allocateClassPair函数：如果我们要创建一个根类，则superclass指定为Nil。extraBytes通常指定为0，该参数是分配给类和元类对象尾部的索引ivars的字节数。
    Class objc_allocateClassPair ( Class superclass, const char *name, size_t extraBytes );
    
    // 销毁一个类及其相关联的类
    //objc_disposeClassPair函数用于销毁一个类，不过需要注意的是，如果程序运行中还存在类或其子类的实例，则不能调用针对类调用该方法。
    void objc_disposeClassPair ( Class cls );
    
    
    // 在应用中注册由objc_allocateClassPair创建的类
    //为了创建一个新类，我们需要调用objc_allocateClassPair。然后使用诸如class_addMethod，class_addIvar等函数来为新创建的类添加方法、实例变量和属性等。完成这些后，我们需要调用objc_registerClassPair函数来注册类，之后这个新类就可以在程序中使用了。实例方法和实例变量应该添加到类自身上，而类方法应该添加到类的元类上。
    void objc_registerClassPair ( Class cls );


    //动态创建对象
    // 创建类实例
    //class_createInstance函数：创建实例时，会在默认的内存区域为类分配内存。extraBytes参数表示分配的额外字节数。这些额外的字节可用于存储在类定义中所定义的实例变量之外的实例变量。该函数在ARC环境下无法使用。
    id class_createInstance ( Class cls, size_t extraBytes );
    
    // 在指定位置创建类实例
    //objc_constructInstance函数：在指定的位置(bytes)创建类实例。
    id objc_constructInstance ( Class cls, void *bytes );
    
    
    // 销毁类实例
    //objc_destructInstance函数：销毁一个类的实例，但不会释放并移除任何与其相关的引用。
    void * objc_destructInstance ( id obj );
    
}
//实例操作函数
void test5(){
    
    
    //实例操作函数主要是针对我们创建的实例对象的一系列操作函数，我们可以使用这组函数来从实例对象中获取我们想要的一些信息，如实例对象中变量的值。这组函数可以分为三小类：
    // 1.针对整个对象进行操作的函数，这类函数包含
    
    // 返回指定对象的一份拷贝
    id object_copy ( id obj, size_t size );
    
    // 释放指定对象占用的内存
    id object_dispose ( id obj );
    
    
    
    //2.针对对象实例变量进行操作的函数，这类函数包含：
    //如果实例变量的Ivar已经知道，那么调用object_getIvar会比object_getInstanceVariable函数快，相同情况下，object_setIvar也比object_setInstanceVariable快。
    // 修改类实例的实例变量的值
    Ivar object_setInstanceVariable ( id obj, const char *name, void *value );
    
    // 获取对象实例变量的值
    Ivar object_getInstanceVariable ( id obj, const char *name, void **outValue );
    
    // 返回指向给定对象分配的任何额外字节的指针
    void * object_getIndexedIvars ( id obj );
    
    // 返回对象中实例变量的值
    id object_getIvar ( id obj, Ivar ivar );
    
    // 设置对象中实例变量的值
    void object_setIvar ( id obj, Ivar ivar, id value );

    
    //3.针对对象的类进行操作的函数，这类函数包含：
    // 返回给定对象的类名
    const char * object_getClassName ( id obj );
    
    // 返回对象的类
    Class object_getClass ( id obj );
    
    // 设置对象的类
    Class object_setClass ( id obj, Class cls );
    
    
}
//获取类定义
void test6(){

    //Objective-C动态运行库会自动注册我们代码中定义的所有的类。
    //我们也可以在运行时创建类定义并使用objc_addClass函数来注册它们。
    //runtime提供了一系列函数来获取类定义相关的信息，这些函数主要包括：
    
    // 获取已注册的类定义的列表
    int objc_getClassList ( Class *buffer, int bufferCount );
    
    // 创建并返回一个指向所有已注册类的指针列表
    Class * objc_copyClassList ( unsigned int *outCount );
    
    // 返回指定类的类定义
    //获取类定义的方法有三个：objc_lookUpClass, objc_getClass和objc_getRequiredClass。如果类在运行时未注册，则objc_lookUpClass会返回nil，而objc_getClass会调用类处理回调，并再次确认类是否注册，如果确认未注册，再返回nil。而objc_getRequiredClass函数的操作与objc_getClass相同，只不过如果没有找到类，则会杀死进程。
    Class objc_lookUpClass ( const char *name );
    Class objc_getClass ( const char *name );
    Class objc_getRequiredClass ( const char *name );
    
    // 返回指定类的元类
    //objc_getMetaClass函数：如果指定的类没有注册，则该函数会调用类处理回调，并再次确认类是否注册，如果确认未注册，再返回nil。不过，每个类定义都必须有一个有效的元类定义，所以这个函数总是会返回一个元类定义，不管它是否有效。
    Class objc_getMetaClass ( const char *name );
    
    //objc_getClassList函数：获取已注册的类定义的列表。我们不能假设从该函数中获取的类对象是继承自NSObject体系的，所以在这些类上调用方法是，都应该先检测一下这个方法是否在这个类中实现。
    
    
    //小结 介绍了Runtime运行时中与类和对象相关的数据结构，通过这些数据函数，我们可以管窥Objective-C底层面向对象实现的一些信息。另外，通过丰富的操作函数，可以灵活地对这些数据进行操作。
}
//成员和成员属性
void test7(){
    
    //类型编码(Type Encoding)
    //作为对Runtime的补充，编译器将每个方法的返回值和参数类型编码为一个字符串，并将其与方法的selector关联在一起。这种编码方案在其它情况下也是非常有用的，因此我们可以使用@encode编译器指令来获取它。当给定一个类型时，@encode返回这个类型的字符串编码。这些类型可以是诸如int、指针这样的基本类型，也可以是结构体、类等类型。事实上，任何可以作为sizeof()操作参数的类型都可以用于@encode()。
    
    //在Objective-C Runtime Programming Guide中的Type Encoding (https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1)一节中，列出了Objective-C中所有的类型编码。需要注意的是这些类型很多是与我们用于存档和分发的编码类型是相同的。但有一些不能在存档时使用。
    
    //注：Objective-C不支持long double类型。@encode(long double)返回d，与double是一样的。
    
    //一个数组的类型编码位于方括号中；其中包含数组元素的个数及元素类型。如以下示例：
    float a[] = {1.0, 2.0, 3.0,4.0};
    NSLog(@"array encoding type: %s", @encode(typeof(a)));
    /**
        2017-05-10 16:30:41.855 runtime[7256:1632996] array encoding type: [4f] 4条为 A float 类型的 编码
     */
    
}
//关联对象(Associated Object)
void test8(){

    
    //关联对象是Runtime中一个非常实用的特性，不过可能很容易被忽视。
    
    //关联对象类似于成员变量，不过是在运行时添加的。通常会把成员变量(Ivar)放在类声明的头文件中，或者放在类实现的@implementation后面。但这有一个缺点，不能在分类中添加成员变量。如果尝试在分类中添加新的成员变量，编译器会报错。
    
    //可能希望通过使用(甚至是滥用)全局变量来解决这个问题。但这些都不是Ivar，因为他们不会连接到一个单独的实例。因此，这种方法很少使用。
    
    //Objective-C针对这一问题，提供了一个解决方案：即关联对象(Associated Object)。
    
    //可以把关联对象想象成一个Objective-C对象(如字典)，这个对象通过给定的key连接到类的一个实例上。不过由于使用的是C接口，所以key是一个void指针(const void *)。还需要指定一个内存管理策略，以告诉Runtime如何管理这个对象的内存。这个内存管理的策略可以由以下值指定：
    /**
    OBJC_ASSOCIATION_ASSIGN
    OBJC_ASSOCIATION_RETAIN_NONATOMIC
    OBJC_ASSOCIATION_COPY_NONATOMIC
    OBJC_ASSOCIATION_RETAIN
    OBJC_ASSOCIATION_COPY
     */
    
    //当宿主对象被释放时，会根据指定的内存管理策略来处理关联对象。如果指定的策略是assign，则宿主释放时，关联对象不会被释放；而如果指定的是retain或者是copy，则宿主释放时，关联对象会被释放。我们甚至可以选择是否是自动retain/copy。当我们需要在多个线程中处理访问关联对象的多线程代码时，这就非常有用了。
    
    
    //关联对象
    //关联对象操作函数包括以下：
    // 设置关联对象
    void objc_setAssociatedObject ( id object, const void *key, id value, objc_AssociationPolicy policy );
    
    // 获取关联对象
    id objc_getAssociatedObject ( id object, const void *key );
    
    // 移除关联对象
    void objc_removeAssociatedObjects ( id object );


}
//成员变量、属性的操作方法
void test9(){

    //成员变量
    
    //成员变量操作包含以下函数：
    
    // 获取成员变量名
    const char * ivar_getName ( Ivar v );
    
    // 获取成员变量类型编码
    const char * ivar_getTypeEncoding ( Ivar v );
    
    // 获取成员变量的偏移量
    ptrdiff_t ivar_getOffset ( Ivar v );
    
    //ivar_getOffset函数，对于类型id或其它对象类型的实例变量，可以调用object_getIvar和object_setIvar来直接访问成员变量，而不使用偏移量。
    
    //属性
    //属性操作相关函数包括以下
    // 获取属性名
    const char * property_getName ( objc_property_t property );
    
    // 获取属性特性描述字符串
    const char * property_getAttributes ( objc_property_t property );
    
    // 获取属性中指定的特性
    // property_copyAttributeValue函数，返回的char *在使用完后需要调用free()释放。

    char * property_copyAttributeValue ( objc_property_t property, const char *attributeName );
    
    // 获取属性的特性列表
    // property_copyAttributeList函数，返回值在使用完后需要调用free()释放。

    objc_property_attribute_t * property_copyAttributeList ( objc_property_t property, unsigned int *outCount );
    
    //小结  讨论了Runtime中与成员变量和属性相关的内容。成员变量与属性是类的数据基础，合理地使用Runtime中的相关操作能让我们更加灵活地来处理与类数据相关的工作。
}
//方法和消息
void test10(){

    //SEL又叫选择器，是表示一个方法的selector的指针，其定义如下：
    typedef struct objc_selector *SEL;
    //objc_selector结构体的详细定义没有在头文件中找到。方法的selector用于表示运行时方 法的名字。Objective-C在编译时，会依据每一个方法的名字、参数序列，生成一个唯一的整型标识(Int类型的地址)，这个标识就是SEL。如下 代码所示：
    
    SEL sel1 = @selector(method1);
    NSLog(@"sel : %p", sel1);
    
    /**
     2017-05-10 17:53:28.964 runtime[7416:1765341] sel : 0x100002d72
     
     
     两个类之间，不管它们是父类与子类的关系，还是之间没有这种关系，只要方法名相同，那么方法的SEL就是一样的。每一个方法都对应着一个SEL。所以在 Objective-C同一个类(及类的继承体系)中，不能存在2个同名的方法，即使参数类型不同也不行。相同的方法只能对应一个SEL。这也就导致 Objective-C在处理相同方法名且参数个数相同但类型不同的方法方面的能力很差。如在某个类中定义以下两个方法：
     - (void)setWidth:(int)width;
     - (void)setWidth:(double)width;
     */
    
    //当然，不同的类可以拥有相同的selector，这个没有问题。不同类的实例对象执行相同的selector时，会在各自的方法列表中去根据selector去寻找自己对应的IMP。
    
   // 工程中的所有的SEL组成一个Set集合，Set的特点就是唯一，因此SEL是唯一的。因此，如果我们想到这个方法集合中查找某个方法时，只需要去 找到这个方法对应的SEL就行了，SEL实际上就是根据方法名hash化了的一个字符串，而对于字符串的比较仅仅需要比较他们的地址就可以了，可以说速度 上无语伦比！！但是，有一个问题，就是数量增多会增大hash冲突而导致的性能下降（或是没有冲突，因为也可能用的是perfect hash）。但是不管使用什么样的方法加速，如果能够将总量减少（多个方法可能对应同一个SEL），那将是最犀利的方法。那么，我们就不难理解，为什么 SEL仅仅是函数名了。
    
    //本质上，SEL只是一个指向方法的指针（准确的说，只是一个根据方法名hash化了的KEY值，能唯一代表一个方法），它的存在只是为了加快方法的查询速度。这个查找过程我们将在下面讨论。
    
    /**
     我们可以在运行时添加新的selector，也可以在运行时获取已存在的selector，我们可以通过下面三种方法来获取SEL:
     
     1.sel_registerName函数
     
     2.Objective-C编译器提供的@selector()
     
     3.NSSelectorFromString()方法
     */
    /**
     IMP
     
     IMP实际上是一个函数指针，指向方法实现的首地址。其定义如下：
     
     id (*IMP)(id, SEL, ...)
     这个函数使用当前CPU架构实现的标准的C调用约定。第一个参数是指向self的指针(如果是实例方法，则是类实例的内存地址；如果是类方法，则是指向元类的指针)，第二个参数是方法选择器(selector)，接下来是方法的实际参数列表。
     
     前面介绍过的SEL就是为了查找方法的最终实现IMP的。由于每个方法对应唯一的SEL，因此我们可以通过SEL方便快速准确地获得它所对应的 IMP，查找过程将在下面讨论。取得IMP后，我们就获得了执行这个方法代码的入口点，此时，我们就可以像调用普通的C语言函数一样来使用这个函数指针 了。
     
     通过取得IMP，我们可以跳过Runtime的消息传递机制，直接执行IMP指向的函数实现，这样省去了Runtime消息传递过程中所做的一系列查找操作，会比直接向对象发送消息高效一些。
     */
  
  
}




















@end
