//
//  PandaHookBlockPool.h
//  PandaHook
//
//  Created by silence on 2019/10/16.
//

#import <Foundation/Foundation.h>
//执行自定义代码的时机
typedef NS_ENUM(NSUInteger, PandaHookTime) {
    PandaHookTimeBefore,//在被hook代码执行前执行
    PandaHookTimeInstead,//替换被hook代码
    PandaHookTimeAfter,//在被hook代码执行前后行
};
NS_ASSUME_NONNULL_BEGIN

@interface PandaHookBlockPool : NSObject

@property (nonatomic , strong) NSMutableDictionary<NSString * , NSPointerArray * > * beforeDic;
@property (nonatomic , strong) NSMutableDictionary<NSString * , NSPointerArray * > * insteadDic;
@property (nonatomic , strong) NSMutableDictionary<NSString * , NSPointerArray * > * afterDic;
@property (nonatomic , strong) NSArray<NSMutableDictionary *> * recordArr;

- (BOOL)didHookedWithIdentify:(NSString *)identify;
- (void)addNewBlcokWithIdentify:(NSString *)identify andCallTime:(PandaHookTime)calltime block:(id)block;
- (void)removeBlcokWithIdentify:(NSString *)identify andCallTime:(PandaHookTime)calltime;
- (NSArray*)getBlocksWithIdentify:(NSString *)identify callTime:(PandaHookTime)calltime;

@end

NS_ASSUME_NONNULL_END
