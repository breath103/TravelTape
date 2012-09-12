//
//  JournalContent.m
//  MyJournal
//
//  Created by 상현 이 on 12. 9. 2..
//  Copyright (c) 2012년 상현 이. All rights reserved.
//

#import "JournalContent.h"
#import "../UELib/UEAssets.h"

@implementation JournalContent
@synthesize longitude;
@synthesize latitude;
@synthesize facebookID;

@synthesize asset;

-(NSString*) description
{
    return [NSString stringWithFormat:@"%f,\n %f,\n %@,\n %@",latitude.doubleValue,longitude.doubleValue,facebookID,asset];
}

-(CLLocationCoordinate2D) toCoordinate
{
    return CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
}
-(NSDate*) getCreatedDate
{
    return [asset valueForProperty:ALAssetPropertyDate];
}

@end
