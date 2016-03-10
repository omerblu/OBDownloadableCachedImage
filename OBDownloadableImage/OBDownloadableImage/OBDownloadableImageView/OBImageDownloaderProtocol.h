//
//  OBImageDownloaderProtocol.h
//  OBDownloadableImage
//
//  Created by Omer Blumenkrunz on 10/03/2016.
//  Copyright © 2016 Omer Blumenkrunz. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef void (^OBImageDownloaderCompletionHandler)(UIImage * __nonnull image);

@protocol OBImageDownloaderProtocol <NSObject>
- (void) startDownloadImageFromURL: (nonnull NSURL *) imageURL completionHandlerBlock: (nonnull OBImageDownloaderCompletionHandler) completionHandler;
- (void) stopDownloadImageFromURL : (nonnull NSURL *) imageURL completionHandlerBlock: (nonnull OBImageDownloaderCompletionHandler) completionHandler removeDownloadTask:(BOOL)removeDownloadTask;
@end