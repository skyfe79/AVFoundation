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
    
    // Session
    AVCaptureSession *session = [AVCaptureSession new];    
    [session setSessionPreset:AVCaptureSessionPresetLow];        
    
    // Capture device
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    
    // Device input
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
	if ( [session canAddInput:deviceInput] )
		[session addInput:deviceInput];
    
    // Preview
	AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];    
    [previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CALayer *rootLayer = [[self view] layer];
	[rootLayer setMasksToBounds:YES];
	[previewLayer setFrame:CGRectMake(-70, 0, rootLayer.bounds.size.height, rootLayer.bounds.size.height)];
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    [previewLayer addAnimation:[self animationForRotationX:0.5 Y:0.5 andZ:0.5] forKey:@"rotation"];

    [session startRunning];
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
