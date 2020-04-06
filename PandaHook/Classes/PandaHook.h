//
//  PandaHook.h
//  PandaHook
//
//  Created by silence on 2019/7/2.
//

#import <Foundation/Foundation.h>
#import "PandaHookBlockPool.h"

typedef void(^PandaHookBlock)(NSArray * contextArr);

@interface PandaHook : NSObject

/// @param targetClass 目标类
/// @param method 要hook的方法
/// @param isClassMethod 是否是类方法
/// @param hookTime hook时机
/// @param customImplementation 自定义实现
/// 返回值是本次hook的自定义实现，内部对此block是弱引用的，需要外部管理生命周期
+ (PandaHookBlock)hookClass:(Class)targetClass
                whichMethod:(SEL)method
              isClassMethod:(BOOL)isClassMethod
                       when:(PandaHookTime)hookTime
                       with:(PandaHookBlock) customImplementation;

/// hookBlock
/// @param block 要hook的blcok对象
/// @param hookTime hook时机
/// @param customImplementation  自定义实现
+ (PandaHookBlock)hookBlock:(id)block
                       when:(PandaHookTime)hookTime
                       with:(PandaHookBlock) customImplementation;

/// 获取所有hook信息，用于查找排错
+ (NSArray *)getAllHookMessage;
/// 打印对象的方法列表
+ (void)printfAllMethodList:(id)obj;
/// 打印对象的属性列表
+ (void)printfAllIvarList:(id)obj;
@end


