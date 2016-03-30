//
//  GCDViewController.m
//  RunloopDemo
//
//  Created by hongbao.cui on 16/1/18.
//  Copyright © 2016年 Founder. All rights reserved.
//https://github.com/ming1016/study/wiki/细说GCD（Grand-Central-Dispatch）如何用

#import "GCDViewController.h"

@interface GCDViewController ()

@end

@implementation GCDViewController
#pragma mark- GCD
-(void)initGCD{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//       NSLog(@"Done doing something long and involved");
//        dispatch_async(dispatch_get_main_queue(), ^{//更新UI
//            
//        });
//    });
    
//    dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);//DISPATCH_QUEUE_CONCURRENT:并行队列  DISPATCH_QUEUE_SERIAL:串行队列
//    dispatch_async(concurrentQueue, ^(){
//        NSLog(@"dispatch-1");
//    });
//    dispatch_async(concurrentQueue, ^(){
//        NSLog(@"dispatch-2");
//    });
//    dispatch_barrier_async(concurrentQueue, ^(){//队列的屏障
//        NSLog(@"dispatch-barrier");
//    });
//    dispatch_async(concurrentQueue, ^(){
//        for (NSInteger i=0; i<5; i++) {
//            NSLog(@"dispatch-dispatch_async  for  and ");
//        }
//        NSLog(@"dispatch-3");
//    });
//    dispatch_async(concurrentQueue, ^(){
//        NSLog(@"dispatch-4");
//    });
    
    //队列组
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.gcd-group.www", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 10; i++) {
//            if (i == 9) {
                NSLog(@"11111111");
//            }
        }
        
    });
    dispatch_group_leave(group);
    dispatch_group_async(group, queue, ^{
        NSLog(@"22222222");
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"33333333");
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"done");
    });
    /*
     信号量是一个整形值并且具有一个初始计数值，并且支持两个操作：信号通知和等待。当一个信号量被信号通知，其计数会被增加。当一个线程在一个信号量上等待时，线程会被阻塞（如果有必要的话），直至计数器大于零，然后线程会减少这个计数。
     　　在GCD中有三个函数是semaphore的操作，分别是：
     　　dispatch_semaphore_create　　　创建一个semaphore
     　　dispatch_semaphore_signal　　　发送一个信号
     　　dispatch_semaphore_wait　　　　等待信号
     简单的介绍一下这一段代码，创建了一个初使值为10的semaphore，每一次for循环都会创建一个新的线程，线程结束的时候会发送一个信号，线程创建之前会信号等待，所以当同时创建了10个线程之后，for循环就会阻塞，等待有线程结束之后会增加一个信号才继续执行，如此就形成了对并发的控制，如上就是一个并发数为10的一个线程队列。*/
//信号
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
//    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    for (int i = 0; i < 100; i++)
//    {
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        dispatch_group_async(group, queue1, ^{
//            NSLog(@"%i",i);
//            sleep(1);
//            dispatch_semaphore_signal(semaphore);
//        });
//    }
//    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    
//一下两种会死锁
    dispatch_queue_t queue_s = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue_s, ^{
        NSLog(@"dispatch_sync---之前");//只打印 dispatch_sync---之前
        dispatch_sync(queue_s, ^{
            NSLog(@"死锁吗？");
        });
        NSLog(@"dispatch_sync---之后");
    });
    
    NSLog(@"dispatch_sync---死锁之前");//只打印 dispatch_sync---死锁之前
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"死锁");
    });
    NSLog(@"dispatch_sync---死锁之后");
}
//dispatch_apply进行快速迭代
//因为可以并行执行，所以使用dispatch_apply可以运行的更快
- (void)dispatchApplyDemo {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.starming.gcddemo.concurrentqueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_apply(10, concurrentQueue, ^(size_t i) {
        NSLog(@"%zu",i);
    });
    NSLog(@"The end"); //这里有个需要注意的是，dispatch_apply这个是会阻塞主线程的。这个log打印会在dispatch_apply都结束后才开始执行
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Dispatch IO 文件操作
//dispatch io读取文件的方式类似于下面的方式，多个线程去读取文件的切片数据，对于大的数据文件这样会比单线程要快很多。
//
//dispatch_async(queue,^{/*read 0-99 bytes*/});
//dispatch_async(queue,^{/*read 100-199 bytes*/});
//dispatch_async(queue,^{/*read 200-299 bytes*/});
//dispatch_io_create：创建dispatch io
//dispatch_io_set_low_water：指定切割文件大小
//dispatch_io_read：读取切割的文件然后合并。
//苹果系统日志API里用到了这个技术，可以在这里查看：https://github.com/Apple-FOSS-Mirror/Libc/blob/2ca2ae74647714acfc18674c3114b1a5d3325d7d/gen/asl.c
-(void)dispatchIODemo{
//  dispatch_queue_t  pipe_q = dispatch_queue_create("PipeQ", NULL);
//    dispatch_fd_t fd;
//    //创建
//   dispatch_io_t pipe_channel = dispatch_io_create(DISPATCH_IO_STREAM, fd, pipe_q, ^(int err){
//        close(fd);
//    });
//    
//    *out_fd = fdpair[1];
//    //设置切割大小
//    dispatch_io_set_low_water(pipe_channel, SIZE_MAX);
//    
//    dispatch_io_read(pipe_channel, 0, SIZE_MAX, pipe_q, ^(bool done, dispatch_data_t pipedata, int err){
//        if (err == 0)
//        {
//            size_t len = dispatch_data_get_size(pipedata);
//            if (len > 0)
//            {
//                //对每次切块数据的处理
//                const char *bytes = NULL;
//                char *encoded;
//                uint32_t eval;
//                
//                dispatch_data_t md = dispatch_data_create_map(pipedata, (const void **)&bytes, &len);
//                encoded = asl_core_encode_buffer(bytes, len);
//                asl_msg_set_key_val(aux, ASL_KEY_AUX_DATA, encoded);
//                free(encoded);
//                eval = _asl_evaluate_send(NULL, (aslmsg)aux, -1);
//                _asl_send_message(NULL, eval, aux, NULL);
//                asl_msg_release(aux);
//                dispatch_release(md);
//            }
//        }
//        
//        if (done)
//        {
//            //semaphore +1使得不需要再等待继续执行下去。
//            dispatch_semaphore_signal(sem);
//            dispatch_release(pipe_channel);
//            dispatch_release(pipe_q);
//        }
//    });
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self initGCD];
//    [self dispatchApplyDemo];
    NSArray *array = [NSArray arrayWithObjects:@"ccc", nil];
    [array objectAtIndex:3];
    [self dispatchIODemo];
}
//下裂几种情况可能造成思索
- (void)deadLockCase1 {
    NSLog(@"1");
    //主队列的同步线程，按照FIFO的原则（先入先出），2排在3后面会等3执行完，但因为同步线程，3又要等2执行完，相互等待成为死锁。
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"2");
    });
    NSLog(@"3");
}
- (void)deadLockCase2 {
    NSLog(@"1");
    //3会等2，因为2在全局并行队列里，不需要等待3，这样2执行完回到主队列，3就开始执行
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"2");
    });
    NSLog(@"3");
}
- (void)deadLockCase3 {
    dispatch_queue_t serialQueue = dispatch_queue_create("com.starming.gcddemo.serialqueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"1");
    dispatch_async(serialQueue, ^{
        NSLog(@"2");
        //串行队列里面同步一个串行队列就会死锁
        dispatch_sync(serialQueue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}
- (void)deadLockCase4 {
    NSLog(@"1");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"2");
        //将同步的串行队列放到另外一个线程就能够解决
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}
- (void)deadLockCase5 {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"1");
        //回到主线程发现死循环后面就没法执行了
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"2");
        });
        NSLog(@"3");
    });
    NSLog(@"4");
    //死循环
    while (1) {
        //
    }
}
@end
