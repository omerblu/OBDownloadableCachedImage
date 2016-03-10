//
//  OBDownloadTaskFake.m
//  OBDownloadableImage
//
//  Created by Omer Blumenkrunz on 10/03/2016.
//  Copyright © 2016 Omer Blumenkrunz. All rights reserved.
//
#import "OBDownloadTaskFake.h"

@interface OBDownloadTaskFake()
@property (strong,nonatomic)    NSURL *   url;
@property (strong,nonatomic)    dispatch_queue_t downloaderTaskQueue;
@end

@implementation OBDownloadTaskFake
@synthesize waitTime;
@synthesize downloadFileURL;
@synthesize downloadSuccessfully;
@synthesize httpError;
@synthesize completionHandler;


- (void)downloadTaskWithURL:(NSURL * __unused)url completionHandler:(void __unused (^ )(NSURL *  location, NSURLResponse *  response, NSError *  error))aCompletionHandler
{
    self.completionHandler = aCompletionHandler;
    self.url = url;
    self.downloaderTaskQueue = dispatch_queue_create("OBImageDownloaderTaskeFakeQueue", DISPATCH_QUEUE_SERIAL);
}

- (void)resume
{
    dispatch_async(self.downloaderTaskQueue,^{
        if(self.waitTime > 0)
        {
            [NSThread sleepForTimeInterval:self.waitTime];
        }
        
        if(self.downloadSuccessfully == YES)
        {
            NSURLResponse * response = [[NSHTTPURLResponse alloc] initWithURL:self.url statusCode:200 HTTPVersion:nil headerFields:@{}];
            if(self.completionHandler != nil)
            {
                self.completionHandler(self.downloadFileURL ,response , nil);
            }
            return;
        }
        
        if(self.downloadSuccessfully == NO && self.httpError == NO)
        {
            NSURLResponse * response = [[NSHTTPURLResponse alloc] initWithURL:self.url statusCode:200 HTTPVersion:nil headerFields:@{}];
            NSError * err = [NSError errorWithDomain:@"OB.IMAGEDOWNLODER.FAKE" code:200 userInfo:nil];
            if(self.completionHandler != nil)
            {
                self.completionHandler(nil ,response , err);
            }
            return;
        }
        
        if(self.httpError == YES)
        {
            NSURLResponse * response = [[NSHTTPURLResponse alloc] initWithURL:self.url statusCode:404 HTTPVersion:nil headerFields:@{}];
            if(self.completionHandler != nil)
            {
                self.completionHandler(nil ,response , nil);
            }
            return;
        }
    });
}
- (void)cancel
{
    self.completionHandler = nil;
}

@end