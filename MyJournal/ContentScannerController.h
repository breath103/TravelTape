//
//  ContentScannerViewController.h
//  MyJournal
//
//  Created by 상현 이 on 12. 9. 3..
//  Copyright (c) 2012년 상현 이. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UELib/UEAssets.h"

@interface ContentScannerController : UIViewController<UEAssetsScannerDelegate>
{
    UIAlertView*    uploadingAlertView;
    UIProgressView* uploadingProgressView;
}
@property (nonatomic,strong) UEAssetsScanner* assetScanner;
@property (nonatomic,weak) IBOutlet UIScrollView *photoScrollView;
-(id) initWithStartDate : (NSDate*) startDate
                endDate : (NSDate*) endDate;
- (IBAction)onTouchRegisterPhoto:(id)sender;
@end
