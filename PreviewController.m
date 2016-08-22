//
//  
//  iDrift
//
//  Created by Sophie Jeong on 6/27/16.
//  Copyright © 2016 CarnegieMellonUniversity. All rights reserved.
//ref from many stackOverflow blogs and course example

#import <Foundation/Foundation.h>
#import "PreviewController.h"
#import "Reachability.h"


@interface PreviewController()


@end

@implementation PreviewController

-(void)viewDidLoad{
    
    [self.fullImageView setImage:_displayImage];
    self.fullImageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size= self->_displayImage.size};
    
}

-(void) viewWillDisappear:(BOOL)animated {
    
    [self->_fullImageView setImage:nil];
    
}

+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

- (IBAction)onSaveButtonClicked:(id)sender {
    
    NSDate *date = [[NSDate alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSString *OSVersion = (NSString *)[[UIDevice currentDevice] systemVersion];
    
    NSString *DeviceInfo = (NSString *)[[UIDevice currentDevice] model];
    
    NSString *andrewID = @"ckovvuri";
    NSLog(@"Device Info > %@:%@ %@:%@ ",andrewID,DeviceInfo,OSVersion,dateString);
    
    [PHPhotoLibrary requestAuthorization:^( PHAuthorizationStatus status ) {
        if ( status == PHAuthorizationStatusAuthorized ) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                
                
                [PHAssetChangeRequest creationRequestForAssetFromImage:self->_displayImage];
            } completionHandler:^( BOOL success, NSError *error ) {
                if ( ! success ) {
                    NSLog( @"Error occurred while saving image to photo library: %@", error );
                }
            }];
        }
    }];
    
    
}

- (IBAction)onTweetImagePressed:(id)sender {
   
    ACAccountStore *twitter = [[ACAccountStore alloc] init];
    
    ACAccountType *twAccountType = [twitter accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [twitter requestAccessToAccountsWithType:twAccountType options:nil completion:^(BOOL granted, NSError *error)
     { ACAccount *twAccount = [[ACAccount alloc] initWithAccountType:twAccountType];
         NSArray *accounts = [twitter accountsWithAccountType:twAccountType];
         Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
         NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
         if (networkStatus == NotReachable) {
             NSLog(@"Network connection not available");
             UIAlertView *noAccountAlert = [[UIAlertView alloc] initWithTitle:@"Sorry, No Internet Connection"
                                                                      message:@"Your Internet connection is not available"
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
             
             [noAccountAlert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
             
         }
         
         if (granted)
         {
             // Create an Account
             //             ACAccount *twAccount = [[ACAccount alloc] initWithAccountType:twAccountType];
             //             NSArray *accounts = [twitter accountsWithAccountType:twAccountType];
             
             if ([accounts count] > 0)
             {
                 twAccount = [accounts lastObject];
                 
                 // Version 1.1 of the Twitter API only supports JSON responses.
                 // Create an NSURL instance variable that points to the home_timeline end point.
                 NSURL *twitterURL = [[NSURL alloc] initWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
                 
                 /*
                  Version 1.0 of the Twiter API supports XML responses.
                  Use this URL if you want to see an XML response.
                  NSURL *twitterURL2 = [[NSURL alloc] initWithString:@"http://api.twitter.com/1/statuses/home_timeline.xml"];
                  */
                 
                 //             // Create a request
                 //             SLRequest *requestUsersTweets = [SLRequest requestForServiceType:SLServiceTypeTwitter
                 //                                                                requestMethod:SLRequestMethodPOST
                 //                                                                          URL:twitterURL
                 //                                                                   parameters:nil];
                 //
                 //             // Set the account to be used with the request
                 //             [requestUsersTweets setAccount:twAccount];
                 
                 
                 //             if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
                 //             {
                 //                 SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                 //                 NSString *Id = @"AndrewId:ckovvuri ";
                 //                 self.checkinString = [Id stringByAppendingString:_currentTime1.text];
                 //                 self.checkinString = [_checkinString stringByAppendingString:@" "];
                 //                 self.checkinString = [_checkinString stringByAppendingString:_devicemodel.text];
                 //                 NSLog(@ "%@",self.checkinString);
                 //                 [tweetSheet setInitialText: self.checkinString];
                 //
                 //                 [self presentViewController:tweetSheet animated:YES completion:nil];
                 //
                 //             }
                 NSString *Id = @"[AndrewId:ckovvuri] ";
                 self.checkinString =[@"@MobileApp4 " stringByAppendingString:Id];
                 NSDate *date = [[NSDate alloc]init];
                 
                 //Declare Date Formatter to format date according to problem
                 
                 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                 
                 [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
                 
                 NSString *dateString = [dateFormatter stringFromDate:date];
                 
                 NSString *OSVersion = (NSString *)[[UIDevice currentDevice] systemVersion];
                 
                 NSString *DeviceInfo = (NSString *)[[UIDevice currentDevice] model];
                 self.checkinString = [_checkinString stringByAppendingString:dateString];
                 self.checkinString = [_checkinString stringByAppendingString:@" "];
                 self.checkinString = [_checkinString stringByAppendingString:DeviceInfo];
                 NSLog(@ "%@",self.checkinString);
                 NSDictionary *message = @{@"status": _checkinString};
                 NSURL *requestURL = [[NSURL alloc] initWithString:@"https://api.twitter.com/1.1/statuses/update_with_media.json"];
                 
                 //Get image data
                 NSData *data = UIImageJPEGRepresentation(_displayImage, 0.8);
//                 if ([_displayImage isKindOfClass:[UIImage class]]) {
//                     data = UIImagePNGRepresentation(_displayImage);
//                 }
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodPOST
                                           URL:requestURL parameters:message];
                 
                 //Setup upload TW request
                 [postRequest addMultipartData:data withName:@"media" type:@"image/png" filename:@"image.png"];
//                 SLRequest *postRequest = [SLRequest
//                                           requestForServiceType:SLServiceTypeTwitter
//                                           requestMethod:SLRequestMethodPOST
//                                           URL:twitterURL parameters:message];
                 
                 postRequest.account = twAccount;
                 
                 [postRequest
                  performRequestWithHandler:^(NSData *responseData,
                                              NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      NSLog(@"Twitter HTTP response: %i",
                            [urlResponse statusCode]);
                      if([urlResponse statusCode] ==200)
                      {
                          UIAlertView *alertView = [[UIAlertView alloc]
                                                    initWithTitle:@"Sucess"
                                                    message:@"Your Tweet has been sucessfully posted"
                                                    delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
                          [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                      }
                      else if ([urlResponse statusCode] ==400)
                      {
                          UIAlertView *alertView = [[UIAlertView alloc]
                                                    initWithTitle:@"Bad Request"
                                                    message:@"requests without authentication"
                                                    delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
                          [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                      }
                      else if ([urlResponse statusCode] ==401)
                      {
                          UIAlertView *alertView = [[UIAlertView alloc]
                                                    initWithTitle:@"UnAuthorized"
                                                    message:@"Invalid or expired token"
                                                    delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
                          [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                      }
                      else if ([urlResponse statusCode] ==403)
                      {
                          UIAlertView *alertView = [[UIAlertView alloc]
                                                    initWithTitle:@"Forbidden"
                                                    message:@"Invalidate, credentials do not allow access to resource"
                                                    delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
                          [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                      }
                      else if ([urlResponse statusCode] ==404)
                      {
                          UIAlertView *alertView = [[UIAlertView alloc]
                                                    initWithTitle:@"Not Found"
                                                    message:@"Not Found"
                                                    delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
                          [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                      }
                      else if ([urlResponse statusCode] ==500)
                      {
                          UIAlertView *alertView = [[UIAlertView alloc]
                                                    initWithTitle:@"Server Error"
                                                    message:@"Server Unable to connect"
                                                    delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
                          [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                      }
                  }];
                 
             }
             
             else
             {
                 UIAlertView *alertView = [[UIAlertView alloc]
                                           initWithTitle:@"Sorry"
                                           message:@"You can't send a tweet right now, make sure you have at least one Twitter account setup on your device"
                                           delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
                 [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
             }
             
         }
         // If permission is not granted to use the Twitter account...
         
         else
             
         {
             UIAlertView *alertView = [[UIAlertView alloc]
                                       initWithTitle:@"Sorry"
                                       message:@"Permission Not Granted, make sure you have given twitter access"
                                       delegate:self
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
             [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
             NSLog(@"Permission Not Granted");
             NSLog(@"Error: %@", error);
         }
     }];

    
}

-(void)twitterExceptionHandling:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!!!" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"User pressed Cancel");
                                   }];
    
    UIAlertAction *settingsAction = [UIAlertAction
                                     actionWithTitle:NSLocalizedString(@"Settings", @"Settings action")
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action)
                                     {
                                         NSLog(@"Settings Pressed");
                                         
                                         //code for opening settings app in iOS 8
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                         
                                     }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:settingsAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}





@end