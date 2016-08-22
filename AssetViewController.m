//
//  AssetViewController.m
//  iDrift
//
//  Created by Sophie Jeong on 6/27/16.
//  Copyright © 2016 CarnegieMellonUniversity. All rights reserved.
//

#import "AssetViewController.h"

@interface AssetViewController ()

@end

@implementation AssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        [self.assetImageView setImage:self.assetImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
