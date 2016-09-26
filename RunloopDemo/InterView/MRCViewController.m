//
//  MRCViewController.m
//  RunloopDemo
//
//  Created by Founder on 16/8/11.
//  Copyright © 2016年 Founder. All rights reserved.
//

#import "MRCViewController.h"

@interface MRCViewController ()

@end

@implementation MRCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSMutableArray* ary = [[NSMutableArray array] retain];
    NSString *str = [NSString stringWithFormat:@"test"];//1
    NSLog(@"%@:%d",str,[str retainCount]);//2
    [str retain];//2
    NSLog(@"%@:%d",str,[str retainCount]);//2
    [ary addObject:str];
    NSLog(@"%@:%d",str,[str retainCount]);//3
    [str retain];//4
    [str release];//3
    [str release];//2
    NSLog(@"%@:%d",str,[str retainCount]);//2
    [ary removeAllObjects];
    NSLog(@"%@:%d",str,[str retainCount]);//1
    NSLog(@"ary:%d",[ary retainCount]);//2

    NSString *str2 = [[NSString alloc] initWithString:@"2"];
    NSLog(@"%@:%d",str2,[str2 retainCount]);//2
    [str2 retain];
    [str2 retain];
    str2 = @"5";
    NSLog(@"%@:%d",str2,[str2 retainCount]);//2
    
    NSArray *array = [NSArray arrayWithObjects:@(1),@(5),@(7),@(9),@(3),@(11), nil];
    //[NSArray arrayWithObjects:@"1",@"2" count:2];
    NSLog(@"array--------%ld",(long)array.count);
    NSInteger  index = [array indexOfObject:@(9) inSortedRange:NSMakeRange(0, array.count) options:NSBinarySearchingFirstEqual usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSLog(@"obj1---------%@-----obj2---------%@",obj1,obj2);
        return [obj1 compare:obj2];
    }];
    NSLog(@"indexOfObject----index------->:%ld",(long)index);
    NSLog(@"array------->:%@",array);
    
    NSHashTable *hashTable = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:5];
    [hashTable addObject:@"1"];
    [hashTable addObject:@"2"];
    [hashTable addObject:nil];
    NSString *str1 = [NSString stringWithFormat:@"3333"];
    NSLog(@"NSHashTable:%ld",(long)[str1 retainCount]);
    [hashTable addObject:str1];
    NSLog(@"NSHashTable:%ld",(long)[str1 retainCount]);
    NSLog(@"NSHashTable:%@",hashTable);
    [hashTable release];
    
    NSMapTable *map = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory capacity:3];
    [map setObject:@"1" forKey:@"cui"];
    [map setObject:@"2" forKey:@"hong"];
    [map setObject:nil forKey:@"bao"];
    NSString *str3 = [NSString stringWithFormat:@"3333"];
    [map setObject:str3 forKey:@"cuiHong"];
    NSLog(@"NSMapTable:%ld",(long)[str3 retainCount]);
    NSLog(@"map:%@",map);
    [map release];
    extern NSInteger HBParams;
    NSLog(@"--HBParams--:%d",HBParams);
    
    NSLog(@"----self.view------%ld",(long)[self.view retainCount]);

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    label.text = @"retailCount";
    [label autorelease];
    NSLog(@"----label------%ld",(long)[label retainCount]);

    [self.view addSubview:label];
    NSLog(@"----label------%ld",(long)[label retainCount]);
    
    NSLog(@"----self.view------%ld",(long)[self.view retainCount]);

    
//    NSAutoreleasePool *pooll= [[NSAutoreleasePool alloc] init];
//    
//    [pooll release];
    
    
    unsigned int i = 0x123456ab;
    unsigned char *pi = (unsigned char *)&i;
    for (int i=0; i<sizeof(i); i++) {
        printf("%X",*pi++);
    }
//    MYMARCO(self, self);
    
    char *j = "jdms\0";
    printf("\n%lu,%lu",strlen(j),sizeof(j));
    
    NSObject *object = [[NSObject alloc] init];
    printf(@"\n----%lu",sizeof((char *)object));
//    swipe(1, 2);
    
    NSMutableArray *enumlator = [NSMutableArray arrayWithObjects:@"5",@"3",@"2",@"1",nil];
    for (NSInteger i=0; i<enumlator.count; i++) {
        NSString *object = [enumlator objectAtIndex:i];
        [enumlator removeObject:object];
    }
    NSLog(@"enumlator----0----%@",enumlator);
    NSMutableArray *enumlator2 = [NSMutableArray arrayWithObjects:@"5",@"3",@"2",@"1",nil];
//    for(int i = enumlator2.count -1;i >= 0;i--){
//        NSString *object = [enumlator2 objectAtIndex:i];
//        [enumlator2 removeObject:object];
//    }
//    [enumlator2 enumerateObjectsUsingBlock:^(id obj, NSUInteger   idx, BOOL *stop) {//线程安全，但不能解决
//        [enumlator2 removeObject:obj];
//        NSLog(@"enumlator----n----%d",idx);
//    }];
    NSLog(@"enumlator----n----%@",enumlator2);

    NSArray *whatYouNeedArray = [enumlator2 filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
//        return ![evaluatedObject shouldBeDeleted];
        NSLog(@"evaluatedObject:%@",evaluatedObject);
        NSLog(@"bindings:%@",bindings);
        [enumlator2 removeObject:evaluatedObject];
        return YES;
    }]];
    NSLog(@"whatYouNeedArray%@",enumlator2);
}
void swipe(int *p1,int *p2){
    int nTemp=0;
    int *p=&nTemp;
    *p = *p1;
    *p1 = *p2;
    *p2 =*p;
}
#define  MYMARCO(_t,_m)\
((unsigned int)(&((_t *0))->_m) -(unsigned int)(_t *)0)
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
-(void)dealloc{
    [super dealloc];
}
@end
