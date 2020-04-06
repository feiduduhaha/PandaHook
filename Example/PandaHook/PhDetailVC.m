//
//  PhObjectVC.m
//  PandaHook_Example
//
//  Created by silence on 2020/4/6.
//  Copyright © 2020 lan_mailbox@163.com. All rights reserved.
//

#import "PhDetailVC.h"

@interface PhDetailVC ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *hookTimeSeg;

@end

@implementation PhDetailVC

- (void)dealloc{
    
    NSLog(@"PhDetailVC释放 ，hookBlock由VC持有，当PhDetailVC释放，PhDetailVC实例所持有的hook代码不会再调用");
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setHookType:(NSInteger)hookType{
    
    _hookType = hookType;
    
    
}

- (IBAction)selectHookTimeSeg:(UISegmentedControl *)sender {

    __weak PhDetailVC * weakSelf = self;
    self.hookBlock = [PandaHook hookClass:[self class]
                              whichMethod:self.hookType?@selector(addViewToWindowWithBGclolr:with:andTitle:):@selector(addViewToWindowWithBGclolr:andTitle:)
                            isClassMethod:self.hookType
                                     when:sender.selectedSegmentIndex//index刚好对应 PandaHookTime 枚举中的定义值
                                     with:^(NSArray *contextArr) {
       
        __strong PhDetailVC * strSelf = weakSelf;
        [PhDetailVC customCode:strSelf andTitle:@"这是hook方法添加的按钮"];
        NSLog(@"执行hook代码，向window上添加一个黑色按钮");
    }];
}


- (IBAction)clickCallOriAPI_Btn:(UIButton *)sender {
    
    if (!self.hookBlock) {
        
        [self selectHookTimeSeg:self.hookTimeSeg];
    }
    if (self.hookType) {
        
        [PhDetailVC addViewToWindowWithBGclolr:[UIColor redColor] with:self andTitle:@"这是原方法添加的按钮"];
    } else {
        
        [self addViewToWindowWithBGclolr:[UIColor redColor] andTitle:@"这是原方法添加的按钮"];
    }
    NSLog(@"执行原生方法，向window上添加一个红色按钮");
}

+ (void)customCode:(UIViewController *)vc andTitle:(NSString *)title{
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIButton * btn = [[UIButton alloc] initWithFrame:window.bounds];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:vc action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor blackColor];
    btn.alpha = 0.8;
    [window addSubview:btn];
}




- (UIView *)addViewToWindowWithBGclolr:(UIColor *)color andTitle:(NSString *)title{
    
    UIButton * btn = [[UIButton alloc] initWithFrame:self.view.window.bounds];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget: self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = color;
    btn.alpha = 0.8;
    [self.view.window addSubview:btn];
    return btn;
}

+ (UIView *)addViewToWindowWithBGclolr:(UIColor *)color with:(UIViewController *)vc andTitle:(NSString *)title{
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIButton * btn = [[UIButton alloc] initWithFrame:window.bounds];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:vc action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = color;
    btn.alpha = 0.8;
    [window addSubview:btn];
    return btn;
}

- (void)clickBtn:(UIButton *)sender{
    
    [sender removeFromSuperview];
}

@end
