//
//  PandaAppDelegate.m
//  PandaHook
//
//  Created by lan_mailbox@163.com on 07/02/2019.
//  Copyright (c) 2019 lan_mailbox@163.com. All rights reserved.
//

#import "PandaAppDelegate.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <PandaHook/PandaHook.h>
@implementation PandaAppDelegate
{
    PandaHookBlock _hookBlock;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{


//    Method oriMethod = class_getInstanceMethod([self class], @selector(targetSel));
//    Method newMethod = class_getInstanceMethod([self class], @selector(hook_targetSel));
//    method_exchangeImplementations(oriMethod, newMethod);
//    method_setImplementation(oriMethod, method_getImplementation(newMethod));
    
//    _hookBlock = [PandaHook hookClass:[PandaAppDelegate class] whichMethod:@selector(targetSel) isClassMethod:NO when:PandaHookTimeAfter with:^(NSArray *contextArr) {
//
//
//    }];
//    [self targetSel];
//    NSMethodSignature * sign = [NSMethodSignature signatureWithObjCTypes:"v@:"];
//    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sign];
//    invocation.target = self;
//    invocation.selector = NSSelectorFromString(@"hook_targetSel");
//    [invocation invoke];
    return YES;
}

//- (id)forwardingTargetForSelector:(SEL)aSelector{
//
//    NSLog(@"%@-%@",self,NSStringFromSelector(aSelector));
//    return nil;
//}
//
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
//
//    NSLog(@"%@-%@",self,NSStringFromSelector(aSelector));
//    NSMethodSignature * sign = [NSMethodSignature signatureWithObjCTypes:"v@:"];
//    return sign;
//}
//
//- (void)forwardInvocation:(NSInvocation *)anInvocation{
//
//    NSLog(@"%@-%@",self,NSStringFromSelector(anInvocation.selector));
//    anInvocation.selector = NSSelectorFromString(@"targetSel");
//    [anInvocation invoke];
//}

//- (void)targetSel{
//
//    NSLog(@"%@-%@",self,NSStringFromSelector(_cmd));
//}

//- (void)hook_targetSel{
//
//    [self targetSel];
//    NSLog(@"%@-%@",self,NSStringFromSelector(_cmd));
//}
@end
