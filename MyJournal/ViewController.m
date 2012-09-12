//
//  ViewController.m
//  MyJounal
//
//  Created by 상현 이 on 12. 8. 30..
//  Copyright (c) 2012년 상현 이. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "UELib/UEImageLibrary.h"
#import "SBJSON/JSON.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UELib/UEAssets.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize locationManager;
@synthesize mapView;
@synthesize contentScannerController;
@synthesize journal;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    journalTransportManager = [[JournalTransportManager alloc] init];
    journalTransportManager.delegate = self;

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd KK:mm:ss"];
    NSDate* startDate = [ df dateFromString:@"2012-08-01 09:05:01"];
    NSDate* endDate   = [ df dateFromString:@"2012-09-01 09:05:01"];
    
    journal = [[Journal alloc] init];
    journal.name = @"TEST JOURNAL";
    journal.startTime = startDate;
    journal.endTime   = endDate;
    
    
    // if the session is open, then load the data for our view controller
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here, and establish a handler for state changes
        // if the session isn't open, we open it here, which may cause UX to log in the user
        NSArray* permissions = [NSArray arrayWithObjects:@"user_photos",@"publish_stream",@"email"
                                ,@"read_stream",@"user_about_me",@"user_photos",@"publish_stream",@"read_friendlists",@"offline_access", nil];
        [FBSession openActiveSessionWithPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                      if (!error) {
                                          NSLog(@"%@",FBSession.activeSession.accessToken);
                                      } else {
                                          [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                      message:error.localizedDescription
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil]show];
                                      }
                                  }];
    }
    
    
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
    if([CLLocationManager significantLocationChangeMonitoringAvailable])
        [locationManager startMonitoringSignificantLocationChanges];
    else
        NSLog(@"Not Available for This Device");
}

- (void)viewDidUnload
{
    self.locationManager = NULL;
    self.mapView = NULL;
    self.contentScannerController = NULL;
    self.journal = NULL;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)locationManager : (CLLocationManager *) manager
	didUpdateToLocation : (CLLocation *) newLocation
		   fromLocation : (CLLocation *) oldLocation
{
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeStyle:NSDateFormatterMediumStyle];
    
	NSString *textStr  = [NSString stringWithFormat:@"(%@) %@ Location %.06f %.06f %@",@"bg" , @"sig" , newLocation.coordinate.latitude, newLocation.coordinate.longitude, [formatter stringFromDate:newLocation.timestamp]];
    
    MKPointAnnotation* annotation = [[MKPointAnnotation alloc]init];
    annotation.coordinate = newLocation.coordinate;
    [mapView addAnnotation:annotation];
    mapView.showsUserLocation = TRUE;
   
    NSLog(@"%@",textStr);
}

- (IBAction)onTouchButton:(id)sender {
    if(!self.contentScannerController)
        self.contentScannerController = [[ContentScannerController alloc] initWithStartDate : journal.startTime
                                                                                    endDate : journal.endTime];
    [self.navigationController pushViewController:self.contentScannerController animated:TRUE];
}


- (IBAction)onTouchUploadButton:(id)sender {
    NSLog(@"%@",journal.contents);
   [journalTransportManager uploadJournal:journal];
}

-(void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    NSLog(@"%@",view);
}
- (void) addPinWithAsset : (ALAsset*) asset
{
    @autoreleasepool {
        
    ALAssetRepresentation* defaultRepresentation = asset.defaultRepresentation;
    NSDictionary* gpsDict = [defaultRepresentation.metadata objectForKey:@"{GPS}"];
    if(gpsDict)
    {
        NSString* Latitude  = [gpsDict objectForKey:@"Latitude"];
        NSString* Longitude = [gpsDict objectForKey:@"Longitude"];
            
        MKPointAnnotation* annotation = [[MKPointAnnotation alloc]init];
        annotation.coordinate = CLLocationCoordinate2DMake(Latitude.doubleValue,Longitude.doubleValue);
        [mapView addAnnotation:annotation];
            
        MKAnnotationView* viewAnnotation = [mapView viewForAnnotation:annotation];
        viewAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        viewAnnotation.leftCalloutAccessoryView  = [UIButton buttonWithType:UIButtonTypeInfoDark];
            
            //       ALAssetRepresentation* defaultAssetRepresentation = asset.defaultRepresentation;
            /*
             UIImage* image    = [UEImageLibrary scaleAndRotateImage:UIImage imageWithCGImage:defaultAssetRepresentation.fullResolutionImage]:
             [UEImageLibrary irUIImageOrientationFromAssetOrientation:defaultAssetRepresentation.orientation]];
             viewAnnotation.image = image;
             viewAnnotation.enabled = TRUE;
             viewAnnotation.canShowCallout = TRUE;
             [viewAnnotation sizeToFit];
             */
        
        
        // 컨텐츠 추가
        JournalContent* journalContent = [[JournalContent alloc] init];
        journalContent.latitude  = [NSNumber numberWithDouble: Latitude.doubleValue];
        journalContent.longitude = [NSNumber numberWithDouble: Longitude.doubleValue];
        journalContent.asset = asset;
        [journal.contents addObject:journalContent];
    }
        
    }
}

-(void) JournalTransportManager : (JournalTransportManager *)manager
                uploadCompleted : (Journal *)journal
{
    NSLog(@"JOURNAL_LOAD_END");
}

@end

