//
//  ImageLoader.h
//  JSONPlaceholder
//
//  Created by Leonid Kokhnovych on 2018-06-01.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadImageOperation.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ImageLoaderType

- (NSOperation *)loadImage:(NSURL *)url completion:(LoadImageCompletion)completion;

@end

@interface ImageLoader : NSObject <ImageLoaderType>

+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END
