//
//  OBImageDownloaderManager.m
//  OBDownloadableImage
//
//  Created by Omer Blumenkrunz on 10/03/2016.
//  Copyright © 2016 Omer Blumenkrunz. All rights reserved.
//

#import "OBImageDownloaderManager.h"
#import "OBImageDownloaderCacheData.h"

#define OBImageDownloaderErrorDomain @"OBImageDownloaderErrorDomain"


@interface OBImageDownloaderManager()
@property (readwrite,nonatomic) NSString* cachesDirectory;
@property (strong,nonatomic)    __block NSMutableDictionary *   cacheDataDictionary;
@property (strong,nonatomic)    dispatch_queue_t downloaderManagerQueue;
@property (strong,nonatomic)   id<OBDownloadTaskFactoryProtocol>  downloadTaskFactory;
@end


@implementation OBImageDownloaderManager

+ (OBImageDownloaderManager *)sharedImageDownloaderManager
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        id<OBDownloadTaskFactoryProtocol> factory = [OBDownloadTaskFactory new];
        instance = [OBImageDownloaderManager sharedImageDownloaderManagerWithFactory:factory];
    });
    return instance;
}
+ (OBImageDownloaderManager *)sharedImageDownloaderManagerWithFactory:(id<OBDownloadTaskFactoryProtocol>)factory
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc]initWithFactory:factory];
    });
    return instance;
}
- (instancetype)initWithFactory:(id<OBDownloadTaskFactoryProtocol>)factory
{
    self = [super init];
    if (self) {
        
        _cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        if(!_cachesDirectory){
           NSLog(@"OBImageDownloaderManager - cachesDirectory parameter cannot can't be nil.");
            return nil;
        }
        
        _cacheDataDictionary= [NSMutableDictionary new];
        _downloaderManagerQueue = dispatch_queue_create("OBImageDownloaderManagerQueue", DISPATCH_QUEUE_SERIAL);
        
        if(!factory){
            NSLog(@"OBImageDownloaderManager - downloadTaskFactory parameter cannot can't be nil.");
            return nil;
        }
        
        _downloadTaskFactory = factory;
    }
    return self;
}
#pragma mark - OBImageDownloaderProtocol
//Check if the image needs to be downloaded or just get from disk, or add a completionHandler to a download
- (void) startDownloadImageFromURL: (NSURL*) imageURL completionHandlerBlock: (OBImageDownloaderCompletionHandler) completionHandler
{
    dispatch_async(self.downloaderManagerQueue, ^{
        
        if(![imageURL isKindOfClass:[NSURL class]] || imageURL == nil || [imageURL absoluteString].length == 0 || completionHandler == nil)
        {
            return;
        }
        
        NSString * fileHash = [NSString stringWithFormat:@"%@", @([imageURL hash])];
        OBImageDownloaderCacheData * imageDownloaderCacheData = self.cacheDataDictionary[fileHash];
        
        //Case there is no image downloaded or no download in progress
        if (imageDownloaderCacheData == nil)
        {
            imageDownloaderCacheData =[OBImageDownloaderCacheData new];
            imageDownloaderCacheData.completionHandlerArray = [NSMutableArray new];
            [imageDownloaderCacheData.completionHandlerArray addObject:completionHandler];
            self.cacheDataDictionary[fileHash] = imageDownloaderCacheData;
            [self startDownloadFromUrl:imageURL];
            return ;
        }
        
        //Case the image was downloaded
        if(imageDownloaderCacheData.pathOnDisk!= nil)
        {
            UIImage * image =[UIImage imageWithContentsOfFile:imageDownloaderCacheData.pathOnDisk];
            completionHandler(image);
            return ;
        }
        
        //Case there is no image downloaded but ther is download in progress
        if(imageDownloaderCacheData.completionHandlerArray!= nil  && imageDownloaderCacheData.downloadTask != nil)
        {
            [imageDownloaderCacheData.completionHandlerArray addObject:completionHandler];
            return ;
        }
    });
}


//Stop an image download if only one completionHandler, or remove the unwanted completionHandler
- (void) stopDownloadImageFromURL:(NSURL *)imageURL completionHandlerBlock:(OBImageDownloaderCompletionHandler)completionHandler removeDownloadTask:(BOOL)removeDownloadTask
{
    dispatch_async(self.downloaderManagerQueue, ^{
        NSString * fileHash = [NSString stringWithFormat:@"%@", @([imageURL hash])];
        OBImageDownloaderCacheData * imageDownloaderCacheData = self.cacheDataDictionary[fileHash];
        
        if(imageDownloaderCacheData == nil)
        {
            return;
        }
        
        [imageDownloaderCacheData.completionHandlerArray removeObject:completionHandler];
        
        id<OBDownloadTaskProtocol> getImageTask =  imageDownloaderCacheData.downloadTask;
        if (removeDownloadTask && getImageTask != nil && imageDownloaderCacheData.completionHandlerArray.count == 0)
        {
            [getImageTask cancel];
            [self.cacheDataDictionary removeObjectForKey:fileHash];
        }
    });
}

#pragma mark - Private
//Start a new download for an image
-(void)startDownloadFromUrl:(NSURL *)url
{
    NSString * fileHash = [NSString stringWithFormat:@"%@", @([url hash])];
    
    id<OBDownloadTaskProtocol> downloadTask = [self.downloadTaskFactory createDownloadTask];
    
    DownloadTaskCompletion completion = ^(NSURL *location, NSURLResponse *response, NSError *nserror){
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse * ) response;
        
        if(nserror != nil || httpResponse.statusCode != 200)
        {
            //Delete cache data
            dispatch_async(self.downloaderManagerQueue, ^{
                [self.cacheDataDictionary removeObjectForKey:fileHash];
            });
            //Log Error
            NSLog(@"Failed to download image for url: %@. NSError: %@", url,nserror);
            return;
        }
        [self saveImageToCacheFromTempURL:location forSourceURL:url];
    };
    
    [downloadTask downloadTaskWithURL:url  completionHandler:completion];
    
    [downloadTask resume];
    OBImageDownloaderCacheData * imageDownloaderCacheData = self.cacheDataDictionary[fileHash];
    imageDownloaderCacheData.downloadTask = downloadTask;
}


//Save the image to the caches directory
-(void)saveImageToCacheFromTempURL:(NSURL *)tempFileUrl forSourceURL:(NSURL *) sourceUrl
{
    NSString* filePath = [self.cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", @([sourceUrl hash]),[sourceUrl pathExtension]]];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSError *nserror;
    if([fileManager fileExistsAtPath:filePath])
    {
        if(![fileManager removeItemAtPath:filePath error:&nserror])
        {
            NSLog(@"Failed to remove file %@ in ImageDownloaderManager's cache. NSError: %@",tempFileUrl,nserror);
            
            return;
        }
    }
    
    if(![fileManager copyItemAtURL:tempFileUrl toURL:[NSURL fileURLWithPath:filePath] error:&nserror])
    {
        NSLog(@"Failed to save downloaded image from url: %@. NSError: %@",tempFileUrl,nserror);
        return;
    }
    
    [self updateCacheDataForSourceURL:sourceUrl toFilePath:filePath];
}

//Update the cach data model and all the Handlers
-(void)updateCacheDataForSourceURL:(NSURL *) sourceUrl toFilePath:(NSString *)filePath
{
    dispatch_async(self.downloaderManagerQueue, ^{
        NSString * fileHash = [NSString stringWithFormat:@"%@", @([sourceUrl hash])];
        OBImageDownloaderCacheData * imageDownloaderCacheData = self.cacheDataDictionary[fileHash];
        UIImage * image =[UIImage imageWithContentsOfFile:filePath];
        
        if(image == nil)
        {
            imageDownloaderCacheData.completionHandlerArray = nil;
            imageDownloaderCacheData.downloadTask = nil;
            [self.cacheDataDictionary removeObjectForKey:fileHash];
            return ;
        }
        
        for (OBImageDownloaderCompletionHandler completionHandler in imageDownloaderCacheData.completionHandlerArray)
        {
            completionHandler(image);
        }
        
        imageDownloaderCacheData.pathOnDisk = filePath;
        imageDownloaderCacheData.completionHandlerArray = nil;
        imageDownloaderCacheData.downloadTask = nil;
    });
}
@end

