//
//  AboutNoteTreeViewController.h
//  RunloopDemo
//
//  Created by hongbao.cui on 16/3/23.
//  Copyright © 2016年 Founder. All rights reserved.
//

#import "BaseViewController.h"
// define data type for the key
typedef int data_type;
// define binary search tree data structure
typedef struct bst_node{
    data_type data;
    struct bst_node *lchild;//left child
    struct bst_node *rchild;//right child
}bst_t,*bst_p; //bst_t定义结构体变量    *bst_p定义结构体变量（是一个指针指向了这个结构体变量）

@interface AboutNoteTreeViewController : BaseViewController

@end
