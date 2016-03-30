//
//  NoteTreeViewController.m
//  RunloopDemo
//
//  Created by hongbao.cui on 16/3/14.
//  Copyright © 2016年 Founder. All rights reserved.
//

#import "NoteTreeViewController.h"
static NSString *indentifier = @"MYCELL";

@interface NoteTreeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray *array;
@property(nonatomic,strong)NSArray *arrayVC;
@property(nonatomic,strong)UITableView *hbTableView;
@end

@implementation NoteTreeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _hbTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_hbTableView setDelegate:self];
    [_hbTableView setDataSource:self];
    [self.view addSubview:_hbTableView];

    _array = @[@"二叉树",@"链表OR二叉树",@"排序算法"];
    _arrayVC = @[@"AboutNoteTreeViewController",@"NoteTreeViewController",@"SortViewController"];
    [_hbTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:indentifier];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_hbTableView removeFromSuperview];
    _hbTableView = nil;

    _array = nil;
    _arrayVC = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_array count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
    cell.textLabel.text = [_array objectAtIndex:indexPath.row];
    // Configure the cell...
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *classString = [_arrayVC objectAtIndex:indexPath.row];
    UIViewController  *controllerVC = [[NSClassFromString(classString) alloc] init];
    [self.navigationController pushViewController:controllerVC animated:YES];
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
