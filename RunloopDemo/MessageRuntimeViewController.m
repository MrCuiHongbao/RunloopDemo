//
//  MessageRuntimeViewController.m
//  RunloopDemo
//
//  Created by hongbao.cui on 16/1/21.
//  Copyright © 2016年 Founder. All rights reserved.
//
/*
    runtime
    1.调用method方法，首先判断笨类是否实现了该方法，本类中实现了该方法，则不在调用若不掉用super则不调用父类的该方法，如果本类中没有实现method，则有三种方式解决崩溃前的处理，如果不处理，则程序崩溃
    第一种方式resolveInstanceMethod
 
 void dynamicMethodIMP(id self, SEL _cmd)
 {
     printf("SEL %s did not exist\n",sel_getName(_cmd));
 }
 + (BOOL) resolveInstanceMethod:(SEL)aSEL
 {
     if (aSEL == @selector(method))
     {
      class_addMethod([self class], aSEL, (IMP) dynamicMethodIMP, "v@:");
     return YES;
     }
     return [super resolveInstanceMethod:aSEL];
 }
 2
*/

#import "MessageRuntimeViewController.h"
#import <objc/runtime.h>
#import "MyTestRuntime.h"
@interface Father ()
@property (nonatomic, copy) NSString *name;
@end
@implementation Father
- (NSString *)description
{
    return [NSString stringWithFormat:@"name:%@",_name];
}
@end
@interface MessageRuntimeViewController ()

@end

@implementation MessageRuntimeViewController
void dynamicMethodIMP(id self, SEL _cmd)
{
    printf("SEL %s did not exist\n",sel_getName(_cmd));
}
+ (BOOL) resolveInstanceMethod:(SEL)aSEL
{
    if (aSEL == @selector(method))
    {
        class_addMethod([self class], aSEL, (IMP) dynamicMethodIMP, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:aSEL];
}
-(id)forwardingTargetForSelector:(SEL)aSelector{
    NSString *selectorStr =NSStringFromSelector(aSelector);
    NSLog(@"selectorStr:%@",selectorStr);
    if (aSelector == @selector(method))
    {
        return [super forwardingTargetForSelector:_cmd];
    }
    return [super forwardingTargetForSelector:aSelector];
}
//-(void)method{
//    NSLog(@"-----method--------");
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    如何访问并修改一个类的私有属性？
//    有两种方法可以访问私有属性,一种是通过KVC获取,一种是通过runtime访问并修改私有属性
//    创建一个Father类,声明一个私有属性name,并重写description打印name的值,在另外一个类中通过runtime来获取并修改Father中的属性
    Father *father = [Father new];
    // count记录变量的数量IVar是runtime声明的一个宏
    unsigned int count = 0;
    // 获取类的所有属性变量
    Ivar *menbers = class_copyIvarList([Father class], &count);
    
    for (int i = 0; i < count; i++) {
        Ivar ivar = menbers[i];
        // 将IVar变量转化为字符串,这里获得了属性名
        const char *memberName = ivar_getName(ivar);
        NSLog(@"%s",memberName);
        
        Ivar m_name = menbers[0];
        // 修改属性值
        object_setIvar(father, m_name, @"zhangsan");
        // 打印后发现Father中name的值变为zhangsan
        NSLog(@"%@",[father description]);
    }
    
    
     //测试 1
     //[self performSelector:@selector(method) withObject:nil];
    
    //测试 2
//    MyTestRuntime *runtime = [[MyTestRuntime alloc] init];
//    [runtime performSelector:@selector(runtimeObjectMethod) withObject:nil];
//    [runtime performSelector:@selector(title) withObject:nil];
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
