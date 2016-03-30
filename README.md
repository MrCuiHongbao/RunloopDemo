# RunloopDemo
1.RunLoop
  是一个循环，程序能够运行就是因为在一个主runLoop中运行。伪代码如下：
  function loop() {
    initialize();
    do {
        var message = get_next_message();
        process_message(message);
    } while (message != quit);
}
2.与线程和线程池有关
一般程序就是执行一个线程，是一条直线.有起点终点.而runloop就是一直在线程上面画圆圈，一直在跑圈，除非切断否则一直在运行。
网上说的比喻很好，直线就像昙花一现一样，圆就像OS,一直运行直到你关机为止。

Runloop的寄生于线程：一个线程只能有唯一对应的runloop；但这个根runloop里可以嵌套子runloops；
自动释放池寄生于Runloop：程序启动后，主线程注册了两个Observer监听runloop的进出与睡觉。
一个最高优先级OB监测Entry状态；一个最低优先级OB监听BeforeWaiting状态和Exit状态。
线程(创建)-->runloop将进入-->最高优先级OB创建释放池-->runloop将睡-->最低优先级OB销毁旧池创建新池-->runloop将退出-->
最低优先级OB销毁新池-->线程(销毁)
3.事例如Demo

参考文档:http://www.cocoachina.com/ios/20150601/11970.html
         http://www.jianshu.com/p/613916eea37f
         https://developer.apple.com/library/mac/documentation/CoreFoundation/Reference/CFRunLoopRef/
排序算法（OC）
1.冒泡排序
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
//简单选择排序
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
//冒泡排序
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
//5）重复第3、4步，直到i=j； (3,4步中，没找到符合条件的值，即3中A[j]不小于key,4中A[i]不大于key的时候改变j、i的值，使得j=j-1，i=i+1，直至找到为止。找到符合条件的值，进行交换的时候i， j指针位置不变。另外，i==j这一过程一定正好是i+或j-完成的时候，此时令循环结束）。
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
//快速排序
//一趟快速排序的算法是：
//1）设置两个变量i、j，排序开始的时候：i=0，j=N-1；
//2）以第一个数组元素作为关键数据，赋值给key，即key=A[0]；
//3）从j开始向前搜索，即由后开始向前搜索(j--)，找到第一个小于key的值A[j]，将A[j]和A[i]互换；
//4）从i开始向后搜索，即由前开始向后搜索(i++)，找到第一个大于key的A[i]，将A[i]和A[j]互换；
//5）重复第3、4步，直到i=j； (3,4步中，没找到符合条件的值，即3中A[j]不小于key,4中A[i]不大于key的时候改变j、i的值，
//使得j=j-1，i=i+1，直至找到为止。找到符合条件的值，进行交换的时候i， j指针位置不变。另外，i==j这一过程一定正好是i+或j-完成的时候，
//此时令循环结束）。
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
}
