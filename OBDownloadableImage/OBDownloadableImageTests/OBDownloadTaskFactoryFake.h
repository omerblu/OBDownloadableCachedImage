//
//  OBDownloadTaskFactoryFake.h
//  OBDownloadableImage
//
//  Created by Omer Blumenkrunz on 10/03/2016.
//  Copyright © 2016 Omer Blumenkrunz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OBDownloadTaskFactoryProtocol.h"
#import "OBDownloadTaskFake.h"


@interface OBDownloadTaskFactoryFake : NSObject <OBDownloadTaskFactoryProtocol>
@property (nonatomic,strong) id<OBDownloadTaskProtocol> downloadTaskFake;
@end
