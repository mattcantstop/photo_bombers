//
//  TTDetailViewController.m
//  Photo Bombers
//
//  Created by Matthew Duff on 5/25/14.
//  Copyright (c) 2014 tiniestTime. All rights reserved.
//

#import "TTDetailViewController.h"
#import "TTPhotoController.h"

@interface TTDetailViewController ()
@property (nonatomic) UIImageView *imageView;
@end

@implementation TTDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [self.view addSubview:self.imageView];
    
    [TTPhotoController imageForPhoto:self.photo size:@"standard_resolution" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.view addGestureRecognizer:tap];
}

- (void) close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
