//
//  
//  iDrift
//
//  Created by Sophie Jeong on 6/27/16.
//  Copyright © 2016 CarnegieMellonUniversity. All rights reserved.
//ref from many stackOverflow blogs and course example


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface TwitterDisplayView : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *displayTweetWebView;

@property (weak,nonatomic) NSURL *imageURL;
@end