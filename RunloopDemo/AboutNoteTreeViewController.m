//
//  AboutNoteTreeViewController.m
//  RunloopDemo
//
//  Created by hongbao.cui on 16/3/23.
//  Copyright © 2016年 Founder. All rights reserved.
// 二叉查找树（BinarySearch Tree，也叫二叉搜索树，或称二叉排序树Binary Sort Tree）或者是一棵空树，或者是具有下列性质的二叉树：
//（1）、若它的左子树不为空，则左子树上所有结点的值均小于它的根结点的值；
//
//（2）、若它的右子树不为空，则右子树上所有结点的值均大于它的根结点的值；
//
//（3）、它的左、右子树也分别为二叉查找树。


#import "AboutNoteTreeViewController.h"

@interface AboutNoteTreeViewController ()

@end

@implementation AboutNoteTreeViewController
//（1）、插入
//在二叉查找树中插入新结点，要保证插入新结点后仍能满足二叉查找树的性质。例子中的插入过程如下：
//
//a、若二叉查找树root为空，则使新结点为根；
//
//b、若二叉查找树root不为空，则通过search_bst_for_insert函数寻找插入点并返回它的地址（若新结点中的关键字已经存在，则返回空指针）；
//
//c、若新结点的关键字小于插入点的关键字，则将新结点插入到插入点的左子树中，大于则插入到插入点的右子树中。

static bst_p search_bst_for_insert(bst_p *root,data_type key){
    bst_p s = NULL, p = *root;//s初始化为空指针，p指向了root节点
    
    while (p) {//当root节点不为空s指向了p
        s = p;
        
        if (p->data == key)//如果p节点的值等于输入key的值，返回key值
            return NULL;
        
        p = (key < p->data) ? p->lchild : p->rchild;//如果输入的key节点值小于跟节点的值，p指向p节点的左孩子，如果输入key节点的值大于根节点的值，p指向p节点的右孩子
    }  
    
    return s;
}
//(2) 插入key ：向BST中插入一个key，不能破坏BST的规则
void insert_bst_node(bst_p *root, data_type data){
    bst_p s, p;
    
    s = malloc(sizeof(struct bst_node));
    if (!s)
        perror("Allocate dynamic memory");
    
    s -> data = data;
    s -> lchild = s -> rchild = NULL;
    
    if (*root == NULL)
        *root = s;
    else {
        p = search_bst_for_insert(root, data);
        if (p == NULL) {
            fprintf(stderr, "The %d already exists.\n", data);
            free(s);
            return;
        }
        
        if (data < p->data)
            p->lchild = s;
        else  
            p->rchild = s;  
    }
}
//遍历
static int print(data_type data)
{
    printf("%d ", data);
    
    return 1;
}
//前序遍历二叉树
int pre_order_traverse(bst_p root, int (*visit)(data_type data))
{
    if (root) {
        if (visit(root->data))
            if (pre_order_traverse(root->lchild, visit))
                if (pre_order_traverse(root->rchild, visit))
                    return 1;
        return 0;
    }
    else
        return 1;
}
//中序遍历二叉树
int post_order_traverse(bst_p root, int (*visit)(data_type data))
{
    if (root) {
        if (post_order_traverse(root->lchild, visit))
            if (visit(root->data))
                if (post_order_traverse(root->rchild, visit))
                    return 1;
        return 0;
    }
    else
        return 1;
}
//后序遍历二叉树
int last_order_traverse(bst_p root, int (*visit)(data_type data))
{
    if (root) {
        if (last_order_traverse(root->lchild, visit))
                if (last_order_traverse(root->rchild, visit))
                    if (visit(root->data))
                     return 1;
        return 0;
    }
    else
        return 1;
}
//（3）、删除
//
//删除某个结点后依然要保持二叉查找树的特性。例子中的删除过程如下：
//
//a、若删除点是叶子结点，则设置其双亲结点的指针为空。
//
//b、若删除点只有左子树，或只有右子树，则设置其双亲结点的指针指向左子树或右子树。
//
//c、若删除点的左右子树均不为空，则：
//
//1）、查询删除点的右子树的左子树是否为空，若为空，则把删除点的左子树设为删除点的右子树的左子树。
//2）、若不为空，则继续查询左子树，直到找到最底层的左子树为止。
void delete_bst_node(bst_p *root, data_type data) {
    bst_p p = *root, parent = NULL, s;
    
    if (!p) {
        fprintf(stderr, "Not found %d.\n", data);
        return;
    }
    
    if (p->data == data) {
        /* It's a leaf node */
        if (!p->rchild && !p->lchild) {
            *root = NULL;
            free(p);
        }
        /* the right child is NULL */
        else if (!p->rchild) {
            *root = p->lchild;
            free(p);
        }
        /* the left child is NULL */
        else if (!p->lchild) {
            *root = p->rchild;
            free(p);
        }
        /* the node has both children */
        else {
            s = p->rchild;
            /* the s without left child */
            if (!s->lchild)
                s->lchild = p->lchild;
            /* the s have left child */
            else {
                /* find the smallest node in the left subtree of s */
                while (s->lchild) {
                    /* record the parent node of s */
                    parent = s;
                    s = s->lchild;
                }
                parent->lchild = s->rchild;
                s->lchild = p->lchild;
                s->rchild = p->rchild;
            }
            *root = s;
            free(p);
        }  
    }   
    else if (data > p->data) {  
        delete_bst_node(&(p->rchild), data);  
    }   
    else if (data < p->data) {  
        delete_bst_node(&(p->lchild), data);  
    }
}
//二叉查找树的实现
-(void)initTreeNode{
    //测试用例
    printf("插入构建二叉查找树：4 2 5 3 1 6\n");
    int i, num;
    bst_p root = NULL;
    data_type arr[6] = {4,2,45,3,1,6};
    num =sizeof(arr)/sizeof(arr[0]);
    for (i = 0; i < num; i++) {
        printf("Please enter %d integers:\n", arr[i]);
        insert_bst_node(&root, arr[i]);
    }
    printf("\npre order traverse: ");//前序遍历
    pre_order_traverse(root, print);
    printf("\npost order traverse: ");//中序遍历
    post_order_traverse(root, print);
    printf("\nlast order traverse: ");//后序遍历
    last_order_traverse(root, print);
    printf("\n");
    
    delete_bst_node(&root, 45);
    
    printf("\npre order traverse: ");
    pre_order_traverse(root, print);
    printf("\npost order traverse: ");
    post_order_traverse(root, print);
    printf("\n");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTreeNode];
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
