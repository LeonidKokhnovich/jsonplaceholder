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

static NSErrorDomain AlbumServiceProviderDomainError = @"com.jsonplaceholder.albumserviceprovider";
static NSString *WebServerAddress = @"http://jsonplaceholder.typicode.com";
static NSString *WebServerEndpointPhotos = @"photos";

typedef NS_ENUM(NSInteger, AlbumServiceProviderErrorCode) {
    AlbumServiceProviderErrorCodeInvalidURL,
    AlbumServiceProviderErrorCodeInvalidResponse,
    AlbumServiceProviderErrorCodeRequestFailed,
    AlbumServiceProviderErrorCodeInvalidData,
    AlbumServiceProviderErrorCodeUnableToParse
};

@interface AlbumServiceProvider ()

@property (nonatomic) NSURLSession *urlSession;

@end

@implementation AlbumServiceProvider

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
        NSError *error = [NSError errorWithDomain:AlbumServiceProviderDomainError code:AlbumServiceProviderErrorCodeInvalidURL userInfo:nil];
        completion(nil, error);
        return;
    }
    
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            completion(nil, error);
        } else if (response == nil || [response isKindOfClass:[NSHTTPURLResponse class]] == NO) {
            NSError *error = [NSError errorWithDomain:AlbumServiceProviderDomainError code:AlbumServiceProviderErrorCodeInvalidResponse userInfo:nil];
            completion(nil, error);
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            if (httpResponse.statusCode != HTTPStatusCodeSuccess) {
                NSError *error = [NSError errorWithDomain:AlbumServiceProviderDomainError code:AlbumServiceProviderErrorCodeRequestFailed userInfo:nil];
                completion(nil, error);
                return;
            }
            
            if (data == nil) {
                NSError *error = [NSError errorWithDomain:AlbumServiceProviderDomainError code:AlbumServiceProviderErrorCodeInvalidData userInfo:nil];
                completion(nil, error);
                return;
            }
            
            NSArray<AlbumModel *> *albumModels = [self makeAlbumsFromResponseData:data];
            if (albumModels != nil) {
                completion(albumModels, nil);
            } else {
                NSError *error = [NSError errorWithDomain:AlbumServiceProviderDomainError code:AlbumServiceProviderErrorCodeUnableToParse userInfo:nil];
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
    
    NSMutableArray<AlbumModel *> *albumModels = [NSMutableArray new];
    [modelsJSON enumerateObjectsUsingBlock:^(id albumModelJSON, NSUInteger idx, BOOL *stop) {
        if ([albumModelJSON isKindOfClass:[NSDictionary class]]) {
            AlbumModel *model = [[AlbumModel alloc] initWithJSON:albumModelJSON];
            if (model != nil) {
                [albumModels addObject:model];
            } else {
                NSLog(@"Failed to create album model from json");
            }
        } else {
            NSLog(@"Failed to represent album JSON as dict");
        }
    }];
    return albumModels.copy;
}

@end
