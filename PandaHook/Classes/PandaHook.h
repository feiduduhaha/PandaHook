//
//  PandaHook.h
//  PandaHook
//
//  Created by silence on 2019/7/2.
//

#import <Foundation/Foundation.h>
#import "PandaHookBlockPool.h"

//hook之后回调的自定义实现，需要在此block中设计自定义实现，以及线程异步、同步等操作
typedef void(^PandaHookBlock)(NSArray * contextArr);

/**
    PandaHook支持对一个类进行多次hook（在不同时机），使用时需要注意，不需要多次hook时，避免重复hook
在正常开发过程中，用不到block的hook，但如果是动态获取block，并动态hook的时候，会用到此功能（比如通过服务器的配置，在运行时找到某个工程内的block，并hook它~）
本组件block的hook针对的是block的实例，也就是说hook block A 并不会影响 block B
 */
@interface PandaHook : NSObject


/// hook hook对象方法传入对象，hook类方法传入类
/// @param targetObj 目标对象
/// @param method 要hook的方法
/// @param isClassMethod 是否是类方法
/// @param hookTime hook时机
/// @param customImplementation 自定义实现
/// 返回值是本次hook的identify，可用此identify取消本次hook ,如果hook失败，返回nil
+ (NSString *)hookObj:(id)targetObj
          whichMethod:(SEL)method
        isClassMethod:(BOOL)isClassMethod
                 when:(PandaHookTime)hookTime
                 with:(PandaHookBlock) customImplementation;

///取消hook，恢复到hook之前的代码
+ (void)removeHookWithIdentify:(NSString *)identify hooktime:(PandaHookTime)hooktime;
/// 获取所有hook信息，用于查找排错
+ (NSArray *)getAllHookMessage;
/// 打印对象的方法列表
+ (void)printfAllMethodList:(id)obj;
/// 打印对象的属性列表
+ (void)printfAllIvarList:(id)obj;
@end


