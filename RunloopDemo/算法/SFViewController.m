//
//  SFViewController.m
//  RunloopDemo
//
//  Created by hongbao.cui on 2018/1/9.
//  Copyright © 2018年 Founder. All rights reserved.
//

#import "SFViewController.h"
#define GENERAL_PRINT_MESSAGE(x)\
        do {    printf(#x);\
                for(int index=(*top)-1;index>=0;index--)\
                printf("%d",stack[index]);\
                printf("\n");\
            }while(0);
@interface SFViewController ()

@end

@implementation SFViewController
void printf_layer_one(int layer,int *stack,int *top) {
    GENERAL_PRINT_MESSAGE(1);
}
void printf_layer_two(int layer,int *stack,int *top) {
    GENERAL_PRINT_MESSAGE(11);
    GENERAL_PRINT_MESSAGE(2);
}
void _jump_ladder(int layer, int* stack, int* top, int decrease)
{
    stack[(*top)++] = decrease;
    jump_ladder(layer,stack,top);
    stack[--(*top)] = 0;
}
void jump_ladder(int layer, int* stack, int* top)
{
    if(layer <= 0)
        return;
    
    if(layer == 1){
        printf_layer_one(layer, stack, top);
        return;
    }
    
    if(layer == 2){
        printf_layer_two(layer, stack, top);
        return;
    }
    _jump_ladder(layer- 1, stack, top, 1);
    _jump_ladder(layer- 2, stack, top, 2);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    int top[1];
    int stack[10];
//    GENERAL_PRINT_MESSAGE(5);
    jump_ladder(10, stack, top);
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
