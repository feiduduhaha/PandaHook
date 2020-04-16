//
//  PandaHook.m
//  PandaHook
//
//  Created by silence on 2019/7/2.
//

#import "PandaHook.h"
#import <objc/runtime.h>
#import <objc/message.h>

#if !OBJC_OLD_DISPATCH_PROTOTYPES
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-library-redeclaration"
OBJC_EXPORT void
_objc_msgForward(void /* id receiver, SEL sel, ... */ )
    OBJC_AVAILABLE(10.0, 2.0, 9.0, 1.0, 2.0);

OBJC_EXPORT void
_objc_msgForward_stret(void /* id receiver, SEL sel, ... */ )
    OBJC_AVAILABLE(10.6, 3.0, 9.0, 1.0, 2.0)
    OBJC_ARM64_UNAVAILABLE;
#pragma clang diagnostic pop
#else
OBJC_EXPORT id _Nullable
_objc_msgForward(id _Nonnull receiver, SEL _Nonnull sel, ...)
    OBJC_AVAILABLE(10.0, 2.0, 9.0, 1.0, 2.0);

OBJC_EXPORT void
_objc_msgForward_stret(id _Nonnull receiver, SEL _Nonnull sel, ...)
    OBJC_AVAILABLE(10.6, 3.0, 9.0, 1.0, 2.0)
    OBJC_ARM64_UNAVAILABLE;
#endif

typedef NS_ENUM (int, PandaHook_BLOCKFLAGS) {
    PandaHook_BLOCK_HAS_COPY_DISPOSE =  (1 << 25),
    PandaHook_BLOCK_HAS_SIGNATURE  =    (1 << 30)
};
struct PandaHook_Block_descriptor {
    const char *signature;
    const char *layout;
};
struct PandaHook_Block_descriptor_1 {
    unsigned long int reserved;         // NULL
    unsigned long int size;         // sizeof(struct Block_literal_1)
    // optional helper functions
    void (*copy_helper)(void *dst, void *src);     // IFF (1<<25)
    void (*dispose_helper)(void *src);             // IFF (1<<25)
    // required ABI.2010.3.16
    const char *signature;                         // IFF (1<<30)
} *descriptor;

struct PandaHook_Block_layout {
    void *isa;  // initialized to &_NSConcreteStackBlock or &_NSConcreteGlobalBlock
    volatile int32_t flags;
    int32_t reserved;
    void (*invoke)(void *, ...);
    struct PandaHook_Block_descriptor_1 *descriptor;
};

const char * PandaHook_Block_signature(void *aBlock);
typedef  struct PandaHook_Block_layout  *PandaHook_Block;
typedef  void(^HookBlock) (NSDictionary * context);

#define PandaHook_DeepCopyBlockTag @"PandaHook_DeepCopyBlockTag"
#define PandaHook_Continue(status,msg) if(!status) {NSLog(@"%@",msg); return nil;}

#ifdef DEBUG
#define PandaHook_Log(msg) NSLog(@"%@",msg);
#else
#define PandaHook_Log(msg);
#endif


static PandaHook * hookManager = nil;

NSString * hookRecordIdentify (id obj , SEL sel , BOOL isClassMethod){
    
    return [NSString stringWithFormat:@"%@[%@ %@]",(isClassMethod?@"+":@"-"),obj,NSStringFromSelector(sel)];
}

NSString * saveMethodName (SEL sel , BOOL isClassMethod){
    
    return [NSString stringWithFormat:@"pandaSaveOld_%@_%@",(isClassMethod?@"ClassM":@"InstanceM"),NSStringFromSelector(sel)];
}

@interface PandaHook ()
@property (nonatomic , strong) PandaHookBlockPool * blockPool;
@property (nonatomic , assign) IMP pandaForward;
@end

@implementation PandaHook

+ (PandaHookBlock)hookClass:(Class)targetClass
                whichMethod:(SEL)method
              isClassMethod:(BOOL)isClassMethod
                       when:(PandaHookTime)hookTime
                       with:(PandaHookBlock) customImplementation
{
    if (!customImplementation) return nil;
    if (!object_isClass(targetClass)) return nil;
    
    Class handalClass = isClassMethod ? object_getClass(targetClass) : targetClass;
    NSString * hookIdentify = hookRecordIdentify(handalClass, method, isClassMethod);
    //判断同一个对象的同一个方法是否hook过
    BOOL didHook = [hookManager.blockPool didHookedWithIdentify:hookIdentify];
    
    if (!didHook) {//如果没有hook过，进行hook
                     
        //将旧实现重命名保存
        Method oldMethod =  isClassMethod ? class_getClassMethod(handalClass, method) : class_getInstanceMethod(handalClass, method);
        PandaHook_Continue(oldMethod,@"PandaHook-未找到要hook的方法");
        NSString * newSelName = saveMethodName(method, isClassMethod);
        PandaHook_Continue([self addMethodForObj:handalClass method:oldMethod newMethodName:newSelName],
                           @"PandaHook-保存原方法失败，放弃hook");
        //将targetObj的forward实现指向pandaForward
        SEL pandaSel = @selector(pandaHook_forwardInvocation:);
        Method pandaMethod = class_getInstanceMethod([PandaHook class], pandaSel);
        //PandaHook-保存原forwardInvocation:
        [self addMethodForObj:handalClass method:pandaMethod newMethodName:@"forwardInvocation:"];
        //将旧方法指向forward实现，为了安全起见，这步操作一定要上面的操作全部成功才能操作
        PandaHook_Continue(method_setImplementation(oldMethod, _objc_msgForward),@"PandaHook-旧forward指向pandaForward失败，放弃hook");
        didHook = YES;
        PandaHook_Log([@"hook成功" stringByAppendingString:hookIdentify]);
    }
    if (didHook) {//如果成功hook，保存实现,__NSStackBlock__类型需要转为__NSMallocBlock__ ，至于__NSGlobalBlock__类型，保存时会判断内存地址
        
        if ([NSStringFromClass([customImplementation class]) isEqualToString:@"__NSStackBlock__"]) {
            customImplementation = [customImplementation copy];
        }
        [hookManager.blockPool addNewBlcokWithIdentify:hookIdentify andCallTime:hookTime block:customImplementation];
    }
    return customImplementation;
}

+ (PandaHookBlock)hookBlock:(id)block
                   when:(PandaHookTime)hookTime
                   with:(PandaHookBlock) customImplementation
{
    NSString * hookIdentify =  hookRecordIdentify(block, @selector(invoke), NO);
    BOOL didHook = [hookManager.blockPool didHookedWithIdentify:hookIdentify];
    if (!didHook) {//如果没有hook过，进行hook
     
        if ([NSStringFromClass([block class]) hasPrefix:@"__NSGlobalBlock"] ||
            [NSStringFromClass([block class]) hasPrefix:@"__NSStackBlock"] ||
            [NSStringFromClass([block class]) hasPrefix:@"__NSMallocBlock"]) {
            
            didHook = [self hookBlock:block hookTime:hookTime callback:customImplementation];
        }
    }
    return customImplementation;
}


+ (BOOL)addMethodForObj:(Class)class method:(Method)method newMethodName:(NSString *)newSelName{
    
    IMP pandaImp = method_getImplementation(method);
    return class_addMethod(class,NSSelectorFromString(newSelName),pandaImp,method_getTypeEncoding(method));
}
#pragma mark  normal hook
- (void)pandaHook_forwardInvocation:(NSInvocation *)invocation {

    if ([NSStringFromSelector(invocation.selector) isEqualToString:@"forwardInvocation:"]) {
        
        invocation.target = [object_getClass(invocation.target) superclass];
        [invocation invoke];
        return;
    }
    BOOL isClassMethod = object_isClass(invocation.target);
    NSString * hookIdentify = nil;
    //区分block或者其他oc类型，对invocation重定向
    id targetObj = invocation.target;
    if ([NSStringFromClass([targetObj class]) hasPrefix:@"__NSGlobalBlock"] ||
        [NSStringFromClass([targetObj class]) hasPrefix:@"__NSStackBlock"] ||
        [NSStringFromClass([targetObj class]) hasPrefix:@"__NSMallocBlock"]) {
        
        hookIdentify = hookRecordIdentify(invocation.target, @selector(invoke), NO);
        hookIdentify = [hookIdentify stringByReplacingOccurrencesOfString:@"pandaSaveOld_InstanceM_" withString:@""];
        id deepCopy_Block = objc_getAssociatedObject(self, PandaHook_DeepCopyBlockTag);
        invocation.target = deepCopy_Block;
        [PandaHook fireInvocation:invocation withIdentify:hookIdentify];
    }else{
        
        invocation.selector = NSSelectorFromString(saveMethodName(invocation.selector, isClassMethod));
        Method oldMethod =  nil;
        Class  targetClass = [targetObj class];
        while (1) {//遍历继承链，只要响应当前方法，就调用实现

            oldMethod =  isClassMethod ? class_getClassMethod(targetClass, invocation.selector) : class_getInstanceMethod(targetClass, invocation.selector);
            if (oldMethod) {
                
                hookIdentify = hookRecordIdentify(targetClass, invocation.selector, isClassMethod);
                hookIdentify = [hookIdentify stringByReplacingOccurrencesOfString:isClassMethod ?@"pandaSaveOld_ClassM_":@"pandaSaveOld_InstanceM_" withString:@""];
            }
            targetClass = [targetClass superclass];
            if (!targetClass) break;
        }
        [PandaHook fireInvocation:invocation withIdentify:hookIdentify];
    }
}

+ (void)fireInvocation:(NSInvocation *)invocation withIdentify:(NSString *)hookIdentify{
    
    NSArray * argumentsArr = [PandaHook getAllArgumentsWith:invocation];
    //在执行原来实现的前、替换、后 三个时机分别执行hook代码
    NSArray * arr = [hookManager.blockPool getBlocksWithIdentify:hookIdentify callTime:PandaHookTimeBefore];
    for (PandaHookBlock block in arr) {
        
        block(argumentsArr);
    }
    arr = [hookManager.blockPool getBlocksWithIdentify:hookIdentify callTime:PandaHookTimeInstead];
    if (arr.count) {
        
        for (PandaHookBlock block in arr) {
            
            block(argumentsArr);
        }
    }else{
        
        if ([invocation.target respondsToSelector:invocation.selector]) {
            
            [invocation invoke];
        }else{
            
#ifdef DEBUG
            //如果能响应方法，DEBUG下还是保持OC的逻辑抛错
            [invocation.target doesNotRecognizeSelector:invocation.selector];
#endif
        }
    }
    
    arr = [hookManager.blockPool getBlocksWithIdentify:hookIdentify callTime:PandaHookTimeAfter];
    for (PandaHookBlock block in arr) {
        
        block(argumentsArr);
    }
}

#pragma mark Block Hook

- (NSMethodSignature *)pandaHook_methodSignatureForSelector:(SEL)aSelector{
    
    Method method = class_getInstanceMethod([self class], @selector(methodSignatureForSelector:));
    return [NSMethodSignature signatureWithObjCTypes:method_getTypeEncoding(method)];
}
+ (BOOL)hookBlock:(id)blockObj hookTime:(PandaHookTime)hookTime callback:(PandaHookBlock)callback{
        
    Class class = NSClassFromString(@"NSBlock");
    //hook NSBlock
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method method = class_getInstanceMethod([PandaHook class], @selector(pandaHook_methodSignatureForSelector:));
        [self addMethodForObj:class method:method newMethodName:@"methodSignatureForSelector:"];
        
        SEL pandaSel = @selector(pandaHook_forwardInvocation:);
        Method pandaMethod = class_getInstanceMethod([PandaHook class], pandaSel);
        [self addMethodForObj:class method:pandaMethod newMethodName:@"forwardInvocation:"];
    });
    
    //判断该block 是否被hook过
    if (!objc_getAssociatedObject(self, PandaHook_DeepCopyBlockTag)) {
        
        //深拷贝blcok
        PandaHook_Block oriBlock = (__bridge PandaHook_Block)(blockObj);
        PandaHook_Block newBlock = malloc(oriBlock->descriptor->size);
        memmove(newBlock, oriBlock, oriBlock->descriptor->size);
        newBlock->isa = oriBlock->isa;
        newBlock->flags = oriBlock->flags;
        newBlock->invoke = oriBlock->invoke;
        newBlock->reserved = oriBlock->reserved;
        newBlock->descriptor = oriBlock->descriptor;
        
        //将深拷贝的block 设置为源block的关联属性
        objc_setAssociatedObject((__bridge id)oriBlock,
                                 PandaHook_DeepCopyBlockTag,
                                 (__bridge id)newBlock,
                                 OBJC_ASSOCIATION_ASSIGN);//最后这个参数使用assig的原因是，被绑定的对象本身已经是被拷贝出来的了
        //将源block的invoke指针指向msgForwardIMP 进入转发
        IMP msgForwardIMP = _objc_msgForward;
        oriBlock->invoke = (void *) msgForwardIMP;
    }
    return YES;
}

/// 获取所有hook信息，用于查找排错
+ (NSArray *)getAllHookMessage{
    
    return hookManager.blockPool.recordArr;
}

#pragma mark aspectMethod
//对于NSInvocation参数的获取，感谢aspects框架的开发者们，也感谢ReactiveCocoa团队提供的这种方式
// Thanks to the ReactiveCocoa team for providing a generic solution for this.
//And I got inspiration from aspects ,thanks To aspects team
+ (id)getArgumentsWith:(NSInvocation *)invocation index:(NSInteger)index{
    
    const char *argType = [invocation.methodSignature getArgumentTypeAtIndex:index];
    // Skip const type qualifier.
    if (argType[0] == _C_CONST) argType++;

#define WRAP_AND_RETURN(type) do { type val = 0; [invocation getArgument:&val atIndex:(NSInteger)index]; return @(val); } while (0)
    if (strcmp(argType, @encode(id)) == 0 || strcmp(argType, @encode(Class)) == 0) {
        __autoreleasing id returnObj;
        [invocation getArgument:&returnObj atIndex:(NSInteger)index];
        return returnObj;
    } else if (strcmp(argType, @encode(SEL)) == 0) {
        SEL selector = 0;
        [invocation getArgument:&selector atIndex:(NSInteger)index];
        return NSStringFromSelector(selector);
    } else if (strcmp(argType, @encode(Class)) == 0) {
        __autoreleasing Class theClass = Nil;
        [invocation getArgument:&theClass atIndex:(NSInteger)index];
        return theClass;
        // Using this list will box the number with the appropriate constructor, instead of the generic NSValue.
    } else if (strcmp(argType, @encode(char)) == 0) {
        WRAP_AND_RETURN(char);
    } else if (strcmp(argType, @encode(int)) == 0) {
        WRAP_AND_RETURN(int);
    } else if (strcmp(argType, @encode(short)) == 0) {
        WRAP_AND_RETURN(short);
    } else if (strcmp(argType, @encode(long)) == 0) {
        WRAP_AND_RETURN(long);
    } else if (strcmp(argType, @encode(long long)) == 0) {
        WRAP_AND_RETURN(long long);
    } else if (strcmp(argType, @encode(unsigned char)) == 0) {
        WRAP_AND_RETURN(unsigned char);
    } else if (strcmp(argType, @encode(unsigned int)) == 0) {
        WRAP_AND_RETURN(unsigned int);
    } else if (strcmp(argType, @encode(unsigned short)) == 0) {
        WRAP_AND_RETURN(unsigned short);
    } else if (strcmp(argType, @encode(unsigned long)) == 0) {
        WRAP_AND_RETURN(unsigned long);
    } else if (strcmp(argType, @encode(unsigned long long)) == 0) {
        WRAP_AND_RETURN(unsigned long long);
    } else if (strcmp(argType, @encode(float)) == 0) {
        WRAP_AND_RETURN(float);
    } else if (strcmp(argType, @encode(double)) == 0) {
        WRAP_AND_RETURN(double);
    } else if (strcmp(argType, @encode(BOOL)) == 0) {
        WRAP_AND_RETURN(BOOL);
    } else if (strcmp(argType, @encode(bool)) == 0) {
        WRAP_AND_RETURN(BOOL);
    } else if (strcmp(argType, @encode(char *)) == 0) {
        WRAP_AND_RETURN(const char *);
    } else if (strcmp(argType, @encode(void (^)(void))) == 0) {
        __unsafe_unretained id block = nil;
        [invocation getArgument:&block atIndex:(NSInteger)index];
        return [block copy];
    } else {
        NSUInteger valueSize = 0;
        NSGetSizeAndAlignment(argType, &valueSize, NULL);

        unsigned char valueBytes[valueSize];
        [invocation getArgument:valueBytes atIndex:index];

        return [NSValue valueWithBytes:valueBytes objCType:argType];
    }
    return nil;
#undef WRAP_AND_RETURN
}
+ (NSArray *)getAllArgumentsWith:(NSInvocation *)invocation{
    
    NSMutableArray *argumentsArray = [NSMutableArray array];
    [argumentsArray addObject:invocation.target?:NSNull.null];
    for (NSInteger idx = 2; idx < invocation.methodSignature.numberOfArguments; idx++) {
        [argumentsArray addObject:[self getArgumentsWith:invocation index:idx] ?: NSNull.null];
    }
    return [argumentsArray copy];
}


/// 打印对象的方法列表
+ (void)printfAllMethodList:(id)obj{
    
    NSLog(@"\n%@方法列表:",obj);
    Class targetClass = [obj class];
    unsigned int count;
    
    if (!class_isMetaClass(targetClass)) {
        
        printf("\t实例方法");
        Method *methods = class_copyMethodList(targetClass, &count);
        for (int i = 0; i < count; i++) {
            Method method = methods[i];
            SEL selector = method_getName(method);
            NSString *name = NSStringFromSelector(selector);
            printf("\n\t%s%s","-",[name UTF8String]);
        }
        free(methods);
        while (!class_isMetaClass(targetClass)) {

            targetClass = object_getClass(targetClass);
        }
    }
    printf("\n\t类方法");
    Method *classMethods = class_copyMethodList(targetClass, &count);
    for (int i = 0; i < count; i++) {
        Method method = classMethods[i];
        SEL selector = method_getName(method);
        NSString *name = NSStringFromSelector(selector);
        printf("\n\t%s%s","+",[name UTF8String]);
    }
    free(classMethods);
    printf("\n");
}

/// 打印对象的属性列表
+ (void)printfAllIvarList:(id)obj{
    
    NSLog(@"\n%@属性列表:",obj);
    unsigned int numIvars;
    Ivar *vars = class_copyIvarList([obj class], &numIvars);
    NSString *key=nil;
    for(int i = 0; i < numIvars; i++) {
        
        Ivar thisIvar = vars[i];
        key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
        printf("\n\t%s",[key UTF8String]);
    }
    printf("\n");
    free(vars);
}

#pragma mark +init
+ (void)initialize{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        hookManager = [self new];
        hookManager.blockPool = [PandaHookBlockPool new];
        Method forwardMethod = class_getInstanceMethod(self, @selector(forwardInvocation:));
        hookManager.pandaForward = method_getImplementation(forwardMethod);
    });
}
@end
