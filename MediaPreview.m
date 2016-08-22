//
//  AssetLibraryViewController.h
//  iDrift
//
//  Created by Sophie Jeong on 6/27/16.
//  Copyright © 2016 CarnegieMellonUniversity. All rights reserved.
//ref from many stackOverflow blogs and course example

#import "Foundation/Foundation.h"
@import AVFoundation;

#import "MediaPreview.h"

@implementation MediaPreview

+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    return previewLayer.session;
}

- (void)setSession:(AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    previewLayer.session = session;
}

@end
