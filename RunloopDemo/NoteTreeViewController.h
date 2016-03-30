//
//  NoteTreeViewController.h
//  RunloopDemo
//
//  Created by hongbao.cui on 16/3/14.
//  Copyright © 2016年 Founder. All rights reserved.
//

#import <UIKit/UIKit.h>
#include<stdio.h>
struct priorityqueue{
    int capacity;
    int size;
    struct priorityqueue *elements;
}*tryit;
@interface NoteTreeViewController : UIViewController

@end
