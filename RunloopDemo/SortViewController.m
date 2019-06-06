//
//  SortViewController.m
//  RunloopDemo
//
//  Created by hongbao.cui on 16/3/24.
//  Copyright © 2016年 Founder. All rights reserved.
//

#import "SortViewController.h"

@interface SortViewController ()

@end

@implementation SortViewController
/******************************
 插入排序分为：直接插入排序和希尔排序
 ******************************/
//直接插入排序.每步将一个待排序的记录按其关键字的大小插到前面已经排序的序列中的适当位置，直到全部记录插入完毕为止。
-(void)initDirectChaSort:(NSMutableArray *)array{
    NSInteger j=0;
    for (NSInteger i=0; i<[array count]-1; i++) {
        if ([[array objectAtIndex:i] integerValue]>[[array objectAtIndex:i+1] integerValue]) {
            NSNumber *temp = [array objectAtIndex:i+1];
            for (j=i+1; j>0&&([[array objectAtIndex:j-1] integerValue]>[temp integerValue]); j--) {
                [array exchangeObjectAtIndex:j-1 withObjectAtIndex:j];
            }
        }
    }
    for (NSInteger i=0; i<array.count; i++) {
        NSLog(@"直接插入排序排序后的顺序为:%@",[array objectAtIndex:i]);
    }
}
/******************************
 选择排序分为：简单选择排序和堆排序
 ******************************/
//简单选择排序 n^2
-(void)initSelectedSort:(NSArray *)arry{
    //选择数组中最小的数与待排序中的第一个数交换
    NSMutableArray *array = [arry mutableCopy];
    for (NSInteger i=0; i<array.count; i++) {
        NSInteger j=0;
        while (j<array.count) {
            if ([[array objectAtIndex:i] integerValue]<[[array objectAtIndex:j] integerValue]) {
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
            j++;
        }
    }
    for (NSInteger i=0; i<array.count; i++) {
        NSLog(@"选择排序后的顺序为:%@",[array objectAtIndex:i]);
    }
}
/******************************
 交换排序分为：冒泡排序和快速排序
 ******************************/
//冒泡排序  时间复杂度：n^2（n的平方）
-(void)initBubbleSort:(NSArray *)arry{
    //相邻的两个数做比较，如果后面的比前面的一个数小，交换位置
    NSMutableArray *array = [arry mutableCopy];
    for (NSInteger i=0; i<array.count; i++) {
        for (NSInteger j=0;(j+1)<array.count&&j<(array.count-i); j++) {
            if ([array[j] integerValue]>[array[j+1] integerValue]) {
                [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
    for (NSInteger i=0; i<array.count; i++) {
        NSLog(@"冒泡排序后的顺序为:%@",[array objectAtIndex:i]);
    }
}
//设要排序的数组是A[0]……A[N-1]，首先任意选取一个数据（通常选用数组的第一个数）作为关键数据，然后将所有比它小的数都放到它前面，所有比它大的数都放到它后面，这个过程称为一趟快速排序。值得注意的是，快速排序不是一种稳定的排序算法，也就是说，多个相同的值的相对位置也许会在算法结束时产生变动。
//一趟快速排序的算法是：
//1）设置两个变量i、j，排序开始的时候：i=0，j=N-1；
//2）以第一个数组元素作为关键数据，赋值给key，即key=A[0]；
//3）从j开始向前搜索，即由后开始向前搜索(j--)，找到第一个小于key的值A[j]，将A[j]和A[i]互换；
//4）从i开始向后搜索，即由前开始向后搜索(i++)，找到第一个大于key的A[i]，将A[i]和A[j]互换；
//5）重复第3、4步，直到i=j； (3,4步中，没找到符合条件的值，即3中A[j]不小于key,4中A[i]不大于key的时候改变j、i的值，使得j=j-1，i=i+1，直至找到为止。找到符合条件的值，进行交换的时候i， j指针位置不变。另外，i==j这一过程一定正好是i+或j-完成的时候，此时令循环结束）。快速排序时间复杂度下界为O(nlogn)，最坏情况为O(n^2)
-(void)quicksort:(NSMutableArray *)array Left:(NSInteger)left Right:(NSInteger)right{
    if (left>right) {
        return;
    }
    NSInteger i=left,j = right;
    NSInteger key = [array[left] integerValue];
    while (i<j) {
        while((i<j)&&([array[j] integerValue] >= key)) {
            j--;
        }
        [array exchangeObjectAtIndex:i withObjectAtIndex:j];//找到第一个小于key的值A[j]，将A[j]和A[i]互换；
        
        while((i<j)&&([array[i] integerValue]<=key)) {
            i++;
        }
        [array exchangeObjectAtIndex:j withObjectAtIndex:i];
    }
//    [array replaceObjectAtIndex:i withObject:array[i]];
    [self quicksort:array Left:left Right:i-1];
    [self quicksort:array Left:i+1 Right:right];
}
//快速排序
-(void)initQuicklySort:(NSArray *)arry{
    NSMutableArray *dataArray = [arry mutableCopy];
    [self quicksort:dataArray Left:0 Right:dataArray.count-1];
    for (NSInteger i=0; i<dataArray.count; i++) {
        NSLog(@"快速排序后的顺序为:%@",[dataArray objectAtIndex:i]);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *array = @[@4,@20,@30,@1,@3,@8,@9];
    [self initBubbleSort:array];//冒泡排序
    [self initSelectedSort:array];//选择排序
    [self initQuicklySort:array];//快速排序
    [self initDirectChaSort:[array mutableCopy]];//直接插入排序
    [self pairSortList];//双向链表排序
}
typedef struct DuLNode {
    int  data;
    struct DuLNode *next;//*prior,
}DuLNode, *DuLinkList;

struct DuLNode *creatList(int *array,int length) {
//    L = (DuLinkList)malloc(sizeof(DuLNode));
//    if (L) {
//        L->next =L;
//    } else {
//        exit(OVERFLOW);
//    }
    int count = 0;
    DuLNode *pEnd = (DuLNode *)malloc(sizeof(DuLNode));
    DuLNode *head = (DuLNode *)malloc(sizeof(DuLNode));
    while (count<length) {
        
        DuLNode *pNew;
        pNew = (DuLNode *)malloc(sizeof(DuLNode));
        int data = array[count];
        if (length == 1) {
            head = pNew;
            pEnd = pNew;
        } else {
            pNew->data = data;
            if (count ==0) {
                head->next = pNew;
            }
            pEnd->next =pNew;
            pEnd = pNew;
        }
        count++;
    }
    return head;
}
void printList (DuLNode *currentNode,int length) {
    for (int i=0; i<length; i++) {
        printf("当前链表为：%d",currentNode->data);
    }
}
//-(UIImage *) reSizeImage:(UIImage *)image toSize:(CGSize)reSize {
//    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
//    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
//    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return reSizeImage;
//}
- (void)pairSortList {
    int a[] = {4,5,3,6,2,8,4,23};
    int l = sizeof(a)/4;
    DuLNode  *node =  creatList(a,l);
    DuLNode  *currentNode=NULL;
    for (int i=0; i<l; i++) {
        currentNode = node->next;
      printf("pair list  is %d\n",currentNode->data);
        node = currentNode;
    }

    char ch[14] = {'a','b','c','a','b','e','f','d','f','h'};
    initlengthOfLongestSubstring(ch);

}
void initlengthOfLongestSubstring(char ch[14]) {

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
