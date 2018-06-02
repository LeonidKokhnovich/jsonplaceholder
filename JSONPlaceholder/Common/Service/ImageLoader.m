//
//  ImageLoader.m
//  JSONPlaceholder
//
//  Created by Leonid Kokhnovych on 2018-06-01.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

#import "ImageLoader.h"
#import "HTTPConstants.h"
#import "URLTask.h"
#import "LoadImageOperation.h"

static NSUInteger ImageLoaderMaxConcurrentDownload = 3;

@interface ImageLoader ()

@property (nonatomic) NSOperationQueue *operationQueue;

@end

@implementation ImageLoader

static ImageLoader *_shared;

+ (instancetype)shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[ImageLoader alloc] init];
    });
    return _shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.operationQueue = [NSOperationQueue new];
        self.operationQueue.maxConcurrentOperationCount = ImageLoaderMaxConcurrentDownload;
    }
    return self;
}

- (NSOperation *)loadImage:(NSURL *)url completion:(LoadImageCompletion)completion {
    LoadImageOperation *operation = [[LoadImageOperation alloc] initWithURL:url];
    __weak typeof(operation) weakOperation = operation;
    operation.completionBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(operation) strongOperation = weakOperation;
            if (strongOperation != nil) {
                completion(strongOperation.image, strongOperation.error);
            }
        });
    };
    [self.operationQueue addOperation:operation];
    return operation;
}

@end
