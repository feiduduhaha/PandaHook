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
    
    
    [PandaHook hookObj:self whichMeThod:@selector(testHookInsSel:vc:obj:) when:PandaHookTimeBefore with:^(NSArray *contextArr) {

        NSLog(@"对象方法hook执行的自定义代码");
    }];
    [PandaHook hookObj:[self class] whichMeThod:@selector(testHookInsSel:vc:obj:) when:PandaHookTimeInstead with:^(NSArray *contextArr) {

        NSLog(@"类方法hook执行的自定义代码");
    }];
    self.testBlock = ^void(NSInteger testInteger , NSString * testStr ,  id obj){
        
        NSLog(@"\n原block打印：\n%@\n%@\n%@",@(testInteger),testStr,obj);
    };
    [PandaHook hookObj:self.testBlock whichMeThod:@selector(invoke) when:PandaHookTimeInstead with:^(NSArray *contextArr) {
       
        NSLog(@"block hook执行的自定义代码");
    }];
     
}
- (IBAction)clickObjBtn:(UIButton *)sender {
    
    [self testHookInsSel:1 vc:self obj:@{@"test_key":@"test-Obj"}];
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
    
    NSLog(@"\n原对象方法打印：\n%@\n%@\n%@",@(first),vc,obj_id);
}

+ (void)testHookInsSel:(NSInteger)first vc:(UIViewController *)vc obj:(id)obj_id{
    
    NSLog(@"\n原类方法打印：\n%@\n%@\n%@",@(first),vc,obj_id);
}
@end
