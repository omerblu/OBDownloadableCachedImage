//
//  OBDownloadTaskProtocol.h
//  OBDownloadableImage
//
//  Created by Omer Blumenkrunz on 10/03/2016.
//  Copyright © 2016 Omer Blumenkrunz. All rights reserved.
//

/**
 @protocol OBDownloadTaskProtocol
 @discussion Wrappes system API - NSURLSessionDownloadTask, so we can unittest HTTP connection download file
 */
#import <Foundation/Foundation.h>

typedef void (^DownloadTaskCompletion)(NSURL * __nullable location, NSURLResponse * __nullable response, NSError * __nullable error);

@protocol OBDownloadTaskProtocol <NSObject>

- (void)downloadTaskWithURL:(nullable NSURL *)url completionHandler:(nonnull DownloadTaskCompletion)completionHandler;
- (void)resume;
- (void)cancel;

@end