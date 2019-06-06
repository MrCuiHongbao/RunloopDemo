//
//  RunLoopViewController.m
//  RunloopDemo
//
//  Created by hongbao.cui on 16/1/19.
//  Copyright © 2016年 Founder. All rights reserved.
//

#import "RunLoopViewController.h"

@interface RunLoopViewController (){
    CFRunLoopRef _runLoopRef;
    CFRunLoopSourceRef _source;
    NSThread *_tThread;
    CFRunLoopSourceContext _source_context;
}
@property(nonatomic)BOOL shouldStop;
@property(nonatomic,strong)NSThread *thread;
@end

@implementation RunLoopViewController
#pragma mark-NSRunLoop Timer
-(void)initSelfTimer{
    //创建Timer
    //    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(timer_callback) userInfo:nil repeats:YES];
    //    //使用NSRunLoopCommonModes模式，把timer加入到当前Run Loop中。
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    NSLog(@"主线程 %@", [NSThread currentThread]);
    //创建并执行新的线程
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(newThread) object:nil];
    [thread start];
}
- (void)newThread
{
    @autoreleasepool
    {
        NSLog(@"newThread-------%@",[NSRunLoop currentRunLoop]);
        //在当前Run Loop中添加timer，模式是默认的NSDefaultRunLoopMode
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timer_callback) userInfo:nil repeats:YES];
        //开始执行新线程的Run Loop
        [[NSRunLoop currentRunLoop] run];
    }
}
//timer的回调方法
- (void)timer_callback
{
    NSLog(@"Timer %@", [NSThread currentThread]);
}
static void _perform(void *info __unused)
{
    printf("hello\n");
}

static void _timer(CFRunLoopTimerRef timer __unused, void *info)
{
    CFRunLoopSourceSignal(info);
}
/*
  两个input source，一个是timer，一个是自定义input source，然后这个timer中触发自定义source，于是调用其回调方法.input source（输入源例）到底是什么呢？输入源样例可能包括用户输入设备（如点击button）、网络链接(socket收到数据)、定期或时间延迟事件（NSTimer），还有异步回调(NSURLConnection的异步请求)。然后我们对其进行了分类，有三类可以被runloop监控，分别是sources、timers、observers。
 
     每一个线程都有自己的runloop, 主线程是默认开启的，创建的子线程要手动开启，因为NSApplication 只启动main applicaiton thread。
     没有source的runloop会自动结束。
     事件由NSRunLoop 类处理。
     RunLoop监视操作系统的输入源，如果没有事件数据， 不消耗任何CPU 资源。
     如果有事件数据，run loop 就发送消息，通知各个对象。
     用 currentRunLoop 获得 runloop的 reference
     给 runloop 发送run 消息启动它。
 
     文档中介绍下面四种情况是使用runloop的场合：
     1.使用端口或自定义输入源和其他线程通信
     2.子线程中使用了定时器
     3.cocoa中使用任何performSelector到了线程中运行方法
     4.使线程履行周期性任务，（我把这个理解与2相同）
     如果我们在子线程中用了NSURLConnection异步请求，那也需要用到runloop，不然线程退出了，相应的delegate方法就不能触发。
 */
-(void)initinPutSource{
    CFRunLoopSourceRef source;//自定义输入源
    CFRunLoopSourceContext source_context;//输入源runloop上下文
    CFRunLoopTimerRef timer;//输入源timer
    CFRunLoopTimerContext timer_context;//timer上下文
    
    bzero(&source_context, sizeof(source_context));
    source_context.perform = _perform;
    source = CFRunLoopSourceCreate(NULL, 0, &source_context);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopCommonModes);
    
    bzero(&timer_context, sizeof(timer_context));
    timer_context.info = source;
    timer = CFRunLoopTimerCreate(NULL, CFAbsoluteTimeGetCurrent(), 1, 0, 0,
                                 _timer, &timer_context);
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes);
    CFRunLoopRun();
}
-(void)initRunLoopTimer{
    dispatch_source_t source, timer;
    
    source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0,
                                    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_event_handler(source, ^{
        printf("hello\n");
    });
    dispatch_resume(source);
    
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
                                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        dispatch_source_merge_data(source, 1);
    });  
    dispatch_resume(timer);  
    
    dispatch_main();
}
-(void)initViewButton{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //这里偷个懒，直接使用performSelectorInBackground来创建一个线程，并执行configRunLoop方法
    [self performSelectorInBackground:@selector(configRunLoop) withObject:nil];
    
    UIButton* __button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [__button1 setTitle:@"Fire Event" forState:UIControlStateNormal];
    //触发事件启动RunLoop
    [__button1 addTarget:self action:@selector(triggerEvent) forControlEvents:UIControlEventTouchUpInside];
    __button1.frame = CGRectMake(0, 0, 100, 80);
    [self.view addSubview:__button1];
    
    
    UIButton* __button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [__button2 setTitle:@"Stop RunLoop" forState:UIControlStateNormal];
    //RunLoop周期完成后自动退出线程
    [__button2 addTarget:self action:@selector(stopRunloop) forControlEvents:UIControlEventTouchUpInside];
    __button2.frame = CGRectMake(110, 0, 120, 80);
    [self.view addSubview:__button2];
}
- (void)stopRunloop{
    _shouldStop = YES;
}

- (void)triggerEvent{
    if (CFRunLoopIsWaiting(_runLoopRef)) {
        NSLog(@"RunLoop 正在等待事件输入");
        //添加输入事件
        CFRunLoopSourceSignal(_source);
        //唤醒线程，线程唤醒后发现由事件需要处理，于是立即处理事件
        CFRunLoopWakeUp(_runLoopRef);
    }else {
        NSLog(@"RunLoop 正在处理事件");
        //添加输入事件，当前正在处理一个事件，当前事件处理完成后，立即处理当前新输入的事件
        CFRunLoopSourceSignal(_source);
    }
}

//此输入源需要处理的后台事件
static void fire(void* info __unused){
    NSLog(@"我现在正在处理后台任务");
    sleep(6);
}

- (void)configRunLoop{
    //这里获取到的已经是某个子线程了哦，不是主线程哦
    _tThread = [NSThread currentThread];
    //这里也是这个子线程的RunLoop哦
    _runLoopRef = CFRunLoopGetCurrent();
    
    bzero(&_source_context, sizeof(_source_context));
    //这里创建了一个基于事件的源
    _source_context.perform = fire;
    _source = CFRunLoopSourceCreate(NULL, 0, &_source_context);
    //将源添加到当前RunLoop中去
    CFRunLoopAddSource(_runLoopRef, _source, kCFRunLoopCommonModes);
    
    
    while (!_shouldStop) {
        NSLog(@"RunLoop 开始运行");
        //每次RunLoop只运行10秒，每10秒做一次检测，如果没有需要处理的后台任务了，就让此线程自己终止，不用暴力Kill
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 10, NO);
        NSLog(@"RunLoop 停止运行");
    }
    _tThread = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self initSelfTimer];
//    [self initinPutSource];
//    [self initRunLoopTimer];
//    [self initViewButton];
    
    UIButton* __button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [__button1 setTitle:@"Fire Event" forState:UIControlStateNormal];
    //触发事件启动RunLoop
    [__button1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    __button1.frame = CGRectMake(0, 0, 100, 80);
    [self.view addSubview:__button1];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(show) object:nil];
    [thread start];
}
- (void)show {
    [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    
    NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(test) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:time forMode:NSDefaultRunLoopMode];
    
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"RunLoop进入");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"RunLoop要处理Timers了");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"RunLoop要处理Sources了");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"RunLoop要休息了");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"RunLoop醒来了");
                break;
            case kCFRunLoopExit:
                NSLog(@"RunLoop退出了");
                break;
                
            default:
                break;
        }
    });
    // 给RunLoop添加监听者
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    // 2.子线程需要开启RunLoop
    [[NSRunLoop currentRunLoop]run];
    CFRelease(observer);
}
- (IBAction)btnClick:(id)sender {
    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:NO];
}
-(void)test {
    NSLog(@"%@",[NSThread currentThread]);
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
