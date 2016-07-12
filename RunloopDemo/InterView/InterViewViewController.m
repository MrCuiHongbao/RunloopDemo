//
//  InterViewViewController.m
//  RunloopDemo
//
//  Created by Founder on 16/7/12.
//  Copyright © 2016年 Founder. All rights reserved.
//

#import "InterViewViewController.h"

@interface InterViewViewController ()
@property(nonatomic,strong)NSMutableArray *dataList;
@end

@implementation InterViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataList = [NSMutableArray arrayWithObjects:@"CUI", nil];
//    14.在block里面, 对数组执行添加操作, 这个数组需要声明成 __block吗
//    15.在block里面, 对NSInteger进行修改, 这个NSInteger是否需要声明成__blcok
    __weak InterViewViewController *weakSelf = self;
    __block NSInteger i=0;//不用block会失败
    self.testBlock = ^(){
        [weakSelf.dataList addObject:@"Hong"];
        NSLog(@"dataList:------>:%@",weakSelf.dataList);
        i=7;
        NSLog(@"dataList:------>:%@",weakSelf.dataList);
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)btnClicked:(id)sender{
    if (self.testBlock) {
        self.testBlock();
    }
}
@end
