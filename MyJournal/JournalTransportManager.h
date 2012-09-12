//
//  JournalTransportManager.h
//  MyJournal
//
//  Created by 상현 이 on 12. 9. 2..
//  Copyright (c) 2012년 상현 이. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entity/Journal.h"

#define SERVER_BASE_URL (@"http://breath103.cafe24.com/newMadeleine")
#define JOURNAL_UPLOAD_URL ([SERVER_BASE_URL stringByAppendingString:@"/journal/uploadJournal.m"])


@class JournalTransportManager;
@protocol JournalTransportManagerDelegate <NSObject>
-(void)JournalTransportManager : (JournalTransportManager*) manager
               uploadCompleted : (Journal*) journal;
@end


@interface JournalTransportManager : NSObject
{
    Journal* journal;
    NSMutableArray* notUploadedContents;
    NSMutableArray* uploadedContents;
    NSMutableArray* facebookRequestInProgress;
    int maxFBRequestCount; //동시에 전송할 수 있는 페이스북 리퀘스트 숫자
}
@property (nonatomic,strong) UIAlertView* uploadingAlertView;
@property (nonatomic,strong) UIProgressView* uploadingProgressView;
@property (nonatomic,weak) id<JournalTransportManagerDelegate> delegate ;
@property (atomic,readonly) BOOL isInLoading;

-(void) uploadJournal : (Journal*) journal;

@end
