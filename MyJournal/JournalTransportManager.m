//
//  JournalTransportManager.m
//  MyJournal
//
//  Created by 상현 이 on 12. 9. 2..
//  Copyright (c) 2012년 상현 이. All rights reserved.
//

#import "JournalTransportManager.h"
#import "SBJSON/JSON.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ASI/ASIFormDataRequest.h"
#import "UELib/UEImageLibrary.h"
#import "macro.h"


@implementation JournalTransportManager
@synthesize delegate;
@synthesize isInLoading;
@synthesize uploadingAlertView;
@synthesize uploadingProgressView;
-(id) init{
    self = [super init];
    if(self){
        maxFBRequestCount = 2;
    }
    return self;
}


-(void) __log : ( NSString*) str
{
    NSLog(@"%@",str);
}
-(void) Log : ( NSString*) str
{
    [self performSelectorOnMainThread:@selector(__log:) withObject:str waitUntilDone:TRUE];
}


-(void) uploadJournal : (Journal*) pJournal
{
    // 1. 사진들을 모두 페이스북 앨범으로 올린다.
    // 2. 사진이 업로드 될때마다 반환되는 사진의 페이스북 아이디와 사진정보로부터 가져온 GPS정보를 연결한다
    // 3. 저널 자체에 대한 정보와 사진에 대한 정보를 함께 로컬 서버로 업로드 한다.
    isInLoading = true;
    self->journal = pJournal;
    
    uploadingAlertView = [[UIAlertView alloc] initWithTitle:@"Uploading.."
                                                  message:NULL
                                                 delegate:NULL
                                        cancelButtonTitle:NULL
                                        otherButtonTitles:NULL];
    uploadingProgressView= [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [uploadingAlertView addSubview:uploadingProgressView];
    [uploadingAlertView show];
    uploadingProgressView.frame = CGRectMake(12.0, 45.0, 260.0, 25.0);
    
    [self uploadJournalToFacebook];
    //[self performSelectorInBackground:@selector(uploadJournalToFacebook) withObject:self];
}
-(FBRequest*) facebookRequestWithContent : (JournalContent*) content
{
    @autoreleasepool {
    
    NSDictionary *dictPrivacy = [NSDictionary dictionaryWithObjectsAndKeys : @"CUSTOM",@"value",
                                 @"SELF"  ,@"friends", nil];
    SBJSON* jsonWriter = [SBJSON new];
    const NSString* privacyJSONStr =  [jsonWriter stringWithObject:dictPrivacy];
    
    //////////
    ALAssetRepresentation* assetRep = content.asset.defaultRepresentation;
    UIImage* image  = [UEImageLibrary imageFromAssetRepresentation:assetRep];
    image = [UEImageLibrary convertToJPEG:image withScale:0.3];
    
    NSDictionary* additionalData = [[NSDictionary alloc]initWithObjectsAndKeys:
                            [content.getCreatedDate description] , @"createdTime",
                                               content.longitude , @"longitude",
                                                content.latitude , @"latitude" ,nil];
    
    NSString *strMessage = [jsonWriter stringWithObject:additionalData];
    NSMutableDictionary* photosParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         image          ,@"source",
                                         strMessage     ,@"message",
                                         privacyJSONStr ,@"privacy",
                                         nil];
    return [FBRequest requestWithGraphPath : @"me/photos"
                                parameters : photosParams
                                HTTPMethod : @"POST"];
    
    }
}
-(void) generateAndStartFacebookRequestUntilLimit
{
    while(facebookRequestInProgress.count <= maxFBRequestCount &&
          notUploadedContents.count > 0)
    {
        JournalContent* content = [notUploadedContents lastObject];
        [notUploadedContents removeLastObject];
            
        FBRequest* contentRequest = [self facebookRequestWithContent:content];
        [facebookRequestInProgress addObject:contentRequest];
        
        [contentRequest startWithCompletionHandler:^(FBRequestConnection *connection,
                                                     id result,
                                                     NSError *error) {
            [facebookRequestInProgress removeObject:contentRequest];
            if (error) {
                NSLog(@"%@",error);
            }
            else{
                NSDictionary* resultDict = result;
                content.facebookID = [resultDict objectForKey:@"id"];
                [self onFacebookRequestCompleted : content];
            }
        }];
        NSLog(@"%d , %d , %d",notUploadedContents.count
                             ,uploadedContents.count
                             ,facebookRequestInProgress.count);
    }
}
-(void) uploadJournalToFacebook
{
    NSLog(@"uploadJournalToFacebook : !");
    
    notUploadedContents       = [journal.contents mutableCopy];
    uploadedContents          = [NSMutableArray new];
    facebookRequestInProgress = [NSMutableArray new];
    
    // 1
    [self generateAndStartFacebookRequestUntilLimit];
    /*
    for(JournalContent* content in journal.contents){
        FBRequest* photoRequest = [self facebookRequestWithContent:content];
        [photoRequest startWithCompletionHandler:^(FBRequestConnection *connection,
                                                   id result,
                                                   NSError *error){
            if (error) {
                NSLog(@"%@",error);
            }
            else{
                NSDictionary* resultDict = result;
                content.facebookID = [resultDict objectForKey:@"id"];
                [self onFacebookRequestCompleted : content];
            }
        }];
    }
     */
}
-(void) onFacebookRequestCompleted : (JournalContent*) content
{
    NSLog(@"content uploaded : %@",content);
    
    
    [uploadedContents addObject:content];
    
    
    uploadingProgressView.progress = (double)uploadedContents.count / journal.contents.count;
    
    //마지막 사진의 업로드가 끝난경우
    if(uploadedContents.count >= journal.contents.count)
    {
        //[self Log:@"facebook Upload ALL COMPLETED"];
        NSLog(@"facebook Upload ALL COMPLETED");
        [self onFacebookUploadCompleted];
    }
    else
    {
        [self generateAndStartFacebookRequestUntilLimit];
    }
}

// 2단계. 페북에 업로드가 끝난뒤에 우리쪽 서버에 업로드를 시작
-(void) onFacebookUploadCompleted
{
    for(JournalContent* journalContent in journal.contents)
    {
        //NSLog(@"%@",journalContent);
        
        //서버 정리가 안된관계로 일단 1단계만 실행
        /*
        ASIFormDataRequest* request = NULL;
        @autoreleasepool {
            request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:JOURNAL_UPLOAD_URL]];
            [request addPostValue:journal.name forKey:@"name"];
            request.stringEncoding = NSUTF8StringEncoding;
            
            [request setCompletionBlock:^{
                
            }];
            [request startAsynchronous]; //비동기 전송 시작
        }
         */
    }
    
    isInLoading = false;
    [uploadingAlertView dismissWithClickedButtonIndex:0 animated:TRUE];
    [self.delegate JournalTransportManager : self
                           uploadCompleted : journal];
}
@end
