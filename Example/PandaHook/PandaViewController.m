//
//  PandaViewController.m
//  PandaHook
//
//  Created by lan_mailbox@163.com on 07/02/2019.
//  Copyright (c) 2019 lan_mailbox@163.com. All rights reserved.
//

#import "PandaViewController.h"
#import "PhDetailVC.h"

@interface PandaViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray <NSString *>* dataArr;
@end

@implementation PandaViewController

- (void)viewDidLoad{
    [super viewDidLoad];

    self.title = @"PandaHook API详解";
    [self configTable];
}

- (void)configTable{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.tableView.tableFooterView = [UIView new];
    
    self.dataArr = [NSMutableArray new];
    [self.dataArr addObjectsFromArray:@[@"对象方法的hook",@"类方法的hook"]];//,@"block对象的hook"
}

- (void)viewDidAppear:(BOOL)animated{
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        //用来测试PhDetailVC实例释放后，是否还调用其所持有的block
//        [PhDetailVC addViewToWindowWithBGclolr:[UIColor blackColor] with:self andTitle:@"这是在PandaViewController页面添加的按钮"];
//    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PhDetailVC *vc = [PhDetailVC new];
    vc.title = self.dataArr[indexPath.row];
    vc.hookType = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (void)clickBtn:(UIButton *)sender{
    
    [sender removeFromSuperview];
}
@end
