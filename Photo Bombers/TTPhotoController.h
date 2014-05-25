//
//  TTPhotoController.h
//  Photo Bombers
//
//  Created by Matthew Duff on 5/25/14.
//  Copyright (c) 2014 tiniestTime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTPhotoController : NSObject

+ (void) imageForPhoto:(NSDictionary *)photo size:(NSString *)size completion:(void(^) (UIImage *image)) completion;

@end
