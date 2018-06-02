//
//  LoadImageOperation.h
//  JSONPlaceholder
//
//  Created by Leonid Kokhnovych on 2018-06-01.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

#import "AsyncOperation.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoadImageOperation : AsyncOperation

@property (readonly, nonatomic) NSURL *url;
@property (readonly, nonatomic, nullable) UIImage *image;
@property (readonly, nonatomic, nullable) NSError *error;

- (instancetype)initWithURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
