# OBDownloadableCachedImage
This is an iOS Objective-C component that downloads and caches images, and is used as an UIImageView subclass

*One HTTP request per URL

*Upon object reuse API lets you choose if you want to stop unfinished download

*Image is cached to app cache directory

*You can set placeholder image

*Can be used in nib/storyboard 


You can use it just by taking the folder to your project:
OBDownloadableCachedImage/OBDownloadableImage/OBDownloadableImage/OBDownloadableImageView/

Examples of use:
   
OBDownloadableImageView * image = [OBDownloadableImageView new];

[image downloadImageFromURL:[NSURL URLWithString : @"https://privacy.google.com/images/landing/10_privacy1_450_w.png"] stopPreviousDownloadImage:NO];
    
OBDownloadableImageView * imageA = [[OBDownloadableImageView alloc]initWithImage:[UIImage imageNamed:@"placeholderImage"]];

[imageA downloadImageFromURL:[NSURL URLWithString : @"https://privacy.google.com/images/landing/10_privacy1_450_w.png"] stopPreviousDownloadImage:NO];
