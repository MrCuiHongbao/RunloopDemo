//
//  MyTestRuntime.m
//  RunloopDemo
//
//  Created by hongbao.cui on 16/1/21.
//  Copyright © 2016年 Founder. All rights reserved.
//

#import "MyTestRuntime.h"
#import "RuntimeObject.h"
@implementation MyTestRuntime
-(id)init{
    if (self == [super init]) {
        data = [[NSMutableDictionary alloc] init];
        [data setObject:@"Tom Sawyer" forKey:@"title"];
        [data setObject:@"Mark Twain" forKey:@"author"];
        NSLog(@"allString:%@",allString);
        allString = @"不错";
        NSLog(@"allString change------>:%@",allString);
    }
    return self;
}
+ (BOOL) resolveInstanceMethod:(SEL)aSEL
{
    if ([NSStringFromSelector(aSEL) isEqualToString:@"runtimeObjectMethod"])
    {
        return NO;
    }
    return [super resolveInstanceMethod:aSEL];
}
//将消息转出某对象
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    NSLog(@"MyTestRuntime _cmd: %@", NSStringFromSelector(_cmd));
//    RuntimeObject *obj = [[RuntimeObject alloc] init];
//    if ([obj respondsToSelector: aSelector]) {
//        return obj;
//    }
    return [super forwardingTargetForSelector: aSelector];
}
-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSString *sel = NSStringFromSelector(aSelector);
    if ([sel rangeOfString:@"set"].location == 0) {
        //动态造一个 setter函数
        /*Objective-C中的方法默认被隐藏了两个参数：self和_cmd。self指向对象本身，_cmd指向方法本身。举两个例子来说明：
        例一：- (NSString *)name
        这个方法实际上有两个参数：self和_cmd。
        例二：- (void)setValue:(int)val
        这个方法实际上有三个参数：self, _cmd和val。
        被指定为动态实现的方法的参数类型有如下的要求：
        A.第一个参数类型必须是id（就是self的类型）
        B.第二个参数类型必须是SEL（就是_cmd的类型）
        C.从第三个参数起，可以按照原方法的参数类型定义。举两个例子来说明：
        例一：setHeight:(CGFloat)height中的参数height是浮点型的，所以第三个参数类型就是f。
        例二：再比如setName:(NSString *)name中的参数name是字符串类型的，所以第三个参数类型就是@*/
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    } else {
        //动态造一个 getter函数
        return [NSMethodSignature signatureWithObjCTypes:"@@:"];
    }
}
- (void)forwardInvocation:(NSInvocation *)invocation
{
    //拿到函数名
    NSString *key = NSStringFromSelector([invocation selector]);
    if ([key rangeOfString:@"set"].location == 0) {
        //setter函数形如 setXXX: 拆掉 set和冒号
        key = [[key substringWithRange:NSMakeRange(3, [key length]-4)] lowercaseString];
        NSString *obj;
        //从参数列表中找到值
        [invocation getArgument:&obj atIndex:2];
        [data setObject:obj forKey:key];
    } else {
        //getter函数就相对简单了，直接把函数名做 key就好了。
        NSString *obj = [data objectForKey:key];
        [invocation setReturnValue:&obj];
    }
    
}
@end
