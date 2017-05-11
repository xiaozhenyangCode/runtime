//
//  Person.m
//  runtime
//
//  Created by 一天 on 2017/5/10.
//  Copyright © 2017年 肖振阳. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import "SUTRuntimeMethodHelper.h"
#import "MyRuntimeBlock.h"


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
     //方法和消息
void test10(){
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
//Method
void test11(){


    //Method用于表示类定义中的方法，则定义如下：
    typedef struct objc_method *Method;
    struct objc_method {
        SEL method_name                     OBJC2_UNAVAILABLE;  // 方法名
        char *method_types                  OBJC2_UNAVAILABLE;
        IMP method_imp                      OBJC2_UNAVAILABLE;  // 方法实现
    };
    
    
    //我们可以看到该结构体中包含一个SEL和IMP，实际上相当于在SEL和IMP之间作了一个映射。有了SEL，我们便可以找到对应的IMP，从而调用方法的实现代码。
    //具体操作流程我们将在下面讨论。
    
    /// Defines a method
    struct objc_method_description {
        SEL name;               /**< 方法的名称 */
        char *types;            /**< 方法参数的类型 */
    };
   // objc_method_description定义了一个Objective-C方法，其定义如下：
    /**
     struct objc_method_description {
             SEL name;        方法的名称
            char *types;      方法参数的类型
        };*/

}
//方法相关操作函数
void test12(){

    //Runtime提供了一系列的方法来处理与方法相关的操作。包括方法本身及SEL。本节我们介绍一下这些函数。
    
    //方法操作相关函数包括下以：
    // 调用指定方法的实现
    //id method_invoke ( id receiver, Method m, ... );
    //method_invoke函数，返回的是实际实现的返回值。参数receiver不能为空。这个方法的效率会比method_getImplementation和method_getName更快。
    OBJC_EXPORT void method_invoke(void /* id receiver, Method m, ... */ );
   
    //调用返回一个数据结构的方法的实现
    //void method_invoke_stret ( id receiver, Method m, ... );
    OBJC_EXPORT void method_invoke_stret(void /* id receiver, Method m, ... */ );
    
    // 获取方法名
    //method_getName函数，返回的是一个SEL。如果想获取方法名的C字符串，可以使用sel_getName(method_getName(method))。
    SEL method_getName ( Method m );
    
    // 返回方法的实现
    IMP method_getImplementation ( Method m );
    
    // 获取描述方法参数和返回值类型的字符串
    const char * method_getTypeEncoding ( Method m );
    
    // 获取方法的返回值类型的字符串
    char * method_copyReturnType ( Method m );
    
    // 获取方法的指定位置参数的类型字符串
    char * method_copyArgumentType ( Method m, unsigned int index );
    
    // 通过引用返回方法的返回值类型字符串
    //method_getReturnType函数，类型字符串会被拷贝到dst中。
    void method_getReturnType ( Method m, char *dst, size_t dst_len );
    
    // 返回方法的参数的个数
    unsigned int method_getNumberOfArguments ( Method m );
    
    // 通过引用返回方法指定位置参数的类型字符串
    void method_getArgumentType ( Method m, unsigned int index, char *dst, size_t dst_len );
    
    // 返回指定方法的方法描述结构体
    struct objc_method_description * method_getDescription ( Method m );
    
    // 设置方法的实现
    //method_setImplementation函数，注意该函数返回值是方法之前的实现。
    IMP method_setImplementation ( Method m, IMP imp );
    
    // 交换两个方法的实现
    void method_exchangeImplementations ( Method m1, Method m2 );
}
//方法选择器
void test13(){
   
    //选择器相关的操作函数包括：
    // 返回给定选择器指定的方法的名称
    const char * sel_getName ( SEL sel );
    
    // 在Objective-C Runtime系统中注册一个方法，将方法名映射到一个选择器，并返回这个选择器
    //sel_registerName函数：在我们将一个方法添加到类定义时，我们必须在Objective-C Runtime系统中注册一个方法名以获取方法的选择器。
    SEL sel_registerName ( const char *str );
    
    // 在Objective-C Runtime系统中注册一个方法
    SEL sel_getUid ( const char *str );
    
    // 比较两个选择器
    BOOL sel_isEqual ( SEL lhs, SEL rhs );
    
    
}
//方法调用流程
void test14(){
    
    //在Objective-C中，消息直到运行时才绑定到方法实现上。编译器会将消息表达式[receiver message]转化为一个消息函数的调用，即objc_msgSend。这个函数将消息接收者和方法名作为其基础参数，如以下所示：
    //objc_msgSend(receiver, selector)
    
    
    // 如果消息中还有其它参数，则该方法的形式如下所示：
    // objc_msgSend(receiver, selector, arg1, arg2, ...)
    
    /**
     这个函数完成了动态绑定的所有事情：
     
     首先它找到selector对应的方法实现。因为同一个方法可能在不同的类中有不同的实现，所以我们需要依赖于接收者的类来找到的确切的实现。
     
     它调用方法实现，并将接收者对象及方法的所有参数传给它。
     
     最后，它将实现返回的值作为它自己的返回值。
     
     消息的关键在于我们前面章节讨论过的结构体objc_class，这个结构体有两个字段是我们在分发消息的关注的：
     
     指向父类的指针
     
     一个类的方法分发表，即methodLists。
     
     当我们创建一个新对象时，先为其分配内存，并初始化其成员变量。其中isa指针也会被初始化，让对象可以访问类及类的继承体系。
     
     当消息发送给一个对象时，objc_msgSend通过对象的isa指针获取到类的结构体，然后在方法分发表里面查找方法的selector。如果 没有找到selector，则通过objc_msgSend结构体中的指向父类的指针找到其父类，并在父类的分发表里面查找方法的selector。依 此，会一直沿着类的继承体系到达NSObject类。一旦定位到selector，函数会就获取到了实现的入口点，并传入相应的参数来执行方法的具体实 现。如果最后没有定位到selector，则会走消息转发流程，这个我们在后面讨论。
     
     为了加速消息的处理，运行时系统缓存使用过的selector及对应的方法的地址。这点我们在前面讨论过，不再重复。
     */
}
//隐藏参数
void test15(){

    /**
     objc_msgSend有两个隐藏参数：
     
     1.消息接收对象
     
     2.方法的selector
     
     这两个参数为方法的实现提供了调用者的信息。之所以说是隐藏的，是因为它们在定义方法的源代码中没有声明。它们是在编译期被插入实现代码的。
     
     虽然这些参数没有显示声明，但在代码中仍然可以引用它们。我们可以使用self来引用接收者对象，使用_cmd来引用选择器。如下代码所示：
     
     - strange
    {
         id  target = getTheReceiver();
         SEL method = getTheMethod();
         
         if ( target == self || method == _cmd )
         return nil;
         return [target performSelector:method];
     }
     当然，这两个参数我们用得比较多的是self，_cmd在实际中用得比较少。
     */
}
//获取方法地址
void test16(){
    
    /**
     Runtime中方法的动态绑定让我们写代码时更具灵活性，如我们可以把消息转发给我们想要的对象，或者随意交换一个方法的实现等。不过灵活性的提 升也带来了性能上的一些损耗。毕竟我们需要去查找方法的实现，而不像函数调用来得那么直接。当然，方法的缓存一定程度上解决了这一问题。
     
     我们上面提到过，如果想要避开这种动态绑定方式，我们可以获取方法实现的地址，然后像调用函数一样来直接调用它。特别是当我们需要在一个循环内频繁地调用一个特定的方法时，通过这种方式可以提高程序的性能。
     
     NSObject类提供了methodForSelector:方法，让我们可以获取到方法的指针，然后通过这个指针来调用实现代码。我们需要将methodForSelector:返回的指针转换为合适的函数类型，函数参数和返回值都需要匹配上。
     
     我们通过以下代码来看看methodForSelector:的使用：
     
     
     void (*setter)(id, SEL, BOOL);
     int i;
     
     setter = (void (*)(id, SEL, BOOL))[target
     methodForSelector:@selector(setFilled:)];
     for ( i = 0 ; i < 1000 ; i++ )
     setter(targetList[i], @selector(setFilled:), YES);
     
     
     这里需要注意的就是函数指针的前两个参数必须是id和SEL。
     
     当然这种方式只适合于在类似于for循环这种情况下频繁调用同一方法，以提高性能的情况。另外，methodForSelector:是由Cocoa运行时提供的；它不是Objective-C语言的特性。
     
     */
    
}
//消息转发
void test17(){

    /**
     当一个对象能接收一个消息时，就会走正常的方法调用流程。但如果一个对象无法接收指定消息时，又会发生什么事呢？默认情况下，如果是以 [object message]的方式调用方法，如果object无法响应message消息时，编译器会报错。但如果是以perform…的形式来调用，则需要等到运 行时才能确定object是否能接收message消息。如果不能，则程序崩溃。
     
     通常，当我们不能确定一个对象是否能接收某个消息时，会先调用respondsToSelector:来判断一下。如下代码所示：
     
     if ([self respondsToSelector:@selector(method)]) {
     [self performSelector:@selector(method)];
     }
     */
   
    
    //当一个对象无法接收某一消息时，就会启动所谓”消息转发(message forwarding)“机制，通过这一机制，我们可以告诉对象如何处理未知的消息。默认情况下，对象接收到未知的消息，会导致程序崩溃，通过控制台，我们可以看到以下异常信息：
    
    /**
     -[SUTRuntimeMethod method]: unrecognized selector sent to instance 0x100111940
     
     *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[SUTRuntimeMethod method]: unrecognized selector sent to instance 0x100111940'
     
     这段异常信息实际上是由NSObject的”doesNotRecognizeSelector”方法抛出的。不过，我们可以采取一些措施，让我们的程序执行特定的逻辑，而避免程序的崩溃。
     
     消息转发机制基本上分为三个步骤：
     
     1.动态方法解析
     
     2.备用接收者
     
     3.完整转发
     
     */
}
//动态方法解析
void test18(){

    //对象在接收到未知的消息时，首先会调用所属类的类方法+resolveInstanceMethod:(实例方法)或 者+resolveClassMethod:(类方法)。在这个方法中，我们有机会为该未知消息新增一个”处理方法”“。不过使用该方法的前提是我们已经 实现了该”处理方法”，只需要在运行时通过class_addMethod函数动态添加到类里面就可以了。如下代码所示：

}
void functionForMethod1(id self, SEL _cmd) {
    NSLog(@"%@, %p", self, _cmd);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
    NSString *selectorString = NSStringFromSelector(sel);
    
    if ([selectorString isEqualToString:@"method1"]) {
        class_addMethod(self.class, @selector(method1), (IMP)functionForMethod1, "@:");
    }
    
    return [super resolveInstanceMethod:sel];
    //不过这种方案更多的是为了实现@dynamic属性。
}
//备用接收者
void test19(){

    //如果在 test18 无法处理消息，则Runtime会继续调以下方法：
    NSObject *object = [[NSObject alloc]init];
    [object forwardingTargetForSelector:nil];
    
    //如果一个对象实现了这个方法，并返回一个非nil的结果，则这个对象会作为消息的新接收者，且消息会被分发到这个对象。当然这个对象不能是self自身，否则就是出现无限循环。当然，如果我们没有指定相应的对象来处理aSelector，则应该调用父类的实现来返回结果。
    
    //使用这个方法通常是在对象内部，可能还有一系列其它对象能处理该消息，我们便可借这些对象来处理消息并返回，这样在对象外部看来，还是由该对象亲自处理了这一消息。在 SUTRuntimeMethodHelper.m 里面有代码

}
//完整消息转发
void test20(){

    ///如果在上一步还不能处理未知消息，则唯一能做的就是启用完整的消息转发机制了。此时会调用以下方法：
    NSObject *object = [[NSObject alloc]init];
    [object forwardInvocation:nil];
    
    //运行时系统会在这一步给消息接收者最后一次机会将消息转发给其它对象。对象会创建一个表示消息的NSInvocation对象，把与尚未处理的消息 有关的全部细节都封装在anInvocation中，包括selector，目标(target)和参数。我们可以在forwardInvocation 方法中选择将消息转发给其它对象。
    
    
    /**forwardInvocation:方法的实现有两个任务：
    
    定位可以响应封装在anInvocation中的消息的对象。这个对象不需要能处理所有未知消息。
    
    使用anInvocation作为参数，将消息发送到选中的对象。anInvocation将会保留调用结果，运行时系统会提取这一结果并将其发送到消息的原始发送者。
    
    不过，在这个方法中我们可以实现一些更复杂的功能，我们可以对消息的内容进行修改，比如追回一个参数等，然后再去触发消息。另外，若发现某个消息不应由本类处理，则应调用父类的同名方法，以便继承体系中的每个类都有机会处理此调用请求。*/
    
    //还有一个很重要的问题，我们必须重写以下方法：
    
    //-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
    //消息转发机制使用从这个方法中获取的信息来创建NSInvocation对象。因此我们必须重写这个方法，为给定的selector提供一个合适的方法签名。
    
    //完整的示例如下所示：在 SUTRuntimeMethodHelper.m 里面
}
//消息转发与多重继承
void test21(){

    //回过头来看第二和第三步，通过这两个方法我们可以允许一个对象与其它对象建立关系，以处理某些未知消息，而表面上看仍然是该对象在处理消息。通过这 种关系，我们可以模拟“多重继承”的某些特性，让对象可以“继承”其它对象的特性来处理一些事情。不过，这两者间有一个重要的区别：多重继承将不同的功能 集成到一个对象中，它会让对象变得过大，涉及的东西过多；而消息转发将功能分解到独立的小的对象中，并通过某种方式将这些对象连接起来，并做相应的消息转发。
    
    //不过消息转发虽然类似于继承，但NSObject的一些方法还是能区分两者。如respondsToSelector:和isKindOfClass:只能用于继承体系，而不能用于转发链。便如果我们想让这种消息转发看起来像是继承，则可以重写这些方法，如以下代码所示：
}
- (BOOL)respondsToSelector:(SEL)aSelector{
    if ( [super respondsToSelector:aSelector] )
        return YES;
    else {
        /* Here, test whether the aSelector message can
         *
         * be forwarded to another object and whether that
         *
         * object can respond to it. Return YES if it can.
         */
    }
    return NO;
    //小结在此，我们已经了解了Runtime中消息发送和转发的基本机制。这也是Runtime的强大之处，通过它，我们可以为程序增加很多动态的行为，虽 然我们在实际开发中很少直接使用这些机制(如直接调用objc_msgSend)，但了解它们有助于我们更多地去了解底层的实现。其实在实际的编码过程中，我们也可以灵活地使用这些机制，去实现一些特殊的功能，如hook操作等。
}
//Method Swizzling
void test22(){

    /**
     
     理解Method Swizzling是学习runtime机制的一个很好的机会。在此不多做整理，仅翻译由Mattt Thompson发表于nshipster的Method Swizzling一文。
     
     Method Swizzling是改变一个selector的实际实现的技术。通过这一技术，我们可以在运行时通过修改类的分发表中selector对应的函数，来修改方法的实现。
     
     例如，我们想跟踪在程序中每一个view controller展示给用户的次数：当然，我们可以在每个view controller的viewDidAppear中添加跟踪代码；但是这太过麻烦，需要在每个view controller中写重复的代码。创建一个子类可能是一种实现方式，但需要同时创建UIViewController, UITableViewController, UINavigationController及其它UIKit中view controller的子类，这同样会产生许多重复的代码。
     这种情况下，我们就可以使用Method Swizzling，如在代码所示:在 TestViewController.m 里面
     
     在这里，我们通过method swizzling修改了UIViewController的@selector(viewWillAppear:)对应的函数指针，使其实现指向了我们自定义的xxx_viewWillAppear的实现。这样，当UIViewController及其子类的对象调用viewWillAppear时，都会打印一条日志信息。
     
     在 TestViewController.m 的例子很好地展示了使用method swizzling来一个类中注入一些我们新的操作。当然，还有许多场景可以使用method swizzling，在此不多举例。在此我们说说使用method swizzling需要注意的一些问题：

     */
    /**
     Swizzling应该总是在+load中执行
     
     在Objective-C中，运行时会自动调用每个类的两个方法。+load会在类初始加载时调用，+initialize会在第一次调用类的类方法或实例方法之前被调用。这两个方法是可选的，且只有在实现了它们时才会被调用。由于method swizzling会影响到类的全局状态，因此要尽量避免在并发处理中出现竞争的情况。+load能保证在类的初始化过程中被加载，并保证这种改变应用级别的行为的一致性。相比之下，+initialize在其执行时不提供这种保证—事实上，如果在应用中没为给这个类发送消息，则它可能永远不会被调用。
     
     Swizzling应该总是在dispatch_once中执行
     
     与上面相同，因为swizzling会改变全局状态，所以我们需要在运行时采取一些预防措施。原子性就是这样一种措施，它确保代码只被执行一次，不管有多少个线程。GCD的dispatch_once可以确保这种行为，我们应该将其作为method swizzling的最佳实践。
     
     选择器、方法与实现
     
     在Objective-C中，选择器(selector)、方法(method)和实现(implementation)是运行时中一个特殊点，虽然在一般情况下，这些术语更多的是用在消息发送的过程描述中。
     
     以下是Objective-C Runtime Reference中的对这几个术语一些描述：
     
     Selector(typedef struct objc_selector *SEL)：用于在运行时中表示一个方法的名称。一个方法选择器是一个C字符串，它是在Objective-C运行时被注册的。选择器由编译器生成，并且在类被加载时由运行时自动做映射操作。
     
     Method(typedef struct objc_method *Method)：在类定义中表示方法的类型
     
     Implementation(typedef id (*IMP)(id, SEL, …))：这是一个指针类型，指向方法实现函数的开始位置。这个函数使用为当前CPU架构实现的标准C调用规范。每一个参数是指向对象自身的指针(self)，第二个参数是方法选择器。然后是方法的实际参数。
     
     理解这几个术语之间的关系最好的方式是：一个类维护一个运行时可接收的消息分发表；分发表中的每个入口是一个方法(Method)，其中key是一个特定名称，即选择器(SEL)，其对应一个实现(IMP)，即指向底层C函数的指针。
     
     为了swizzle一个方法，我们可以在分发表中将一个方法的现有的选择器映射到不同的实现，而将该选择器对应的原始实现关联到一个新的选择器中。
     
     */
    
}
//调用_cmd
void test23(){
    
    
    //我们回过头来看看前面新的方法的实现代码：
    /**
    - (void)xxx_viewWillAppear:(BOOL)animated {
        [self xxx_viewWillAppear:animated];
        NSLog(@"viewWillAppear: %@", NSStringFromClass([self class]));
    }
     */
    //咋看上去是会导致无限循环的。但令人惊奇的是，并没有出现这种情况。在swizzling的过程中，方法中的[self xxx_viewWillAppear:animated]已经被重新指定到UIViewController类的-viewWillAppear:中。在这种情况下，不会产生无限循环。不过如果我们调用的是[self viewWillAppear:animated]，则会产生无限循环，因为这个方法的实现在运行时已经被重新指定为xxx_viewWillAppear:了。
}
//Swizzling 注意事项
void test24(){

    /**
     Swizzling通常被称作是一种黑魔法，容易产生不可预知的行为和无法预见的后果。虽然它不是最安全的，但如果遵从以下几点预防措施的话，还是比较安全的：
     
     总是调用方法的原始实现(除非有更好的理由不这么做)：API提供了一个输入与输出约定，但其内部实现是一个黑盒。Swizzle一个方法而不调用原始实现可能会打破私有状态底层操作，从而影响到程序的其它部分。
     
     避免冲突：给自定义的分类方法加前缀，从而使其与所依赖的代码库不会存在命名冲突。
     
     明白是怎么回事：简单地拷贝粘贴swizzle代码而不理解它是如何工作的，不仅危险，而且会浪费学习Objective-C运行时的机会。阅读Objective-C Runtime Reference和查看<objc/runtime.h>头文件以了解事件是如何发生的。
     
     */
#pragma mark -   小心操作：无论我们对Foundation, UIKit或其它内建框架执行Swizzle操作抱有多大信心，需要知道在下一版本中许多事可能会不一样。


}
//协议与分类
void test25(){

    /**
     Objective-C中的分类允许我们通过给一个类添加方法来扩充它（但是通过category不能添加新的实例变量），并且我们不需要访问类中的代码就可以做到。
     
     Objective-C中的协议是普遍存在的接口定义方式，即在一个类中通过@protocol定义接口，在另外类中实现接口，这种接口定义方式也成为“delegation”模式，@protocol声明了可以被其他任何方法类实现的方法，协议仅仅是定义一个接口，而由其他的类去负责实现。
     
     在本章中，我们来看看runtime对分类与协议的支持。
     
     */
}
//基础数据类型
void test26(){

    //Category
    //Category是表示一个指向分类的结构体的指针，其定义如下：
    
    typedef struct objc_category *Category;
    struct objc_category {
        char *category_name                          OBJC2_UNAVAILABLE; // 分类名
        char *class_name                             OBJC2_UNAVAILABLE; // 分类所属的类名
        struct objc_method_list *instance_methods    OBJC2_UNAVAILABLE; // 实例方法列表
        struct objc_method_list *class_methods       OBJC2_UNAVAILABLE; // 类方法列表
        struct objc_protocol_list *protocols         OBJC2_UNAVAILABLE; // 分类所实现的协议列表
    };
    //这个结构体主要包含了分类定义的实例方法与类方法，其中instance_methods列表是objc_class中方法列表的一个子集，而class_methods列表是元类方法列表的一个子集。
    
    
    //Protocol
    //Protocol的定义如下：
    
    typedef struct objc_object Protocol;

   //可以看到，Protocol其中实就是一个对象结构体。

}
//操作函数
void test27(){

    //Runtime并没有在<objc/runtime.h>头文件中提供针对分类的操作函数。因为这些分类中的信息都包含在objc_class中，
    //我们可以通过针对objc_class的操作函数来获取分类的信息。如下例所示：测试代码在 TestViewController.m 中

    /**
     其输出是：
     2017-05-11 12:39:06.901 runtime[1522:829959] 测试objc_class中的方法列表是否包含分类中的方法
     2017-05-11 12:39:06.901 runtime[1522:829959] RuntimeCategoryClass's method: method1
     2017-05-11 12:39:06.902 runtime[1522:829959] 分类方法method2在objc_class的方法列表中
     2017-05-11 12:39:06.902 runtime[1522:829959] RuntimeCategoryClass's method: method2
     */
    
    //而对于Protocol，runtime提供了一系列函数来对其进行操作，这些函数包括：
    
    // 返回指定的协议
    //objc_getProtocol函数，需要注意的是如果仅仅是声明了一个协议，而未在任何类中实现这个协议，则该函数返回的是nil。
    Protocol * objc_getProtocol ( const char *name );
    
    // 获取运行时所知道的所有协议的数组
    //objc_copyProtocolList函数，获取到的数组需要使用free来释放
//    Protocol ** objc_copyProtocolList ( unsigned int *outCount );
    
    // 创建新的协议实例
    //objc_allocateProtocol函数，如果同名的协议已经存在，则返回nil
    Protocol * objc_allocateProtocol ( const char *name );
    
    // 在运行时中注册新创建的协议
    //objc_registerProtocol函数，创建一个新的协议后，必须调用该函数以在运行时中注册新的协议。协议注册后便可以使用，但不能再做修改，即注册完后不能再向协议添加方法或协议
    void objc_registerProtocol ( Protocol *proto );
    
    // 为协议添加方法
    void protocol_addMethodDescription ( Protocol *proto, SEL name, const char *types, BOOL isRequiredMethod, BOOL isInstanceMethod );
    
    // 添加一个已注册的协议到协议中
    void protocol_addProtocol ( Protocol *proto, Protocol *addition );
    
    // 为协议添加属性
    void protocol_addProperty ( Protocol *proto, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount, BOOL isRequiredProperty, BOOL isInstanceProperty );
    
    // 返回协议名
    const char * protocol_getName ( Protocol *p );
    
    // 测试两个协议是否相等
    BOOL protocol_isEqual ( Protocol *proto, Protocol *other );
    
    // 获取协议中指定条件的方法的方法描述数组
    struct objc_method_description * protocol_copyMethodDescriptionList ( Protocol *p, BOOL isRequiredMethod, BOOL isInstanceMethod, unsigned int *outCount );
    
    // 获取协议中指定方法的方法描述
    struct objc_method_description protocol_getMethodDescription ( Protocol *p, SEL aSel, BOOL isRequiredMethod, BOOL isInstanceMethod );
    
    // 获取协议中的属性列表
    objc_property_t * protocol_copyPropertyList ( Protocol *proto, unsigned int *outCount );
    
    // 获取协议的指定属性
    objc_property_t protocol_getProperty ( Protocol *proto, const char *name, BOOL isRequiredProperty, BOOL isInstanceProperty );
    
    // 获取协议采用的协议
//    Protocol ** protocol_copyProtocolList ( Protocol *proto, unsigned int *outCount );
    
    // 查看协议是否采用了另一个协议
    BOOL protocol_conformsToProtocol ( Protocol *proto, Protocol *other );

#pragma mark - 需要强调的是，协议一旦注册后就不可再修改，即无法再通过调用protocol_addMethodDescription、protocol_addProtocol和protocol_addProperty往协议中添加方法等
    
    //小结  Runtime并没有提供过多的函数来处理分类。对于协议，我们可以动态地创建协议，并向其添加方法、属性及继承的协议，并在运行时动态地获取这些信息
}
//库相关操作
void test28(){

    //库相关的操作主要是用于获取由系统提供的库相关的信息，主要包含以下函数：
    
    // 获取所有加载的Objective-C框架和动态库的名称
    const char ** objc_copyImageNames ( unsigned int *outCount );
    
    // 获取指定类所在动态库
    const char * class_getImageName ( Class cls );
    
    // 获取指定库或框架中所有类的类名
    const char ** objc_copyClassNamesForImage ( const char *image, unsigned int *outCount );

    //通过这几个函数，我们可以了解到某个类所有的库，以及某个库中包含哪些类。如下代码所示：代码在 TestClass.m 里面

    
}
//块操作
void test29(){
    
   // 我们都知道block给我们带到极大的方便，苹果也不断提供一些使用block的新的API。\
    同时，苹果在runtime中也提供了一些函数来支持针对block的操作，这些函数包括：

    // 创建一个指针函数的指针，该函数调用时会调用特定的block
    IMP imp_implementationWithBlock ( id block );
    
    // 返回与IMP(使用imp_implementationWithBlock创建的)相关的block
    id imp_getBlock ( IMP anImp );
    
    // 解除block与IMP(使用imp_implementationWithBlock创建的)的关联关系，并释放block的拷贝
    BOOL imp_removeBlock ( IMP anImp );
    
    //imp_implementationWithBlock函数：参数block的签名必须是method_return_type ^(id self, method_args …)形式的。\
    该方法能让我们使用block作为IMP。如下代码所示：
    
    // 测试代码
    IMP imp = imp_implementationWithBlock(^(id obj, NSString *str) {
        NSLog(@"%@", str);
    });
    class_addMethod(MyRuntimeBlock.class, @selector(testBlock:), imp, "v@:@");
    
    MyRuntimeBlock *runtime = [[MyRuntimeBlock alloc] init];
    [runtime performSelector:@selector(testBlock:) withObject:@"hello world!"];

    /**
     输出结果是:2017-05-11 12:57:26.793 runtime[1652:970046] hello world!
     */
}
//弱引用操作
void test30(){
    
    // 加载弱引用指针引用的对象并返回
    //objc_loadWeak函数：该函数加载一个弱指针引用的对象，并在对其做retain和autoreleasing操作后返回它。这样，对象就可以在调用者使用它时保持足够长的生命周期。该函数典型的用法是在任何有使用__weak变量的表达式中使用。
    id objc_loadWeak ( id *location );
    
    // 存储__weak变量的新值
    //objc_storeWeak函数：该函数的典型用法是用于__weak变量做为赋值对象时
    id objc_storeWeak ( id *location, id obj );

    //这两个函数的具体实施可以参考《Objective-C高级编程：iOS与OS X多线程和内存管理》中对__weak实现的介绍。
}
//宏定义
void test31(){
    
    //在runtime中，还定义了一些宏定义供我们使用，有些值我们会经常用到，如表示BOOL值的YES/NO；而有些值不常用，如OBJC_ROOT_CLASS。在此我们做一个简单的介绍。

    //布尔值
    #define YES  (BOOL)1
    #define NO   (BOOL)0
    //这两个宏定义定义了表示布尔值的常量，需要注意的是YES的值是1，而不是非0值。
    
    //空值
    #define nil  __DARWIN_NULL
    #define Nil  __DARWIN_NULL
    //其中nil用于空的实例对象，而Nil用于空类对象。
    
    //分发函数原型
    #define OBJC_OLD_DISPATCH_PROTOTYPES  1
    //该宏指明分发函数是否必须转换为合适的函数指针类型。当值为0时，必须进行转换
    
    //Objective-C根类
    #define OBJC_ROOT_CLASS
    //如果我们定义了一个Objective-C根类，则编译器会报错，指明我们定义的类没有指定一个基类。这种情况下，我们就可以使用这个宏定义来避过这个编译错误。该宏在iOS 7.0后可用。
    
    
    //其实在NSObject的声明中，我们就可以看到这个宏的身影，如下所示：
    /**
    __OSX_AVAILABLE_STARTING(__MAC_10_0, __IPHONE_2_0)
    OBJC_ROOT_CLASS
    OBJC_EXPORT
    @interface NSObject <NSObject> {
        Class isa  OBJC_ISA_AVAILABILITY;
    }
     */
    //我们可以参考这种方式来定义我们自己的根类。
    
    
    
    //局部变量存储时长
    #define NS_VALID_UNTIL_END_OF_SCOPE
    //该宏表明存储在某些局部变量中的值在优化时不应该被编译器强制释放。\
    我们将局部变量标记为id类型或者是指向ObjC对象类型的指针，以便存储在这些局部变量中的值在优化时不会被编译器强制释放。相反，这些值会在变量再次被赋值之前或者局部变量的作用域结束之前都会被保存。
    
    //关联对象行为
    enum {
        OBJC_ASSOCIATION_ASSIGN  = 0,
        OBJC_ASSOCIATION_RETAIN_NONATOMIC  = 1,
        OBJC_ASSOCIATION_COPY_NONATOMIC  = 3,
        OBJC_ASSOCIATION_RETAIN  = 01401,
        OBJC_ASSOCIATION_COPY  = 01403
    };
    //参照 test8
    
}


















@end
