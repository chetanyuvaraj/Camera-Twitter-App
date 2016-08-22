//
//  AssetGroupViewController.m
//  iDrift
//
//  Created by Sophie Jeong on 6/27/16.
//  Copyright © 2016 CarnegieMellonUniversity. All rights reserved.
//

#import "AssetGroupViewController.h"
#import "AssetViewController.h"
#import "AssetGroupTableCell.h"

@interface AssetGroupViewController ()
- (void)retrieveAssetGroupByURL;
- (void)enumerateGroupAssetsForGroup:(ALAssetsGroup *)group;
@end

@implementation AssetGroupViewController

+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Do any additional setup after loading the view.
    [self setTitle:self.assetGroupName];
    
    NSRange cameraRollLoc =
    [self.assetGroupName rangeOfString:@"Camera Roll"];
    
    if (cameraRollLoc.location == NSNotFound)
    {
        
        NSLog(@"not Camera Roll Found");
    }
    
    ALAssetsLibrary *setupAssetsLibrary =
    [[ALAssetsLibrary alloc] init];
    
    [self setAssetsLibrary:setupAssetsLibrary];
    
    NSMutableArray *setupArray = [[NSMutableArray alloc] init];
    [self setAssetArray:setupArray];
    
    [self retrieveAssetGroupByURL];
}
-(void)viewDidLoad{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ViewAssetImage"])
    {
        NSInteger indexForAsset = [sender tag];
        
        ALAsset *selectedAsset =
        [_assetArray objectAtIndex:indexForAsset];
        
        AssetViewController *aVC =
        segue.destinationViewController;
        
        ALAssetRepresentation *rep =
        [selectedAsset defaultRepresentation];
        
        UIImage *img =
        [UIImage imageWithCGImage:[rep fullScreenImage]];
        NSString *tempString = [selectedAsset.defaultRepresentation filename];
        if (!(([tempString containsString:(@".MOV")]) || ([tempString containsString:(@".MP4")])||
              ([tempString containsString:(@".mov")]) || ([tempString containsString:(@".mp4")]))) {
            [aVC setAssetImage:img];
        }
        else {
            [self playVideo:rep];
        }
        
    }
}
-(void) playVideo:(ALAssetRepresentation *)defaultRepresentation {
    
    MPMoviePlayerViewController *theMovieController=[[MPMoviePlayerViewController alloc] initWithContentURL:defaultRepresentation.url] ;
    
    [theMovieController.view setFrame:CGRectMake(0, 44, 320, 270)];
    
    [theMovieController.view setTransform:CGAffineTransformMakeRotation(M_PI_2)];
    
    [self.view addSubview: theMovieController.view];
    _mp = [theMovieController moviePlayer];
    [_mp prepareToPlay];
    _mp.controlStyle = MPMovieControlStyleEmbedded;
    [_mp setFullscreen:YES animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinishedCallback:)
     
                                                 name:MPMoviePlayerPlaybackDidFinishNotification object:_mp];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinishedCallback:)
     
                                                 name:MPMoviePlayerWillExitFullscreenNotification object:_mp];
    
    [_mp play];
    
}

- (void)playbackFinishedCallback:(NSNotification *)notification {
    
    MPMoviePlayerController *mpController = [notification object];
    MPMoviePlayerViewController *mpViewController = [notification object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:mpController];
    
    [mpController stop];
    
    mpController = nil;
    
    [mpViewController.view removeFromSuperview];
}


#pragma mark - Table methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSInteger returnCount = 0;
    
    if (_assetArray && ([_assetArray count] > 0))
    {
        if ([_assetArray count] % 4 == 0)
        {
            returnCount = ([_assetArray count] / 4);
        }
        else
        {
            returnCount = ([_assetArray count] / 4) + 1;
        }
    }
    return returnCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"AssetGroupTableCell";
    AssetGroupTableCell *cell = (AssetGroupTableCell *)
    [tableView dequeueReusableCellWithIdentifier:cellID];
    
    ALAsset *firstAsset =
    [_assetArray objectAtIndex:indexPath.row * 4];
    
    [cell.assetButton1 setImage:
     [UIImage imageWithCGImage:[firstAsset thumbnail]]
                       forState:UIControlStateNormal];
    
    [cell.assetButton1 setTag:indexPath.row * 4];
    
    if (indexPath.row * 4 + 1 < [_assetArray count])
    {
        ALAsset *secondAsset =
        [_assetArray objectAtIndex:indexPath.row * 4 + 1];
        
        [cell.assetButton2 setImage:
         [UIImage imageWithCGImage:[secondAsset thumbnail]]
                           forState:UIControlStateNormal];
        
        [cell.assetButton2 setTag:indexPath.row * 4 + 1];
        [cell.assetButton2 setEnabled:YES];
    }
    else
    {
        [cell.assetButton2 setImage:nil
                           forState:UIControlStateNormal];
        
        [cell.assetButton2 setEnabled:NO];
    }
    
    if (indexPath.row * 4 + 2 < [_assetArray count])
    {
        ALAsset *thirdAsset =
        [_assetArray objectAtIndex:indexPath.row * 4 + 2];
        
        [cell.assetButton3 setImage:
         [UIImage imageWithCGImage:[thirdAsset thumbnail]]
                           forState:UIControlStateNormal];
        
        [cell.assetButton3 setTag:indexPath.row * 4 + 2];
        [cell.assetButton3 setEnabled:YES];
    }
    else
    {
        [cell.assetButton3 setImage:nil
                           forState:UIControlStateNormal];
        
        [cell.assetButton3 setEnabled:NO];
    }
    
    if (indexPath.row * 4 + 3 < [_assetArray count])
    {
        ALAsset *fourthAsset =
        [_assetArray objectAtIndex:indexPath.row * 4 + 3];
        
        [cell.assetButton4 setImage:
         [UIImage imageWithCGImage:[fourthAsset thumbnail]]
                           forState:UIControlStateNormal];
        
        [cell.assetButton4 setTag:indexPath.row * 4 + 3];
        [cell.assetButton4 setEnabled:YES];
    }
    else
    {
        [cell.assetButton4 setImage:nil
                           forState:UIControlStateNormal];
        
        [cell.assetButton4 setEnabled:NO];
    }
    
    return cell;
}

#pragma mark - Asset Methods

- (void)retrieveAssetGroupByURL
{
    void (^retrieveGroupBlock)(ALAssetsGroup*) =
    ^(ALAssetsGroup* group)
    {
        if (group)
        {
            [self enumerateGroupAssetsForGroup:group];
        }
        else
        {
            NSLog(@"Error. Can't find group!");
        }
    };
    
    void (^handleAssetGroupErrorBlock)(NSError*) =
    ^(NSError* error)
    {
        NSString *errMsg = @"Error accessing group";
        
        UIAlertView* alertView =
        [[UIAlertView alloc] initWithTitle:nil
                                   message:errMsg
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        
        [alertView show];
    };
    
    [self.assetsLibrary groupForURL:self.assetGroupURL
                        resultBlock:retrieveGroupBlock
                       failureBlock:handleAssetGroupErrorBlock];
}

- (void)enumerateGroupAssetsForGroup:(ALAssetsGroup *)group
{
    NSInteger lastIndex = [group numberOfAssets] - 1;
    
    void (^addAsset)(ALAsset*, NSUInteger, BOOL*) =
    ^(ALAsset* result, NSUInteger lastIndex, BOOL* stop)
    {
        if (result != nil)
        {
            [self.assetArray addObject:result];
        }
        
        if (lastIndex) {
            [self.assetTableView reloadData];
        }
    };
    
    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:addAsset];
    
}


@end
