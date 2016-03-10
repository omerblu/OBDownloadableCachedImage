//
//  OBImageDownloaderManager.h
//  OBDownloadableImage
//
//  Created by Omer Blumenkrunz on 10/03/2016.
//  Copyright © 2016 Omer Blumenkrunz. All rights reserved.
//

#import "OBImageDownloaderProtocol.h"
#import "OBDownloadTaskFactory.h"

@interface OBImageDownloaderManager : NSObject <OBImageDownloaderProtocol>
+ (nullable OBImageDownloaderManager *)sharedImageDownloaderManager;
+ (nullable OBImageDownloaderManager *)sharedImageDownloaderManagerWithFactory:(nullable id<OBDownloadTaskFactoryProtocol>)factory;
@end
