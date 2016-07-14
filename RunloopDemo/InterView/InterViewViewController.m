//
//  InterViewViewController.m
//  RunloopDemo
//
//  Created by Founder on 16/7/12.
//  Copyright © 2016年 Founder. All rights reserved.
//

#import "InterViewViewController.h"
#import "NSObject+KVO.h"
@interface Message : NSObject

@property (nonatomic, copy) NSString *text;

@end

@implementation Message

@end
@interface InterViewViewController ()
@property(nonatomic,strong)NSMutableArray *dataList;
@property (nonatomic, strong) Message *message;
@property (nonatomic)NSInteger number;
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
        NSLog(@"dataList:---1--->:%@",weakSelf.dataList);
        i=7;
        NSLog(@"i:----1-->:%d",i);
        weakSelf.number = 5;
        NSLog(@"number:---1--->:%d",weakSelf.number);
    };

    self.message = [[Message alloc] init];
    [self.message PG_addObserver:self forKey:NSStringFromSelector(@selector(text))
                       withBlock:^(id observedObject, NSString *observedKey, id oldValue, id newValue) {
                           NSLog(@"%@.%@ is now: %@", observedObject, observedKey, newValue);
                           dispatch_async(dispatch_get_main_queue(), ^{
                               self.textfield.text = newValue;
                           });
                           
                       }];
    
    [self btnKVOClicked:nil];
    
    NSString *strURL = [NSString stringWithFormat:@"http://www.当代教育家.com/app/homework/api/login.do?loginname=yumeng&password=yumeng"];
    strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSError *error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"error----->:%@",[error description]);
    NSLog(@"str----->:%@",str);
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
    NSLog(@"dataList:---2--->:%@",self.dataList);
    NSLog(@"number:---2--->:%d",self.number);
}
-(IBAction)btnKVOClicked:(id)sender{
    NSArray *msgs = @[@"Hello World!", @"Objective C", @"Swift", @"Peng Gu", @"peng.gu@me.com", @"www.gupeng.me", @"glowing.com"];
    NSUInteger index = arc4random_uniform((u_int32_t)msgs.count);
    self.message.text = msgs[index];
}
@end
