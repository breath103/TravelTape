//
//  JournalViewController.h
//  MyJournal
//
//  Created by 상현 이 on 12. 9. 3..
//  Copyright (c) 2012년 상현 이. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Entity/Journal.h"

@interface JournalViewController : UIViewController
@property (strong,readonly) Journal* journal;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
-(id) initWithJournal : (Journal*) journal;
- (IBAction)onUploadButton:(id)sender;
- (IBAction)onAddButton:(id)sender;
@end
