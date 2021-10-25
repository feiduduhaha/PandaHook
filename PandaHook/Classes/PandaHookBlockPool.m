//
//  PandaHookBlockPool.m
//  PandaHook
//
//  Created by silence on 2019/10/16.
//

#import "PandaHookBlockPool.h"

@implementation PandaHookBlockPool

- (instancetype)init{
    self = [super init];
    
    self.beforeDic = [NSMutableDictionary new];
    self.insteadDic = [NSMutableDictionary new];
    self.afterDic = [NSMutableDictionary new];
    self.recordArr = @[self.beforeDic,self.insteadDic,self.afterDic];
    return self;
}

- (BOOL)didHookedWithIdentify:(NSString *)identify{
    
    return self.beforeDic[identify] || self.insteadDic[identify] || self.afterDic[identify];
}

- (void)addNewBlcokWithIdentify:(NSString *)identify andCallTime:(PandaHookTime)calltime block:(id)block{
    
    NSMutableDictionary * handleDic = [self getHandleDicWithCallTime:calltime];
    NSPointerArray * oriArr = handleDic[identify];
    
    if (!oriArr) {
        oriArr = [NSPointerArray weakObjectsPointerArray];
    }
    if (![oriArr.allObjects containsObject:block]) {
        
        [oriArr addPointer:(void *)block];
    }
    [oriArr compact];
    
    [handleDic setObject:oriArr forKey:identify];
}

- (void)removeBlcokWithIdentify:(NSString *)identify andCallTime:(PandaHookTime)calltime{
    
    [[self getHandleDicWithCallTime:calltime] removeObjectForKey:identify];
}

- (NSArray*)getBlocksWithIdentify:(NSString *)identify callTime:(PandaHookTime)calltime{
    
    NSPointerArray * handleArr = [self getHandleDicWithCallTime:calltime][identify];
    [handleArr compact];
    return handleArr.allObjects ?:[NSArray new];
}

- (void)releaseBlock:(id)block with:(PandaHookTime)hookTime{
    
    NSMutableDictionary * handleDic = [self getHandleDicWithCallTime:hookTime];
    
    for (NSPointerArray *arr in handleDic.allValues) {
        
        int i = -1;
        for (id obj in arr) {
            i++;
            if ([obj isEqual:block]) break;
        }
        if (i > -1) {
            
            [arr removePointerAtIndex:i];
            return;
        }
    }
    
}

- (NSMutableDictionary *)getHandleDicWithCallTime:(PandaHookTime)calltime{
    
    if (calltime == PandaHookTimeBefore) {
        
        return self.beforeDic;
    } else if (calltime == PandaHookTimeInstead){
        
        return self.insteadDic;
    }else{
        
        return self.afterDic;
    }
}

@end
