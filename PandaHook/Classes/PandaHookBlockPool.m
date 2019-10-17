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

- (NSString *)addNewBlcokWithIdentify:(NSString *)identify block:(id)block callTime:(PandaHookTime)calltime{
    
    @try {
        
        NSMutableDictionary * newDic = self.recordArr[calltime][identify]?:[NSMutableDictionary new];
        NSString * blockIdentify = @([NSDate date].timeIntervalSince1970).stringValue;
        [newDic setObject:block forKey:blockIdentify];
        [self.recordArr[calltime] setObject:newDic forKey:identify];
        return [NSString stringWithFormat:@"%@#%@",identify,blockIdentify];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
    }
}

- (NSArray *)getBlocksWithIdentify:(NSString *)identify callTime:(PandaHookTime)calltime{
    
    @try {
        NSMutableDictionary * recordDic = self.recordArr[calltime][identify];
        return recordDic.allValues;
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
    }
}
- (void)removeBlcokWithIdentify:(NSString *)identify callTime:(PandaHookTime)calltime{
    
    @try {
        NSArray<NSString *> *arr = [identify componentsSeparatedByString:@"#"];
        NSMutableDictionary * recordDic = self.recordArr[calltime][arr.firstObject];
        [recordDic removeObjectForKey:arr.lastObject];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
    }
}

- (BOOL)didHookedWithIdentify:(NSString *)identify{
    
    NSInteger count = 0;
    @try {
        for (NSDictionary <NSString *,NSDictionary *> * recordDic in self.recordArr) {
            
            count += recordDic[identify].allValues.count;
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
    }
    return count;
}
@end
