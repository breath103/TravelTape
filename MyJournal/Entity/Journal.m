//
//  Journal.m
//  MyJournal
//
//  Created by 상현 이 on 12. 9. 2..
//  Copyright (c) 2012년 상현 이. All rights reserved.
//

#import "Journal.h"

@implementation Journal
@synthesize name;
@synthesize startTime;
@synthesize endTime;
@synthesize contents;
-(id) init
{
    self = [super init];
    if(self)
    {
        contents = [NSMutableArray new];
    }
    return self;
}
-(void) addContent:(JournalContent *)content
{
    [self.contents addObject:content];
}
@end
