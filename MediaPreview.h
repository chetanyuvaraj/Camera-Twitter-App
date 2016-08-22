//
//  AssetLibraryViewController.h
//  iDrift
//
//  Created by Sophie Jeong on 6/27/16.
//  Copyright © 2016 CarnegieMellonUniversity. All rights reserved.
//ref from many stackOverflow blogs and course example

#import  <UIKit/UIKit.h>

@class AVCaptureSession;

@interface MediaPreview : UIView

@property (nonatomic) AVCaptureSession *session;

@end

