//
//  TTPhotosViewController.m
//  Photo Bombers
//
//  Created by Duff on 5/20/14.
//  Copyright (c) 2014 tiniestTime. All rights reserved.
//

#import "TTPhotosViewController.h"

@interface TTPhotosViewController ()

@end

@implementation TTPhotosViewController


- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    return (self = [super initWithCollectionViewLayout:layout]);
}

- (void) viewdidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

@end
