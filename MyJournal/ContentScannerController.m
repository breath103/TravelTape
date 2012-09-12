//
//  ContentScannerViewController.m
//  MyJournal
//
//  Created by 상현 이 on 12. 9. 3..
//  Copyright (c) 2012년 상현 이. All rights reserved.
//

#import "ContentScannerController.h"
#import "PhotoPickingView/PhotoPickerController.h"
#import "ViewController.h"
#import "UELib/UEImageLibrary.h"
#import "NSObject+block.h"
@interface ContentScannerController ()

@end

@implementation ContentScannerController
@synthesize assetScanner;
@synthesize photoScrollView;
-(id) initWithStartDate : (NSDate*) startDate
                endDate : (NSDate*) endDate
{
    self = [super initWithNibName:@"ContentScannerController" bundle:NULL];
    if(self){
        self.assetScanner = [[UEAssetsScanner alloc] initWithStartDate : startDate
                                                               endDate : endDate
                                                              delegate : self];
        [self.assetScanner startScan];
    }
    return self;
}
-(void) UEAssetsScanner : (UEAssetsScanner *)scanner
           didScanEnded : (NSMutableArray *)resultArray
{
    NSLog(@"%@\n%@",scanner,resultArray);
    //스캔이 끝남.

    int index = 0;
    for(ALAsset* asset in resultArray){
        int gridSize = PHOTO_TABLE_GRID_SIZE;
        CGSize photoViewSize = CGSizeMake(320/gridSize,320/gridSize);
        CGRect photoViewRect = CGRectMake(index%gridSize * photoViewSize.width,index/gridSize * photoViewSize.height,
                                          photoViewSize.height,photoViewSize.width);
        PhotoView* photoView = [[PhotoView alloc]initWithFrame : photoViewRect
                                                    photoAsset : asset];
        [self.photoScrollView addSubview:photoView];
        index ++;
    }

    self.photoScrollView.contentSize = CGSizeMake(self.photoScrollView.frame.size.width,
                                                  (resultArray.count / PHOTO_TABLE_GRID_SIZE + 1 ) * 320/PHOTO_TABLE_GRID_SIZE);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    photoScrollView = NULL;
    assetScanner    = NULL;
    [super viewDidUnload];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) onRegisterPhotoEnd
{

}

- (IBAction)onTouchRegisterPhoto:(id)sender {
    
    uploadingAlertView = [[UIAlertView alloc] initWithTitle:@"Uploading.."
                                                    message:NULL
                                                   delegate:NULL
                                          cancelButtonTitle:NULL
                                          otherButtonTitles:NULL];
    uploadingProgressView= [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [uploadingAlertView addSubview:uploadingProgressView];
    uploadingProgressView.frame = CGRectMake(12.0, 45.0, 260.0, 25.0);
    
    [uploadingAlertView show];
    [self performBlockInBackground:^{
        int index = 0;
        for(ALAsset* asset in assetScanner.resultAssets)
        {
            ViewController* viewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
            [viewController addPinWithAsset:asset];
            NSLog(@"%d / %d",index++,assetScanner.resultAssets.count);
            
            [self performBlockInMainThread:^{
                uploadingProgressView.progress = (float)index / assetScanner.resultAssets.count;
            } waitUntilDone:TRUE];
        }
        [self performBlockInMainThread:^{
            [uploadingAlertView dismissWithClickedButtonIndex:0 animated:TRUE];
            [self.navigationController popViewControllerAnimated:TRUE];
        } waitUntilDone:TRUE];
    }];
    
}
@end
