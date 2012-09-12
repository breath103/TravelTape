//
//  JournalViewController.m
//  MyJournal
//
//  Created by 상현 이 on 12. 9. 3..
//  Copyright (c) 2012년 상현 이. All rights reserved.
//

#import "JournalViewController.h"

@interface JournalViewController ()

@end

@implementation JournalViewController
@synthesize journal;
@synthesize mapView;
- (IBAction)onUploadButton:(id)sender {
}

-(id) initWithJournal : (Journal*) pJournal
{
    self = [super initWithNibName:@"JournalViewController" bundle:NULL];
    if(self){
        journal = pJournal;
    }
    return self;
}

- (IBAction)onAddButton:(id)sender {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
