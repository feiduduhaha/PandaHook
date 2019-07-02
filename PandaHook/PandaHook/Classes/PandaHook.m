//
//  PandaHook.m
//  PandaHook
//
//  Created by silence on 2019/7/2.
//

#import "PandaHook.h"

@interface PandaHook ()

@property (nonatomic , strong) NSMutableDictionary * hookRecordDic;

@end

@implementation PandaHook

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
           with:(void(^)(NSDictionary * contextDic))customImplementation
{
    
    
    
}

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
             with:(void(^)(NSDictionary * contextDic))customImplementation
{
    
    
}
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
             with:(void(^)(NSDictionary * contextDic))customImplementation
{
    
    
}

+ (void)recoverCodeWith:(id)target method:(SEL)method{
    
    
    
}
@end
