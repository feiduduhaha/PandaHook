//
//  PhObjectVC.h
//  PandaHook_Example
//
//  Created by silence on 2020/4/6.
//  Copyright © 2020 lan_mailbox@163.com. All rights reserved.
//

@import UIKit;
#import <PandaHook/PandaHook.h>
@interface PhDetailVC : UIViewController

@property (assign , nonatomic) NSInteger hookType;
@property (strong, nonatomic)PandaHookBlock hookBlock;

- (UIView *)addViewToWindowWithBGclolr:(UIColor *)color andTitle:(NSString *)title;
+ (UIView *)addViewToWindowWithBGclolr:(UIColor *)color with:(UIViewController *)vc andTitle:(NSString *)title;

@end
