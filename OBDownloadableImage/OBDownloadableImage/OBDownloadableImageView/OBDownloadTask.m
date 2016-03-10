//
//  OBDownloadTask.m
//  OBDownloadableImage
//
//  Created by Omer Blumenkrunz on 10/03/2016.
//  Copyright © 2016 Omer Blumenkrunz. All rights reserved.
//

#import "OBDownloadTask.h"


#define  kOBTimeoutIntervalForRequest  30.0
#define  kOBTimeoutIntervalForResource 60.0



@interface OBDownloadTask()
@property(strong,nonatomic) NSURLSessionDownloadTask  *getImageTask;
@end


@implementation OBDownloadTask:NSObject

- (void)downloadTaskWithURL:(NSURL *)url completionHandler:(void (^)(NSURL * location, NSURLResponse * response, NSError * error))completionHandler
{
    if(url == nil || completionHandler == nil)
    {
        return;
    }
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    sessionConfig.timeoutIntervalForRequest  =  kOBTimeoutIntervalForRequest;
    sessionConfig.timeoutIntervalForResource =  kOBTimeoutIntervalForResource;
    
    NSURLSession *session =  [NSURLSession sessionWithConfiguration:sessionConfig];
    
    self.getImageTask =   [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *nserror)
                           {
                               if(completionHandler != nil)
                               {
                                   completionHandler(location,response,nserror);
                               }
                           }];
}
- (void)resume
{
    [self.getImageTask resume];
}
- (void)cancel
{
    [self.getImageTask cancel];
    
}
@end