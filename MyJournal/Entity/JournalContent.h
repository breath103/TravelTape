//
//  JournalContent.h
//  MyJournal
//
//  Created by 상현 이 on 12. 9. 2..
//  Copyright (c) 2012년 상현 이. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>

@interface JournalContent : NSObject
@property (strong,nonatomic) NSNumber* longitude;
@property (strong,nonatomic) NSNumber* latitude;
@property (strong,nonatomic) NSString* facebookID;
@property (strong,nonatomic) ALAsset* asset;

-(CLLocationCoordinate2D) toCoordinate;
-(NSDate*) getCreatedDate;
@end
