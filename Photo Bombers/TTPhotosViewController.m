//
//  TTPhotosViewController.m
//  Photo Bombers
//
//  Created by Duff on 5/20/14.
//  Copyright (c) 2014 tiniestTime. All rights reserved.
//

#import "TTPhotosViewController.h"
#import "TTPhotoCell.h"
#import "TTDetailViewController.h"

#import <SimpleAuth/Simpleauth.h>

@interface TTPhotosViewController ()

  @property (nonatomic) NSString *accessToken;
  @property (nonatomic) NSArray *photos;

@end

@implementation TTPhotosViewController


- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(106.0, 106.0);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    
    return (self = [super initWithCollectionViewLayout:layout]);
}

- (void) viewDidLoad {
    [super viewDidLoad];

    self.title = @"Photo Bomber";
    
    [self.collectionView registerClass:[TTPhotoCell class] forCellWithReuseIdentifier:@"photo"];
    self.collectionView.backgroundColor = [UIColor whiteColor];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.accessToken = [userDefaults objectForKey:@"accessToken"];
    
    if (self.accessToken == nil) {
        [SimpleAuth authorize:@"instagram" options:@{@"scope": @[@"likes"]} completion:^(NSDictionary *responseObject, NSError *error) {
            self.accessToken = responseObject[@"credentials"][@"token"];
            
            [userDefaults setObject:self.accessToken forKey:@"accessToken"];
            [userDefaults synchronize];
            
            [self refresh];
        }];
    } else {
        [self refresh];
    }
}

- (void) refresh {
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/tags/photobomb/media/recent?access_token=%@", self.accessToken];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *endpointRequest = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:endpointRequest completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        self.photos = [responseDictionary valueForKeyPath:@"data"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        
    }];
    [task resume];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photos count];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.photo = self.photos[indexPath.row];
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *photo = self.photos[indexPath.row];
    TTDetailViewController *viewController = [[TTDetailViewController alloc] init];
    viewController.photo = photo;
    
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
