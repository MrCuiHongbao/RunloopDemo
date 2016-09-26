//
//  InterViewViewController.h
//  RunloopDemo
//
//  Created by Founder on 16/7/12.
//  Copyright © 2016年 Founder. All rights reserved.
//

#import <UIKit/UIKit.h>
//static NSInteger HBParams=15; 限制作用域
 NSInteger HBParams=15;
typedef void(^testBlock)();
@interface InterViewViewController : UIViewController
@property(nonatomic,copy)testBlock testBlock;
@property (nonatomic, weak) IBOutlet UITextField *textfield;
-(IBAction)btnClicked:(id)sender;
-(IBAction)btnKVOClicked:(id)sender;
@end
