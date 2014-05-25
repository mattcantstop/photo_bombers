//
//  TTPhotoCell.m
//  Photo Bombers
//
//  Created by Duff on 5/21/14.
//  Copyright (c) 2014 tiniestTime. All rights reserved.
//

#import "TTPhotoCell.h"
#import "TTPhotoController.h"

@implementation TTPhotoCell

- (void)setPhoto:(NSDictionary *)photo {
    _photo = photo;
    [TTPhotoController imageForPhoto:_photo size:@"thumbnail" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(like)];
        tap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tap];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void) like {
    NSLog(@"Link: %@", self.photo[@"link"]);
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    NSString *likeURLString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@", self.photo[@"id"], accessToken];
    NSURL *likeURL = [[NSURL init] initWithString:likeURLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:likeURL];
    request.HTTPMethod = @"POST";
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLikeCompletion];
        });
    }];
    [task resume];
}

- (void) showLikeCompletion {
    UIAlertView *likeAlert = [[UIAlertView alloc] initWithTitle:@"Liked!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [likeAlert show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [likeAlert dismissWithClickedButtonIndex:0 animated:YES];
    });
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;
}

@end
