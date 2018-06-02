//
//  LoadImageOperation.m
//  JSONPlaceholder
//
//  Created by Leonid Kokhnovych on 2018-06-01.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

#import "LoadImageOperation.h"
#import "HTTPConstants.h"
#import "URLTask.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoadImageOperation ()

@property (nonatomic, readonly) NSString *storageFolderPath;
@property (nonatomic) NSFileManager *fileManager;
@property (nonatomic) NSURLSession *urlSession;
@property (nonatomic, nullable) UIImage *image;
@property (nonatomic, nullable) NSError *error;

@end

@implementation LoadImageOperation

static NSErrorDomain DomainError = @"com.jsonplaceholder.imageloader";

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        _url = url;
        _storageFolderPath = NSTemporaryDirectory();
        self.fileManager = NSFileManager.defaultManager;
        self.urlSession = NSURLSession.sharedSession;
    }
    return self;
}

- (void)main {
    NSURL *localImageFileURL = [self getLocalFileURLForImage:self.url];
    
    if ([self.fileManager fileExistsAtPath:localImageFileURL.path]) {
        NSData *data = [NSData dataWithContentsOfURL:localImageFileURL];
        UIImage *image = [UIImage imageWithData:data];
        if (image != nil) {
            self.image = image;
            [self completeOperation];
            return;
        }
    }
    
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithURL:self.url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            self.error = error;
            [self completeOperation];
        } else if (response == nil || [response isKindOfClass:[NSHTTPURLResponse class]] == NO) {
            self.error = [NSError errorWithDomain:DomainError code:URLTaskErrorCodeInvalidResponse userInfo:nil];
            [self completeOperation];
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            if (httpResponse.statusCode != HTTPStatusCodeSuccess) {
                self.error = [NSError errorWithDomain:DomainError code:URLTaskErrorCodeRequestFailed userInfo:nil];
                [self completeOperation];
                return;
            }
            
            if (data == nil) {
                self.error = [NSError errorWithDomain:DomainError code:URLTaskErrorCodeInvalidData userInfo:nil];
                [self completeOperation];
                return;
            }
            
            UIImage *image = [UIImage imageWithData:data];
            if (image != nil) {
                self.image = image;
                [data writeToURL:localImageFileURL atomically:YES];
                [self completeOperation];
            } else {
                self.error = [NSError errorWithDomain:DomainError code:URLTaskErrorCodeUnableToParse userInfo:nil];
                [self completeOperation];
            }
        }
    }];
    [task resume];
}

#pragma mark - Helpers

- (NSURL *)getLocalFileURLForImage:(NSURL *)url {
    NSString *imageIdentifier = [self getImageIdentifierFromURL:url];
    NSString *filePath = [self.storageFolderPath stringByAppendingPathComponent:imageIdentifier];
    return [NSURL fileURLWithPath:filePath];
}

- (NSString *)getImageIdentifierFromURL:(NSURL *)url {
    return url.lastPathComponent;
}

@end

NS_ASSUME_NONNULL_END
