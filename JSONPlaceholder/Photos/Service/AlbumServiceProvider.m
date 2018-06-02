//
//  AlbumServiceProvider.m
//  JSONPlaceholder
//
//  Created by Leonid Kokhnovych on 2018-06-01.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

#import "AlbumServiceProvider.h"
#import "HTTPConstants.h"
#import "AlbumModel.h"
#import "NSArray+Helpers.h"
#import "URLTask.h"

static NSString *WebServerAddress = @"http://jsonplaceholder.typicode.com";
static NSString *WebServerEndpointPhotos = @"photos";

@interface AlbumServiceProvider ()

@property (nonatomic) NSURLSession *urlSession;

@end

@implementation AlbumServiceProvider

static NSErrorDomain DomainError = @"com.jsonplaceholder.albumserviceprovider";
static AlbumServiceProvider *_shared;

+ (instancetype)shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[AlbumServiceProvider alloc] init];
    });
    return _shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.urlSession = NSURLSession.sharedSession;
    }
    return self;
}

#pragma mark - Public API

- (void)fetchAlbumsWithCompletion:(void (^ _Nonnull)(NSArray<AlbumModel *> * _Nullable, NSError * _Nullable))completion {
    NSURL *url = [self makeURLForAlbums];
    if (url == nil) {
        NSError *error = [NSError errorWithDomain:DomainError code:URLTaskErrorCodeInvalidURL userInfo:nil];
        completion(nil, error);
        return;
    }
    
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            completion(nil, error);
        } else if (response == nil || [response isKindOfClass:[NSHTTPURLResponse class]] == NO) {
            NSError *error = [NSError errorWithDomain:DomainError code:URLTaskErrorCodeInvalidResponse userInfo:nil];
            completion(nil, error);
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            if (httpResponse.statusCode != HTTPStatusCodeSuccess) {
                NSError *error = [NSError errorWithDomain:DomainError code:URLTaskErrorCodeRequestFailed userInfo:nil];
                completion(nil, error);
                return;
            }
            
            if (data == nil) {
                NSError *error = [NSError errorWithDomain:DomainError code:URLTaskErrorCodeInvalidData userInfo:nil];
                completion(nil, error);
                return;
            }
            
            NSArray<AlbumModel *> *albumModels = [self makeAlbumsFromResponseData:data];
            if (albumModels != nil) {
                completion(albumModels, nil);
            } else {
                NSError *error = [NSError errorWithDomain:DomainError code:URLTaskErrorCodeUnableToParse userInfo:nil];
                completion(nil, error);
            }
        }
    }];
    [task resume];
}

#pragma mark - Helpers

- (NSURL * _Nullable)makeURLForAlbums {
    NSURL *url = [[NSURL alloc] initWithString:WebServerAddress];
    return [url URLByAppendingPathComponent:WebServerEndpointPhotos];
}

- (NSArray<AlbumModel *> * _Nullable)makeAlbumsFromResponseData:(NSData * _Nonnull)data {
    NSError *error;
    NSArray *modelsJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error != nil || modelsJSON == nil || [modelsJSON isKindOfClass:[NSArray class]] == NO) {
        return nil;
    }
    
    NSArray<AlbumModel *> *albumModels = [modelsJSON flatMap:^id _Nonnull(id  _Nonnull jsonObject) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            return [[AlbumModel alloc] initWithJSON:jsonObject];
        } else {
            return nil;
        }
    }];
    return albumModels;
}

@end
