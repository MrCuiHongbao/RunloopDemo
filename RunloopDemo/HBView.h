//
//  HBView.h
//  RunloopDemo
//
//  Created by hongbao.cui on 2019/4/2.
//  Copyright © 2019年 Founder. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HBView;
typedef void(^HBBtnActionBlock)(HBView *aView);
@interface HBView : UIView
@property(nonatomic,copy)HBBtnActionBlock actionBlock;
@end

NS_ASSUME_NONNULL_END
