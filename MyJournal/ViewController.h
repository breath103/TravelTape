//
//  ViewController.h
//  MyJounal
//
//  Created by 상현 이 on 12. 8. 30..
//  Copyright (c) 2012년 상현 이. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ContentScannerController.h"
#import "Entity/Journal.h"
#import "JournalTransportManager.h"

@interface ViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,
                                             JournalTransportManagerDelegate>
{
    JournalTransportManager* journalTransportManager;
}
@property (strong,nonatomic) CLLocationManager* locationManager;
@property (strong,nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) ContentScannerController* contentScannerController;
@property (strong,nonatomic) Journal* journal;

- (IBAction)onTouchButton:(id)sender;
- (IBAction)onTouchUploadButton:(id)sender;
- (void) addPinWithAsset : (ALAsset*) asset;


@end
