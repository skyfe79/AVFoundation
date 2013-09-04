//
//  ViewController.m
//  Shooter
//
//  Created by Geppy Parziale on 2/24/12.
//  Copyright (c) 2012 iNVASIVECODE, Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>
- (CAAnimation *)animationForRotationX:(float)x Y:(float)y andZ:(float)z;
@end



@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCameraSession];
    
}

- (void)setupCameraSession
{    
    ICLog;
    
    //: 캡쳐 세션 만들기
    AVCaptureSession *session = [AVCaptureSession new];    
    [session setSessionPreset:AVCaptureSessionPresetLow];        
    
    //: 영상 캡쳐 장치 만들기
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    
    //: 영상 캡쳐 장치를 캡쳐 세션의 입력으로 설정하기
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
	if ( [session canAddInput:deviceInput] )
		[session addInput:deviceInput];
    
    //: 캡쳐 프리뷰 레이어 설정하기
	AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];    
    [previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CALayer *rootLayer = [[self view] layer];
	[rootLayer setMasksToBounds:YES];
	[previewLayer setFrame:CGRectMake(-70, 0, rootLayer.bounds.size.height, rootLayer.bounds.size.height)];
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    //: 프리뷰 레이어에 애니메이션 설정하기
    [previewLayer addAnimation:[self animationForRotationX:0.5 Y:0.5 andZ:0.5] forKey:@"rotation"];

    //: 캡쳐 시작
    //: 인풋에서 아웃풋으로 데이터의 흐름이 시작된다.
    //: 러닝이 성공하든지 혹은 실패할때까지 블럭된다.
    [session startRunning];
    
    
    //: 현재 캡쳐세션에 아웃풋은 붙어 있지 않다.
    //: 카메라에서 영상 데이터가 프리뷰레이어까지 흐른다.
    //: 그러면서 동시에 프리뷰레이어에 애니메이션이 10000번 실행된다.
    //: 영상 데이터에 변환이 가해지는 것이 아니라 프리뷰의 지오메트리에 변환이 적용되는 것이다.
}


- (CAAnimation *)animationForRotationX:(float)x Y:(float)y andZ:(float)z
{
    CATransform3D transform;
    transform = CATransform3DMakeRotation(M_PI, x, y, z);
    
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:transform];
    animation.duration = 2;
    animation.cumulative = YES;
    animation.repeatCount = 10000;
    return animation;
}     

@end
