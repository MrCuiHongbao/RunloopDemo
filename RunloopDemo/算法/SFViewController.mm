//
//  SFViewController.m
//  RunloopDemo
//
//  Created by hongbao.cui on 2018/1/9.
//  Copyright © 2018年 Founder. All rights reserved.
//

#import "SFViewController.h"
#include <stdio.h>
#include <string>

#define GENERAL_PRINT_MESSAGE(x)\
        do {    printf(#x);\
                for(int index=(*top)-1;index>=0;index--)\
                printf("%d",stack[index]);\
                printf("\n");\
            }while(0);

#define max(a,b) (((a) > (b)) ? (a) : (b))
#define min(a,b) (((a) < (b)) ? (a) : (b))
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
//求两数的最大公约数
int getMaxGY (int a ,int b){
    int temp;
    if(a<b){
        temp = a;
        a = b;
        b = temp;
    }
    while (b!=0) {
        temp = a%b;
        a = b;
        b = temp;
    }
    return a;
}
//冒泡:比较相邻元素
int * sortBubble(int arry[10], int size){
    for (int i=0; i<size; i++) {
        int temp;
        for (int j=0; j<size+1-i; j++) {
            if (arry[j]<arry[j+1]) {
                temp = arry[j];
                arry[j] = arry[j+1];
                arry[j+1] = temp;
            }
            
        }
    }
    return arry;
}
//选择
int *sortChoose(int arry[10], int size){
    for (int i=0; i<size; i++) {
        int temp;
        for (int j=i+1; j<size+1; j++) {
            if (arry[i]<arry[j]) {
                temp = arry[i];
                arry[i] = arry[j];
                arry[j] = temp;
            }
            
        }
    }
    return arry;
}
char chooseFirst() {
    //字符串 abcdcdbb 返回第一个不重复的a的index
    char *a = "bcdcadbbefg";
    int m[256];
//    int len =sizeof(a);
    for (int i=0; i<256; i++) {
        m[i]=0;
    }
    // 定义一个指针 指向当前字符串头部
    char* p = a;
    // 遍历每个字符
    while (*p != '\0') {
        // 在字母对应存储位置 进行出现次数+1操作
        m[*(p++)]++;
    }
//    char *p = a;
//    int ch;
//    for (int i=0; i<strlen(a); i++) {
//        ch = *(p+i);
//        m[ch]++;
//    }
    int index=0;
    for (int i=0; i<256; i++) {
        if (m[i]!=0) {
            index = i;
            break;
        }
    }
    return (char)index;
}
- (void)ladder {
    int top[1];
    int stack[10];
    //    GENERAL_PRINT_MESSAGE(5);
    jump_ladder(10, stack, top);
    int max_gys = getMaxGY(15, 20);
    NSLog(@"max_gys->%d",max_gys);
    int r[10] = {12,2,5,8,6,7,3,5,4,1};
    for (int i=0; i<10; i++) {
        printf("r[%d]=%d----length---->:%lu\n",i,r[i],sizeof(r)/sizeof(int));
    }
    int size = sizeof(r)/sizeof(int);
    int *a = sortBubble(r,size);//冒泡排序
    //    int *a = sortChoose(r,size);//选择排序
    for (int i=0; i<10; i++) {
        printf("r[%d]=%d\n",i,a[i]);
    }
    char b = chooseFirst();
    printf("chooseFirst------index------>%c\n",b);
}
//选择
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self ladder];
    std::string s = "abcdabcabcdefg";
    int max = lengthOfLongestSubstring(s);
    printf("no repeat max string is:%d",max);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//算法
/*
 滑动窗口
  如果s[i]在[left, i) 范围内有重复的字符(假定前一个字符位置为k)， 我们可以直接跳过 [left, k] 范围内的所有元素，并让left = k+1
 1.因为ASII码，所以我们利用一个128位的数组，数组项的下标为字母，数组项的值为这个字母所在的位置k,然后+1，
 */
int lengthOfLongestSubstring(std::string s) {
    
    int index[128] = { 0 }; // 字符有128个
    int left = 0; // 查找的左边界
    int ret = 0; // 结果
    for (int i = 0; i < s.length(); i++)
    {
        if (index[s[i]] == 0                // 代表该字符s[i]从未出现过
            || index[s[i]] < left            // 代表字符s[i]上一次出现的位置不在当前的查找范围
            )
        {
            ret = max(ret, i - left + 1);   // left->i 的大小为当前未重复字符串的大小,求max即答案
        }
        else
        {
            left = index[s[i]];                // index[s[i]]当前的大小代表字符s[i]再次出现时应该查找的起始位置，对应left的值
        }
        
        index[s[i]] = i + 1;
    }
    return ret;
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
