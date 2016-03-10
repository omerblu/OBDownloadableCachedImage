//
//  OBImageDownloaderCacheData.h
//  OBDownloadableImage
//
//  Created by Omer Blumenkrunz on 10/03/2016.
//  Copyright © 2016 Omer Blumenkrunz. All rights reserved.
//

#import "OBDownloadTaskProtocol.h"

@interface OBImageDownloaderCacheData : NSObject
@property (readwrite,nonatomic) NSMutableArray * completionHandlerArray;
@property (readwrite,nonatomic) id<OBDownloadTaskProtocol> downloadTask;
@property (readwrite,nonatomic) NSString * pathOnDisk;
@end
