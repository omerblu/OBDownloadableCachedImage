//
//  ViewController.m
//  OBDownloadableImage
//
//  Created by Omer Blumenkrunz on 10/03/2016.
//  Copyright © 2016 Omer Blumenkrunz. All rights reserved.
//

#import "ViewController.h"
#import "OBDownloadableImageView/OBDownloadableImageView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet OBDownloadableImageView *downloadableImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.downloadableImage.image = [UIImage imageNamed:@"placeholderImage"];
    [self.downloadableImage downloadImageFromURL:[NSURL URLWithString:@"https://privacy.google.com/images/landing/10_privacy1_450_w.png"] stopPreviousDownloadImage:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
