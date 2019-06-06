//
//  HBOpenCamerManager.h
//  RunloopDemo
//
//  Created by hongbao.cui on 2019/3/25.
//  Copyright © 2019年 Founder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
@protocol HBCameraDelegate <NSObject>
- (void)didOutputSampleBuffer:(CMSampleBufferRef _Nullable )sampleBuffer;
@end
NS_ASSUME_NONNULL_BEGIN

@interface HBOpenCamerManager : NSObject
@property(nonatomic,strong)AVCaptureSession *captureSession;
@property(nonatomic,copy)AVCaptureSessionPreset sessionPreset;
@property (nonatomic ,weak)id <HBCameraDelegate>delegate;
@property(nonatomic,strong)dispatch_queue_t cameraSerialQueue;//同一个队列中

- (instancetype)initWithCamera:(NSString *)sessionPreset  delegate:(id<HBCameraDelegate>)cameraDelegate WithParentView:(UIView *)aView;

- (void)start_camera;

- (void)stopMethod;
@end

NS_ASSUME_NONNULL_END
