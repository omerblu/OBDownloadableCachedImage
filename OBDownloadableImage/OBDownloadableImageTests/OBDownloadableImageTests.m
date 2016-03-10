//
//  OBDownloadableImageTests.m
//  OBDownloadableImageTests
//
//  Created by Omer Blumenkrunz on 10/03/2016.
//  Copyright © 2016 Omer Blumenkrunz. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OBImageDownloaderManager.h"
#import "OBDownloadTaskFactoryFake.h"

#define kOBWaitTimeForAsyncWork 3


@interface OBImageDownloaderManagerTests : XCTestCase

@property(strong,nonatomic) OBDownloadTaskFactoryFake *  downloadTaskFactoryFake;
@property(strong,nonatomic) OBDownloadTaskFake *  downloadTaskFake;
@property(strong,nonatomic) OBImageDownloaderManager * imageDownloaderManager;


@end

@implementation OBImageDownloaderManagerTests

- (void)setUp
{
    [super setUp];
    self.downloadTaskFactoryFake = [OBDownloadTaskFactoryFake new];
    self.downloadTaskFake = [OBDownloadTaskFake new];
    self.downloadTaskFactoryFake.downloadTaskFake = self.downloadTaskFake;
    self.imageDownloaderManager = [OBImageDownloaderManager sharedImageDownloaderManagerWithFactory:self.downloadTaskFactoryFake];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(NSURL *)copyFileToTempFromPath:(NSString * )path
{
    NSString * tempDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString * filePath = [tempDirectory stringByAppendingPathComponent:@"temp.tmp"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSError *nserror;
    if([fileManager fileExistsAtPath:filePath])
    {
        [fileManager removeItemAtPath:filePath error:&nserror];
    }
    
    BOOL res = [fileManager copyItemAtPath:path toPath:filePath error:&nserror];
    
    if(res == NO || nserror != nil)
    {
        return nil;
    }
    
    return [NSURL fileURLWithPath:filePath];
    
}
- (void)testThatItDoesNotCallTheCompletionHandlerIfThereIsDownloadErrorNilURL
{
    // given
    __block NSInteger numberOfCalls = 0;
    OBImageDownloaderCompletionHandler imageDownloaderCompletionHandler  = ^(UIImage * __unused downloadedImage) {
        numberOfCalls++;
    };
    
    // when
    NSURL *url =nil;
    self.downloadTaskFake.httpError = YES;
    [self.imageDownloaderManager startDownloadImageFromURL:url completionHandlerBlock:imageDownloaderCompletionHandler];
    
    // Than
    [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kOBWaitTimeForAsyncWork]];
    XCTAssertTrue(numberOfCalls == 0, @"numberOfCalls == 0 to CompletionHandler for no url");
    
}
- (void)testThatItDoesNotCallTheCompletionHandlerIfThereIsDownloadErrorNoURL
{
    // given
    __block NSInteger numberOfCalls = 0;
    OBImageDownloaderCompletionHandler imageDownloaderCompletionHandler  = ^(UIImage * __unused downloadedImage) {
        numberOfCalls++;
    };
    
    // when
    NSURL *url =[NSURL URLWithString:@""];
    self.downloadTaskFake.httpError = YES;
    [self.imageDownloaderManager startDownloadImageFromURL:url completionHandlerBlock:imageDownloaderCompletionHandler];
    
    // Than
    [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kOBWaitTimeForAsyncWork]];
    XCTAssertTrue(numberOfCalls == 0, @"numberOfCalls == 0 to CompletionHandler for no url");
    
}
- (void)testThatItDoesNotCallTheCompletionHandlerIfThereIsDownloadErrorBadURL
{
    // given
    __block NSInteger numberOfCalls = 0;
    OBImageDownloaderCompletionHandler imageDownloaderCompletionHandler  = ^(UIImage * __unused downloadedImage) {
        numberOfCalls++;
    };
    
    // when
    id url = @"hahaha";
    self.downloadTaskFake.httpError = YES;
    [self.imageDownloaderManager startDownloadImageFromURL:url completionHandlerBlock:imageDownloaderCompletionHandler];
    
    // Than
    [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kOBWaitTimeForAsyncWork]];
    XCTAssertTrue(numberOfCalls == 0, @"numberOfCalls == 0 to CompletionHandler for no url");
    
}

- (void)testThatItDoesNotCallTheCompletionHandlerIfThereIsDownloadErrorTxtFileNotAnImage
{
    // given
    __block NSInteger numberOfCalls = 0;
    OBImageDownloaderCompletionHandler imageDownloaderCompletionHandler  = ^(UIImage * __unused downloadedImage) {
        numberOfCalls++;
    };
    
    // when
    NSURL *url =[NSURL URLWithString:@"https://OB.com/test.txt"];
    NSString* testTextFilePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"test.txt"];
    
    self.downloadTaskFake.downloadFileURL = [self copyFileToTempFromPath:testTextFilePath];
    self.downloadTaskFake.downloadSuccessfully = YES;
    
    [self.imageDownloaderManager startDownloadImageFromURL:url completionHandlerBlock:imageDownloaderCompletionHandler];
    
    // Than
    [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kOBWaitTimeForAsyncWork]];
    XCTAssertTrue(numberOfCalls == 0, @"numberOfCalls == 0 to CompletionHandler for url not an image");
}


- (void)testThatItDoesCallTheCompletionHandlerOnlyOnceIfDownloadTheImageSuccessfully
{
    // given
    __block NSInteger numberOfCalls = 0;
    OBImageDownloaderCompletionHandler imageDownloaderCompletionHandler  = ^(UIImage * __unused downloadedImage) {
        numberOfCalls++;
    };
    
    // when
    NSURL *url =[NSURL URLWithString:@"http://OB.com/test.png"];
    NSString* testImageFilePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"test.png"];
    
    self.downloadTaskFake.downloadFileURL = [self copyFileToTempFromPath:testImageFilePath];
    self.downloadTaskFake.downloadSuccessfully = YES;
    
    [self.imageDownloaderManager startDownloadImageFromURL:url completionHandlerBlock:imageDownloaderCompletionHandler];
    
    // Than
    [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kOBWaitTimeForAsyncWork]];
    XCTAssertTrue(numberOfCalls == 1, @"numberOfCalls to CompletionHandler == 1 for OK url");
    
    
}



- (void)testThatItDoesReturnToTheCompletionHandlerAValidImageSuccessfully
{
    // given
    __block NSData * imageData;
    OBImageDownloaderCompletionHandler imageDownloaderCompletionHandler  = ^(UIImage * __unused downloadedImage) {
        imageData = UIImagePNGRepresentation(downloadedImage);
    };
    
    // when
    NSURL *url =[NSURL URLWithString:@"http://OB.com/test.png"];
    NSString* testImageFilePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"test.png"];
    
    self.downloadTaskFake.downloadFileURL = [self copyFileToTempFromPath:testImageFilePath];
    self.downloadTaskFake.downloadSuccessfully = YES;
    
    [self.imageDownloaderManager startDownloadImageFromURL:url completionHandlerBlock:imageDownloaderCompletionHandler];
    
    // Than
    [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kOBWaitTimeForAsyncWork]];
    XCTAssertNotNil(imageData, @"imageData should not be nil");
    XCTAssertTrue(imageData.length > 0, @"imageData should not be empty");
    
}

- (void)testThatItDoesDownloadTheCorrectImage
{
    // given
    __block NSData * imageData;
    OBImageDownloaderCompletionHandler imageDownloaderCompletionHandler  = ^(UIImage * __unused downloadedImage) {
        imageData = UIImagePNGRepresentation(downloadedImage);
    };
    
    // when
    NSURL *url =[NSURL URLWithString:@"http://OB.com/test.png"];
    NSString* testImageFilePath = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"test.png"];
    
    UIImage * directImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:testImageFilePath]];
    NSData  * directImageData = UIImagePNGRepresentation(directImage);
    
    self.downloadTaskFake.downloadFileURL = [self copyFileToTempFromPath:testImageFilePath];
    self.downloadTaskFake.downloadSuccessfully = YES;
    
    [self.imageDownloaderManager startDownloadImageFromURL:url completionHandlerBlock:imageDownloaderCompletionHandler];
    
    // Than
    [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kOBWaitTimeForAsyncWork]];
    XCTAssertTrue([imageData isEqualToData:directImageData], @"imageData should be the same");
    
}
@end

