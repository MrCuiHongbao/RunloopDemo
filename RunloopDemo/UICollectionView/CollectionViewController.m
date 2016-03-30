//
//  CollectionViewController.m
//  RunloopDemo
//
//  Created by hongbao.cui on 16/3/9.
//  Copyright © 2016年 Founder. All rights reserved.
//

#import "CollectionViewController.h"
#import "CVCell.h"
#import "CVLayout.h"
@interface CollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)UICollectionView *coll;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CVLayout *layout=[[CVLayout alloc] init];
    _coll = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) collectionViewLayout:layout];
    _coll.bounces = YES;
    _coll.delegate = self;
    _coll.dataSource = self;
    _coll.alwaysBounceVertical = YES;   //总是可以滑动
    _coll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_coll];
    [self.coll registerClass:[CVCell class] forCellWithReuseIdentifier:@"cell"];
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
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 10;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 30;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"forIndexPath:indexPath];
    return cell;
}
@end
