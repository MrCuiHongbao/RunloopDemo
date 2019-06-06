//
//  HBOpenCamerManager.m
//  RunloopDemo
//
//  Created by hongbao.cui on 2019/3/25.
//  Copyright © 2019年 Founder. All rights reserved.
//

#import "HBOpenCamerManager.h"
@interface HBOpenCamerManager()<AVCaptureVideoDataOutputSampleBufferDelegate>{
    NSValue *valueCamera;
}
@property(nonatomic,strong)UIView *parentView;
@end
@implementation HBOpenCamerManager

- (instancetype)initWithCamera:(NSString *)sessionPreset  delegate:(id<HBCameraDelegate>)cameraDelegate WithParentView:(UIView *)aView {
    if (self == [super init]) {
        if ([self isSimuLator]) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, aView.frame.size.width, 50.0)];
            [titleLabel setText:@"模拟器不支持相机"];
            [titleLabel setTextAlignment:NSTextAlignmentCenter];
            [aView addSubview:titleLabel];
            titleLabel.center = aView.center;
            aView.backgroundColor = [UIColor whiteColor];
            return self;
        }
        self.parentView = aView;
        self.delegate = cameraDelegate;
        AVAuthorizationStatus  authorizationStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authorizationStatus == AVAuthorizationStatusAuthorized) {
            [self createCamera];
        } else if (authorizationStatus !=AVAuthorizationStatusDenied ) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    [self createCamera];
                }
            }];
        }
    }
    return self;
}
- (void)start_camera {
    [self runMethod];
}
- (void)runMethod {
    if (!self.captureSession.running) {
        [self.captureSession startRunning];
    }
}
- (void)stopMethod {
    if (self.captureSession) {
        [self.captureSession stopRunning];
    }
}
- (void)createCamera {
    if (self.captureSession) {
        return;
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        self.sessionPreset = AVCaptureSessionPreset1920x1080;
        valueCamera =[NSValue valueWithCGSize:CGSizeMake(640, 360)];
    } else {
        self.sessionPreset = AVCaptureSessionPreset640x480;
        valueCamera =[NSValue valueWithCGSize:CGSizeMake(640, 480)];
    }
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *videoDevice = nil;
    for (AVCaptureDevice *device in devices) {
        if (device.position == AVCaptureDevicePositionBack) {
            videoDevice = device;
            break;
        }
    }
    if (!videoDevice) {
        //        NSLog(@"AVCaptureDevice is error!!");
    }
    NSError *err = nil;
    AVCaptureDeviceInput *captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&err];
    if (err) {
        //        NSLog(@"AVCaptureDeviceInput init is error!!");
    }
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    self.captureSession = session;
    session.sessionPreset = _sessionPreset;
    if ([session canAddInput:captureDeviceInput]) {
        [session addInput:captureDeviceInput];
    }
    AVCaptureVideoDataOutput *dataOutput =  [[AVCaptureVideoDataOutput alloc] init];
    [dataOutput setVideoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey:
                                       [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]}];
    [dataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    dataOutput.alwaysDiscardsLateVideoFrames = YES;
    if ([session canAddOutput:dataOutput]) {
        [session addOutput:dataOutput];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setPreviewLayer:CGRectZero];
    });
}
- (void)setPreviewLayer:(CGRect)layerRect {
    dispatch_async(self.cameraSerialQueue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
            [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
            UIView *cameraView = [[UIView alloc] initWithFrame:self.parentView.bounds];
            CGRect layerRect = self.parentView.layer.bounds;
            [previewLayer setBounds:layerRect];
            [previewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
            [cameraView.layer addSublayer:previewLayer];
            [self.parentView insertSubview:cameraView atIndex:0];
        });
    });
}
#pragma mark- setter
- (dispatch_queue_t)cameraSerialQueue {
    if (!_cameraSerialQueue) {
        _cameraSerialQueue = dispatch_queue_create("com.hqarcamera.arvr", NULL);
    }
    return _cameraSerialQueue;
}
#pragma mark -
#pragma mark -AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    if (_delegate&&[_delegate respondsToSelector:@selector(didOutputSampleBuffer:)]) {
        [_delegate didOutputSampleBuffer:sampleBuffer];
    }
}

#pragma 判断是否为模拟器
-(BOOL)isSimuLator
{
    if (TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1) {
        //模拟器
        return YES;
    }else{
        //真机
        return NO;
    }
}
@end
