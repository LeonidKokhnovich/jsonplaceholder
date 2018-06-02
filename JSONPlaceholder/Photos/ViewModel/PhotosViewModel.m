//
//  PhotosViewModel.m
//  JSONPlaceholder
//
//  Created by Leonid Kokhnovych on 2018-06-01.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

#import "PhotosViewModel.h"
#import "AlbumServiceProvider.h"
#import "NSArray+Helpers.h"
#import "AlbumModel.h"
#import "ImageLoader.h"

@interface PhotosViewModel ()

@property (nonatomic) AlbumServiceProvider *albumServiceProvider;
@property (nonatomic) ImageLoader *imageLoader;
@property (nonatomic) NSArray<PhotoViewModel *> *photoViewModels;
@property (nonatomic) NSArray<AlbumModel *> *albumModels;
@property (nonatomic) NSMutableDictionary<AlbumModel *, NSOperation *> *lowPriorityDownloads;
@property (nonatomic) NSMutableDictionary<AlbumModel *, NSOperation *> *highPriorityDownloads;

@end

@implementation PhotosViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.albumServiceProvider = [AlbumServiceProvider shared];
        self.photoViewModels = [NSArray new];
        self.imageLoader = ImageLoader.shared;
        self.lowPriorityDownloads = [NSMutableDictionary new];
        self.highPriorityDownloads = [NSMutableDictionary new];
    }
    return self;
}

- (void)updatePhotos {
    [self.albumServiceProvider fetchAlbumsWithCompletion:^(NSArray<AlbumModel *> * albumModels, NSError * error) {
        if (error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate didUpdatePhotosWithError:error];
            });
        } else {
            self.albumModels = albumModels;
            self.photoViewModels = [albumModels map:^id (AlbumModel *model) {
                PhotoViewModel *viewModel = [PhotoViewModel new];
                viewModel.title = model.title;
                return viewModel;
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate didUpdatePhotos];
            });
        }
    }];
}

@end
