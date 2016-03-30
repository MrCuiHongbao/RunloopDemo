//
//  CVDEView.m
//  RunloopDemo
//
//  Created by hongbao.cui on 16/3/9.
//  Copyright © 2016年 Founder. All rights reserved.
//

#import "CVDEView.h"

@implementation CVDEView
- (id)initWithFrame:(CGRect)frame

{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:frame];
        imageView.image=[UIImage imageNamed:@"bookShelf.png"];
        [self addSubview:imageView];
    }
    return self;
    
}
@end
