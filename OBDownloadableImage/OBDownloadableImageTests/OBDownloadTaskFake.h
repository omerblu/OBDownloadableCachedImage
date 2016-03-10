//
//  OBDownloadTaskFake.h
//  OBDownloadableImage
//
//  Created by Omer Blumenkrunz on 10/03/2016.
//  Copyright © 2016 Omer Blumenkrunz. All rights reserved.
//
#import "OBDownloadTaskProtocol.h"

typedef void (^OBDownloadTaskFakeCompletionHandler)(NSURL *  location, NSURLResponse *  response, NSError *  error);

@interface OBDownloadTaskFake : NSObject <OBDownloadTaskProtocol>
@property (assign,nonatomic) BOOL downloadSuccessfully;
@property (assign,nonatomic) BOOL httpError;
@property (strong,nonatomic) NSURL * downloadFileURL;
@property (assign,nonatomic) NSTimeInterval  waitTime;
@property (strong,nonatomic) OBDownloadTaskFakeCompletionHandler  completionHandler;
@end