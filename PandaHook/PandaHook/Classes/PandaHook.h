//
//  PandaHook.h
//  PandaHook
//
//  Created by silence on 2019/7/2.
//

#import <Foundation/Foundation.h>

//执行自定义代码的时机
typedef NS_ENUM(NSUInteger, PandaHookTime) {
    PandaHookTimeBefore,//在被hook代码执行前执行
    PandaHookTimeReplace,//替换被hook代码
    PandaHookTimeAfter,//在被hook代码执行前后行
};

/**
 hook管理类
 */
@interface PandaHook : NSObject

/**
 hook对象的方法
 
 @param targetObj 目标对象
 @param method 要hook的方法
 @param hookTime hook时机
 @param customImplementation 自定义实现
 */
+ (void)hookObj:(id)targetObj
    whichMeThod:(SEL)method
           when:(PandaHookTime)hookTime
           with:(void(^)(NSDictionary * contextDic))customImplementation;

/**
 hook类的方法
 
 @param targetClass 目标类
 @param method 要hook的方法
 @param hookTime hook时机
 @param customImplementation 自定义实现
 */
+ (void)hookClass:(id)targetClass
      whichMeThod:(SEL)method
             when:(PandaHookTime)hookTime
             with:(void(^)(NSDictionary * contextDic))customImplementation;
/**
 hook block方法
 
 @param targetBlock 目标block对象
 @param method 要hook的方法
 @param hookTime hook时机
 @param customImplementation 自定义实现
 */
+ (void)hookBlock:(id)targetBlock
      whichMeThod:(SEL)method
             when:(PandaHookTime)hookTime
             with:(void(^)(NSDictionary * contextDic))customImplementation;


/**
 取消hook，恢复到hook之前的代码

 @param target 恢复的目标
 @param method 恢复的方法
 */
+ (void)recoverCodeWith:(id)target method:(SEL)method;


@end


