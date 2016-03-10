//
//  OBDownloadTaskFactoryProtocol.h
//  OBDownloadableImage
//
//  Created by Omer Blumenkrunz on 10/03/2016.
//  Copyright © 2016 Omer Blumenkrunz. All rights reserved.
//

#import "OBDownloadTaskProtocol.h"

/**
 *  Describes a protocol for a factory that build OBDownloadTask
 */
@protocol OBDownloadTaskFactoryProtocol <NSObject>

/**
 *  Build a new OBDownloadTask
 *  @return OBDownloadTask
 */
-(nullable id<OBDownloadTaskProtocol>)createDownloadTask;

@end