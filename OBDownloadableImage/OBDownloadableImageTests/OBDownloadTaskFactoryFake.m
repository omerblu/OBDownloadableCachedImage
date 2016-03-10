//
//  OBDownloadTaskFactoryFake.m
//  OBDownloadableImage
//
//  Created by Omer Blumenkrunz on 10/03/2016.
//  Copyright © 2016 Omer Blumenkrunz. All rights reserved.
//

#import "OBDownloadTaskFactoryFake.h"


@implementation OBDownloadTaskFactoryFake
@synthesize downloadTaskFake;

-(id<OBDownloadTaskProtocol>)createDownloadTask
{
    return self.downloadTaskFake;
}

@end

