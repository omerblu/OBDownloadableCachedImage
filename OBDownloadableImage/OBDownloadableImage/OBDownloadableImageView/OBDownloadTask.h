//
//  OBDownloadTask.h
//  OBDownloadableImage
//
//  Created by Omer Blumenkrunz on 10/03/2016.
//  Copyright © 2016 Omer Blumenkrunz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OBDownloadTaskProtocol.h"
/**
 * A HTTP Server for Download file: Wrappes system API - NSURLSessionDownloadTask
 */
@interface OBDownloadTask : NSObject  <OBDownloadTaskProtocol>

@end
