//
//  OBDownloadableImageView.m
//  OBDownloadableImage
//
//  Created by Omer Blumenkrunz on 10/03/2016.
//  Copyright © 2016 Omer Blumenkrunz. All rights reserved.
//

#import "OBDownloadableImageView.h"
#import "OBImageDownloaderManager.h"


@interface OBDownloadableImageView()
@property(strong,nonatomic) OBImageDownloaderCompletionHandler  imageDownloaderCompletionHandler;
@property(strong,nonatomic) NSURL *   url;
@property (assign, nonatomic)BOOL isNotFirstUse;
@end


@implementation OBDownloadableImageView

/**
 * \brief Init an OBImageDownloader with [[OBDownloadableImageView alloc] initWithImage:defaultImage]] then call downloadImageFromURL:stopPreviousDownloadImage;
 */


/**
 * \brief Updates the OBImageDownloader - used in Reusable Cells with option to stop download for unsean cells
 * \param url NSURL the image url
 * \param stopPreviousDownloadImage BOOL whether to stop other downloads for reusable cells
 */
- (void)downloadImageFromURL:(NSURL *) url stopPreviousDownloadImage:(BOOL)stopPreviousDownloadImage
{
    //If no url was passed do nothing
    if(url == nil)
    {
        return;
    }
    
    if(self.isNotFirstUse && ![[url absoluteString] isEqualToString:[self.url absoluteString]])
    {
        [[OBImageDownloaderManager sharedImageDownloaderManager] stopDownloadImageFromURL:self.url completionHandlerBlock:self.imageDownloaderCompletionHandler removeDownloadTask:stopPreviousDownloadImage];
    }
    
    __weak typeof(self) welf = self;
    self.imageDownloaderCompletionHandler  = ^(UIImage* downloadedImage) {
        __strong typeof(welf) strongSelf = welf;
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.image  = downloadedImage;
        });
    };
    self.url = url;
    self.isNotFirstUse = YES;
    
    [[OBImageDownloaderManager sharedImageDownloaderManager] startDownloadImageFromURL:url completionHandlerBlock:self.imageDownloaderCompletionHandler];
}


- (void)dealloc
{
    if(self.imageDownloaderCompletionHandler !=nil)
    {
        [[OBImageDownloaderManager sharedImageDownloaderManager] stopDownloadImageFromURL:self.url completionHandlerBlock:self.imageDownloaderCompletionHandler removeDownloadTask:YES];
    }
}
@end

