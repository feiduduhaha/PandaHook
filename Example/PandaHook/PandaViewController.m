//
//  PandaViewController.m
//  PandaHook
//
//  Created by lan_mailbox@163.com on 07/02/2019.
//  Copyright (c) 2019 lan_mailbox@163.com. All rights reserved.
//

#import "PandaViewController.h"
#import <PandaHook/PandaHook.h>

typedef void(^TestBlock)(NSInteger testInteger , NSString * testStr ,  id obj);
@interface PandaViewController ()

@property (nonatomic , strong) TestBlock testBlock;
@end

@implementation PandaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [PandaHook hookObj:[UIViewController class] whichMethod:@selector(viewWillAppear:) isClassMethod:NO when:PandaHookTimeBefore with:^(NSArray *contextArr) {

        NSLog(@"-viewDidAppear: PandaHookTimeBefore");
    }];

    [PandaHook hookObj:self whichMethod:@selector(testHookInsSel:vc:obj:) isClassMethod:YES when:PandaHookTimeAfter with:^(NSArray *contextArr) {

        NSLog(@"+testHookInsSel:vc:obj: PandaHookTimeAfter");
    }];
    self.testBlock = ^void(NSInteger testInteger , NSString * testStr ,  id obj){

        NSLog(@"\n原block打印：\n%@\n%@\n%@",@(testInteger),testStr,obj);
    };
    [PandaHook hookObj:self.testBlock whichMethod:@selector(invoke) isClassMethod:YES when:PandaHookTimeInstead with:^(NSArray *contextArr) {

        NSLog(@"block hook执行的自定义代码");
    }];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSLog(@"-viewWillAppear: 原生");
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    NSLog(@"-viewDidAppear: 原生");
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}
- (IBAction)clickObjBtn:(UIButton *)sender {
    
//    [self testHookInsSel:1 vc:self obj:@{@"test_key":@"test-Obj"}];
    UIViewController * vc = [UIViewController new];
    vc.view.backgroundColor = [UIColor orangeColor];
//    [self.navigationController pushViewController:vc animated:YES];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:NO completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [vc dismissViewControllerAnimated:YES completion:nil];
    });
}
- (IBAction)clickClassBtn:(UIButton *)sender {
    
    
    [PandaViewController testHookInsSel:2 vc:self obj:@{@"test_key":@"test-Class"}];
}
- (IBAction)clickBlockBtn:(UIButton *)sender {
    
    self.testBlock(3, @"block", @{@"test_key":@"test-Block"});
}
+ (void)classMethodTest{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testHookInsSel:(NSInteger)first vc:(UIViewController *)vc obj:(id)obj_id{
    
    NSLog(@"\n-testHookInsSel:vc:obj:原生 参数：\n%@\n%@\n%@",@(first),vc,obj_id);
}

+ (void)testHookInsSel:(NSInteger)first vc:(UIViewController *)vc obj:(id)obj_id{
    
    NSLog(@"\n+testHookInsSel:vc:obj:原生 打印：\n%@\n%@\n%@",@(first),vc,obj_id);
}
@end
