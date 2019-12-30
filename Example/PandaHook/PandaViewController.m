//
//  PandaViewController.m
//  PandaHook
//
//  Created by lan_mailbox@163.com on 07/02/2019.
//  Copyright (c) 2019 lan_mailbox@163.com. All rights reserved.
//

#import "PandaViewController.h"
#import "PandaViewController2.h"
#import <PandaHook/PandaHook.h>

typedef void(^TestBlock)(NSInteger testInteger , NSString * testStr ,  id obj);
@interface PandaViewController ()
@property (nonatomic , strong) TestBlock testBlock;
@end

@implementation PandaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [PandaHook hookObj:[UIViewController class] whichMethod:@selector(viewDidAppear:) isClassMethod:NO when:PandaHookTimeBefore with:^(NSArray *contextArr) {

        NSLog(@"UIViewController页面出现的hook，执行的对象是%@",contextArr.firstObject);
    }];
    
//    [PandaHook hookObj:[PandaViewController class] whichMethod:@selector(testHookInsSel:vc:obj:) isClassMethod:YES when:PandaHookTimeAfter with:^(NSArray *contextArr) {
//
//        NSLog(@"PandaViewController类方法testHookInsSel:vc:obj:的hook");
//    }];
//    [PandaViewController testHookInsSel:2 vc:self obj:@{@"test_key":@"test-Class"}];
//    self.testBlock = ^void(NSInteger testInteger , NSString * testStr ,  id obj){
//
//        NSLog(@"\n原block打印：\n%@\n%@\n%@",@(testInteger),testStr,obj);
//    };
//    [PandaHook hookObj:self.testBlock whichMethod:@selector(invoke) isClassMethod:YES when:PandaHookTimeInstead with:^(NSArray *contextArr) {
//
//        NSLog(@"block hook执行的自定义代码");
//    }];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}
- (IBAction)clickObjBtn:(UIButton *)sender {
    
    PandaViewController2 * vc = [PandaViewController2 new];
    vc.view.backgroundColor = [UIColor orangeColor];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickClassBtn:(UIButton *)sender {
    
//    [PandaHook printfAllMethodList:[PandaViewController class]];
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

//- (void)testHookInsSel:(NSInteger)first vc:(UIViewController *)vc obj:(id)obj_id{
//
//    NSLog(@"\n-testHookInsSel:vc:obj:原生 参数：\n%@\n%@\n%@",@(first),vc,obj_id);
//}

+ (void)testHookInsSel:(NSInteger)first vc:(UIViewController *)vc obj:(id)obj_id{
    
    NSLog(@"\n+testHookInsSel:vc:obj:原生打印");
}
@end
