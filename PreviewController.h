//
//  
//  iDrift
//
//  Created by Sophie Jeong on 6/27/16.
//  Copyright © 2016 CarnegieMellonUniversity. All rights reserved.
//ref from many stackOverflow blogs and course example

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface PreviewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *fullImageView;

@property (weak, nonatomic) IBOutlet UINavigationBar *fullImageTopBar;

@property (weak, nonatomic) IBOutlet UINavigationItem *fullImageLabel;

@property (nonatomic, strong) UIImage *displayImage;
@property (strong, nonatomic) NSString *checkinString;

@property (nonatomic, strong) ALAsset *assetInfo;



@end
