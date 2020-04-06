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
    
    NSPointerArray * oriArr = [NSPointerArray weakObjectsPointerArray];
    BOOL shouldAdd = YES;
    for (id obj in [self getBlocksWithIdentify:identify callTime:calltime]) {
        
        [oriArr addPointer:(void *)obj];
        if ([obj isEqual:block]) shouldAdd = NO;
    }
    if (shouldAdd) {
        
        [oriArr addPointer:(void *)block];
    }
    [oriArr compact];
    if (calltime == PandaHookTimeBefore) {
        
        [self.beforeDic setObject:oriArr forKey:identify];
    } else if (calltime == PandaHookTimeInstead){
        
        [self.insteadDic setObject:oriArr forKey:identify];
    }else{
        
        [self.afterDic setObject:oriArr forKey:identify];
    }
    
}
- (void)removeBlcokWithIdentify:(NSString *)identify andCallTime:(PandaHookTime)calltime{
    
    if (calltime == PandaHookTimeBefore) {
        
        [self.beforeDic removeObjectForKey:identify];
    } else if (calltime == PandaHookTimeInstead){
        
        [self.insteadDic removeObjectForKey:identify];
    }else{
        
        [self.afterDic removeObjectForKey:identify];
    }
}

- (NSArray*)getBlocksWithIdentify:(NSString *)identify callTime:(PandaHookTime)calltime{
    
    if (calltime == PandaHookTimeBefore) {
        
        return self.beforeDic[identify].allObjects ?:[NSArray new];
    } else if (calltime == PandaHookTimeInstead){
        
        return self.insteadDic[identify].allObjects ?:[NSArray new];
    }else{
        
        return self.afterDic[identify].allObjects ?:[NSArray new];
    }
}

@end
