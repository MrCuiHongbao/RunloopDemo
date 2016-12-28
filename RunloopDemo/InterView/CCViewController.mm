//
//  CCViewController.m
//  RunloopDemo
//
//  Created by Founder on 16/12/9.
//  Copyright © 2016年 Founder. All rights reserved.
//

#import "CCViewController.h"

@interface CCViewController ()

@end

@implementation CCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    int a=3;
    int b=5;
    Reversal(a,b);
    printf("a=%d,b=%d\n",a,b);
    Reversal_1(&a,&b);
    printf("a=%d,b=%d\n",a,b);
    Reversal_2(&a,&b);
    printf("a=%d,b=%d\n",a,b);
    
    int a1 = 10;
    int b1 = 5;
    char*str_a = "hello world";
    char*str_b = "world hello";
    swap_int(a1 , b1);
    swap_str(str_a , str_b);
    printf("%d %d %s %s\n",a,b,str_a,str_b);
}
void swap_int(int a , int b)
    {
        int temp = a;
        a = b;
        b = temp;
    }
    void swap_str(char*a , char*b)
    {
        char*temp = a;
        a = b;
        b = temp;
    }
 void Reversal(int a,int b)
    {
        int t;
        t=a;
        a=b;
        b=t;
        return;
    }
    void Reversal_1(int *p,int *q)
    {
        int * t;
        t=p;
        p=q;
        q=t;
        return;
    }
    void Reversal_2(int * p,int * q)
    {
        int t;
        t=*p;
        *p=*q;
        *q=t;
        return;
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
