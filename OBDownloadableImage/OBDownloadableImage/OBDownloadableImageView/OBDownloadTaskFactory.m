//
//  OBDownloadTaskFactory.m
//  OBDownloadableImage
//
//  Created by Omer Blumenkrunz on 10/03/2016.
//  Copyright © 2016 Omer Blumenkrunz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OBDownloadTaskFactory.h"
#import "OBDownloadTask.h"


@implementation OBDownloadTaskFactory

-(id<OBDownloadTaskProtocol>)createDownloadTask
{
    return [OBDownloadTask new];
}


@end
