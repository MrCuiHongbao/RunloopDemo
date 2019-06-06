//
//  HBView.m
//  RunloopDemo
//
//  Created by hongbao.cui on 2019/4/2.
//  Copyright © 2019年 Founder. All rights reserved.
//

#import "HBView.h"

@implementation HBView
- (void)dealloc {
    NSLog(@"dealloc");
}
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(100, 100, 50.0, 50.0);
        [btn setTitle:@"开始" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(startBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}
- (void)startBtnClicked {
    if (self.actionBlock) {
        self.actionBlock(self);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
