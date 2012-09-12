//
//  Journal.h
//  MyJournal
//
//  Created by 상현 이 on 12. 9. 2..
//  Copyright (c) 2012년 상현 이. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JournalContent.h"
@interface Journal : NSObject
@property(strong,nonatomic) NSString* name;
@property(strong,nonatomic) NSDate* startTime;
@property(strong,nonatomic) NSDate* endTime;
@property(strong,nonatomic) NSMutableArray* contents;
-(void) addContent : (JournalContent*) content;
@end
