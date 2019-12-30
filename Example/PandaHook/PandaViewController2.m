//
//  PandaViewController2.m
//  PandaHook_Example
//
//  Created by silence on 2019/12/30.
//  Copyright © 2019 lan_mailbox@163.com. All rights reserved.
//

#import "PandaViewController2.h"
#import "PandaViewController.h"
#import <PandaHook/PandaHook.h>
@interface PandaViewController2 ()

@property (strong)NSPointerArray * oriArr;
@property (strong) PandaHookBlock block;
@end

@implementation PandaViewController2
- (void)dealloc{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger vount = 0;
    self.block = [PandaHook hookObj:self whichMethod:@selector(test) isClassMethod:NO when:PandaHookTimeBefore with:^(NSArray *contextArr) {

        NSLog(@"PandaViewController2 hook的test方法调用");
//        NSLog(@"PandaViewController2 hook的test方法调用%@",@(vount));
    }];
    
//    self.oriArr = [NSPointerArray weakObjectsPointerArray];
//    [self.oriArr addPointer:(void *)([NSValue valueWithNonretainedObject:^void(NSArray *contextArr) {
//
//        NSLog(@"PandaViewController2 hook的test方法调用");
//    }])];

//    [self.oriArr addPointer:(void *)[NSObject new]];
//    NSInteger congu= 0;
//    PandaHookBlock block = ^void(NSArray *contextArr) {
//
//        NSLog(@"PandaViewController2 hook的test方法调用%@",@(congu));
//    };
//    [self.oriArr addPointer:(void *)block];
    
//    self.oriArr  = [NSMutableArray new];
//    [self.oriArr addObject:[NSValue valueWithNonretainedObject:^void(NSArray *contextArr) {
//
//        NSLog(@"PandaViewController2 hook的test方法调用");
//    }]];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self test];
//    NSLog(@"%@",self.oriArr.allObjects);
}
- (void)test{
   
    NSLog(@"PandaViewController2 原test方法调用");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
