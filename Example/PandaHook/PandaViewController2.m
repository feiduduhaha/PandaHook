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

@end

@implementation PandaViewController2
- (void)dealloc{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [PandaHook hookObj:self whichMethod:@selector(test) isClassMethod:NO when:PandaHookTimeBefore with:^(NSArray *contextArr) {

        NSLog(@"PandaViewController2 hook的test方法调用");
    }];
}
- (void)viewDidAppear:(BOOL)animated{
 
    [self test];
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
