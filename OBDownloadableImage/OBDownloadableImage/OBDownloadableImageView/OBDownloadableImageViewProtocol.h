//
//  OBDownloadableImageViewProtocol.h
//  OBDownloadableImage
//
//  Created by Omer Blumenkrunz on 10/03/2016.
//  Copyright © 2016 Omer Blumenkrunz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OBDownloadableImageViewProtocol <NSObject>
- (void)downloadImageFromURL:(nullable NSURL *) url stopPreviousDownloadImage:(BOOL)stopPreviousDownloadImage;
@end