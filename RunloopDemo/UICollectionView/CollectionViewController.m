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
@property(nonatomic)NSInteger hours;
@property(nonatomic)NSInteger Mins;
@property(nonatomic)NSInteger Seconds;
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
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
-(void)updateLabel{
    if (_Seconds==59) {
        _Mins+=1;
        _Seconds=0;
    }
    if (_Mins==59) {
        _hours+=1;
        _Mins = 0;
        _Seconds = 0;
    }
    _Seconds++;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewCell *cell = [_coll cellForItemAtIndexPath:indexPath];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    [titleLabel setText:[NSString stringWithFormat:@"%02li:%02li:%02li",(long)_hours,(long)_Mins,(long)_Seconds]];
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
    if (indexPath.section==0&&indexPath.item==0) {
        UILabel *titleLabel = (UILabel *) [cell viewWithTag:100];
        if (!titleLabel) {
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
            [titleLabel setText:@"00:00:00"];
            [titleLabel setTextAlignment:NSTextAlignmentCenter];
            titleLabel.tag = 100;
            [cell addSubview:titleLabel];
        }
    }
    return cell;
}
@end
