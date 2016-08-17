//
//  BlockViewController.m
//  RunloopDemo
//
//  Created by Founder on 16/8/16.
//  Copyright © 2016年 Founder. All rights reserved.
//

#import "BlockViewController.h"

@interface BlockViewController ()

@end

@implementation BlockViewController
//Example A
void exampleA() {
    char a = 'A';
    ^{
        printf("%c\n", a);
    }();
}
void exampleB_addBlockToArray(NSMutableArray *array) {
    char b = 'B';
    [array addObject:^{
        printf("%c\n", b);
    }];
}
//Example B
void exampleB() {
    NSMutableArray *array = [NSMutableArray array];
    exampleB_addBlockToArray(array);
    void (^block)() = [array objectAtIndex:0];
    block();
}
void exampleC_addBlockToArray(NSMutableArray *array) {
    [array addObject:^{
        printf("C\n");
    }];
}
//Example C
void exampleC() {
    NSMutableArray *array = [NSMutableArray array];
    exampleC_addBlockToArray(array);
    void (^block)() = [array objectAtIndex:0];
    block();
}
//Example D
typedef void (^dBlock)();
dBlock exampleD_getBlock() {
    char d = 'D';
    return ^{
        printf("%c\n", d);
    };
}
void exampleD() {
    exampleD_getBlock()();
}
//Example E
typedef void (^eBlock)();
eBlock exampleE_getBlock() {
    char e = 'E';
    void (^block)() = ^{
        printf("%c\n", e);
    };
    return block;
}

void exampleE() {
    eBlock block = exampleE_getBlock();
    block();
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    exampleA();
    exampleB();
    exampleC();
    exampleD();
    exampleE();
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

@end
