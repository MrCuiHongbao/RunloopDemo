//
//  WebViewController.m
//  RunloopDemo
//
//  Created by hongbao.cui on 2019/3/25.
//  Copyright © 2019年 Founder. All rights reserved.
//

#import "WebViewController.h"
 #import <WebKit/WebKit.h>
#import "HBOpenCamerManager.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface WebViewController ()<WKNavigationDelegate,WKUIDelegate,HBCameraDelegate,WKScriptMessageHandler> {
    HBOpenCamerManager *manger;
}
@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,assign)BOOL isH5;
@property(nonatomic,strong)JSContext* jsContext;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    manger = [[HBOpenCamerManager alloc] initWithCamera:AVCaptureSessionPreset1280x720 delegate:self WithParentView:self.view];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    //注册js方法
    configuration.userContentController = [[WKUserContentController alloc]init];
    //webViewAppShare这个需保持跟服务器端的一致，服务器端通过这个name发消息，客户端这边回调接收消息，从而做相关的处理
    [configuration.userContentController addScriptMessageHandler:self name:@"webViewAppShare"];
    
    
     self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_webView];
    [_webView setOpaque:NO];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://h5.m.jd.com/babelDiy/Zeus/JYUhHdKegz2mSV3aAYuK1fZvobJ/index.html"]];
    [_webView loadRequest:request];
    self.jsContext = [[JSContext alloc] init];
    
    //设置异常处理
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [JSContext currentContext].exception = exception;
        NSLog(@"exception:%@",exception);
    };
//    NSString *js = @"function add(a,b) {return a + b}";
//    [self.jsContext evaluateScript:js];
//    JSValue *jsValue = [self.jsContext[@"add"] callWithArguments:@[@2,@3]];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [manger start_camera];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [manger stopMethod];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (CIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer {
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *ciimage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    // 旋转的方法
    CIImage *wImage = [ciimage imageByApplyingOrientation:6];
    return wImage;
}
-(NSString *)covertFromBase64EvaluatingJavaScriptWithBuffer:(CMSampleBufferRef)sampleBuffer {
    CIImage *ciimage = [self imageFromSampleBuffer:sampleBuffer];
    UIImage *originalImage = [UIImage imageWithCIImage:ciimage];
    UIGraphicsBeginImageContext(originalImage.size);
    [originalImage drawInRect:CGRectMake(0, 0, originalImage.size.width, originalImage.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *data = UIImageJPEGRepresentation(newImage,0.8);
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    return base64String;
}
-(NSString*)DataTOjsonString:(id)object{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
- (void)didOutputSampleBuffer:(CMSampleBufferRef _Nullable)sampleBuffer {
    NSLog(@"-----cuihongbao------didOutputSampleBuffer");
    if (self.isH5) {
        NSString *base64 = [self covertFromBase64EvaluatingJavaScriptWithBuffer:sampleBuffer];
        NSDictionary *dict = @{@"action":@"getPicture",@"state":@"1",@"image":base64};
        NSString *jsonBase64 = [self DataTOjsonString:dict];
        
        //加载JS代码到context中
        [self.jsContext evaluateScript:@"function nativeARMatrixCallback(obj) {shot(obj)}"];
        //调用JS方法
        [self.jsContext[@"nativeARMatrixCallback"] callWithArguments:@[jsonBase64]];
//        NSString *base64String =[NSString stringWithFormat:@"window.nativeARMatrixCallback&& window.nativeARMatrixCallback(%@)",jsonBase64];
//        self.jsContext[@"nativeARMatrixCallback"];
//        = ^(NSInteger a, NSInteger b) {
//
//        };
//        [self.jsContext evaluateScript:base64String];
//        [_webView evaluateJavaScript:base64String completionHandler:nil];
        self.isH5 = NO;
    }
}
#pragma mark - WKNavigationDelegate
///加载完成网页的时候才开始注入JS代码,要不然还没加载完时就可以点击了,就不能调用

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:NULL];
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {

}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"data.txt" ofType:nil];
//    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    [_webView evaluateJavaScript:str completionHandler:nil];
}
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"webViewWebContentProcessDidTerminate" message:@"内存问题失败" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [webView reload];
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}
#pragma mark - WKUIDelegate

- (void)webViewDidClose:(WKWebView *)webView {
    NSLog(@"%s", __FUNCTION__);
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    self.isH5 = YES;
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:@"JS调用alert" preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
//        }]];
//        [self presentViewController:alert animated:YES completion:NULL];
//        NSLog(@"%@", message);
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {

}
@end
