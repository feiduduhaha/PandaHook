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

- (NSString *)addNewBlcokWithClass:(NSString *)className
                           selName:(NSString *)selName
                             block:(id)block
                          callTime:(PandaHookTime)calltime
{
    
    @try {
        
        NSMutableDictionary * selDic = self.recordArr[calltime][selName]?:[NSMutableDictionary new];
        NSMutableDictionary * classDic = selDic[className]?:[NSMutableDictionary new];
        NSString * blockIdentify = @([NSDate date].timeIntervalSince1970).stringValue;
        [classDic setObject:block forKey:blockIdentify];
        [selDic setObject:classDic forKey:className];
        [self.recordArr[calltime] setObject:selDic forKey:selName];
        
        return [NSString stringWithFormat:@"%@|%@|%@",className,selName,blockIdentify];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
    }
}

- (NSArray *)getBlocksWithIdentify:(NSString *)identify callTime:(PandaHookTime)calltime{
    
    @try {
        
        NSArray <NSString *>* identifyArr = [identify componentsSeparatedByString:@"|"];
        NSString * selName = identifyArr.lastObject;
        NSString * className = identifyArr.firstObject;
        NSMutableDictionary * selDic = self.recordArr[calltime][selName];
        NSMutableDictionary * recordDic = self.recordArr[calltime][selName][className];
        if (!recordDic.count) {
            
            for (NSString * classKey in selDic) {
                
                recordDic = self.recordArr[calltime][selName][classKey];
                if ([NSClassFromString(className) isSubclassOfClass:NSClassFromString(classKey)] && recordDic.count) {
                    
                    return recordDic.allValues;
                }
            }
        }
        return recordDic.allValues;
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
    }
}
- (void)removeBlcokWithIdentify:(NSString *)identify callTime:(PandaHookTime)calltime{
    
    @try {
        
        NSMutableArray<NSString *> *identifyArr = [identify componentsSeparatedByString:@"|"].copy;
        [identifyArr removeObject:@""];
        NSString * selName = identifyArr.lastObject;
        NSString * className = identifyArr[1];
        NSString * blockIdentify = identifyArr.firstObject;
        NSMutableDictionary * recordDic = self.recordArr[calltime][selName][className];
        [recordDic removeObjectForKey:blockIdentify];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
    }
}

- (BOOL)didHookedWithClass:(NSString *)className
                   selName:(NSString *)selName
                  callTime:(PandaHookTime)calltime
{
    
    @try {
        NSMutableDictionary * recordDic = self.recordArr[calltime][selName][className];
        return recordDic.count;
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
    }
}
@end
