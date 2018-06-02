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
@property (nonatomic) NSMutableDictionary<AlbumModel *, NSOperation *> *allDownloads;
@property (nonatomic) NSMutableDictionary<AlbumModel *, NSOperation *> *highPriorityDownloads;
@property (atomic) NSArray<AlbumModel *> *visibleAlbums;

@end

@implementation PhotosViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.albumServiceProvider = [AlbumServiceProvider shared];
        self.photoViewModels = [NSArray new];
        self.imageLoader = ImageLoader.shared;
        self.allDownloads = [NSMutableDictionary new];
        self.highPriorityDownloads = [NSMutableDictionary new];
    }
    return self;
}

- (void)updatePhotos {
    [self cancelLastUpdate];
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
            [self startPhotosDownload];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate didUpdatePhotos];
            });
        }
    }];
}

- (void)didChangeScrollPositionWithVisibleIndexes:(NSArray<NSIndexPath *> *)indexes {
    self.visibleAlbums = [indexes map:^id _Nonnull(NSIndexPath * _Nonnull obj) {
        return self.albumModels[obj.row];
    }];
}

- (void)didFinishScrollWithVisibleIndexes:(NSArray<NSIndexPath *> *)indexes {
    NSArray<AlbumModel *> *visibleAlbumModels = [indexes map:^id _Nonnull(NSIndexPath *indexPath) {
        return self.albumModels[indexPath.row];
    }];
    NSSet<AlbumModel *> *visibleAlbumModelsSet = [NSSet setWithArray:visibleAlbumModels];
    NSSet<AlbumModel *> *highPriorityAlbumModelsSet = [NSSet setWithArray:self.highPriorityDownloads.allKeys];
    
    NSMutableSet<AlbumModel *> *itemsToBeDeprioritized = highPriorityAlbumModelsSet.mutableCopy;
    [itemsToBeDeprioritized minusSet:visibleAlbumModelsSet];
    [self.highPriorityDownloads enumerateKeysAndObjectsUsingBlock:^(AlbumModel * _Nonnull key, NSOperation * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([itemsToBeDeprioritized containsObject:key]) {
            obj.queuePriority = NSOperationQueuePriorityNormal;
        }
    }];
    [self.highPriorityDownloads removeObjectsForKeys:itemsToBeDeprioritized.allObjects];
    
    NSMutableSet<AlbumModel *> *itemsToBePrioritized = visibleAlbumModelsSet.mutableCopy;
    [itemsToBePrioritized minusSet:highPriorityAlbumModelsSet];
    [itemsToBePrioritized enumerateObjectsUsingBlock:^(AlbumModel * _Nonnull obj, BOOL * _Nonnull stop) {
        NSOperation *operation = [self.allDownloads objectForKey:obj];
        if (operation != nil) {
            operation.queuePriority = NSOperationQueuePriorityHigh;
            [self.highPriorityDownloads setObject:operation forKey:obj];
        }
    }];
}

- (NSArray<NSIndexPath *> *)removePhotosWithLettersBOrD {
    NSMutableIndexSet *indexesForRemoval = [NSMutableIndexSet new];
    for (NSUInteger i = 0; i < self.albumModels.count; i++) {
        AlbumModel *albumModel = self.albumModels[i];
        if ([albumModel.title containsString:@"b"] || [albumModel.title containsString:@"d"]) {
            [indexesForRemoval addIndex:i];
        }
    }
    
    [[self.albumModels objectsAtIndexes:indexesForRemoval] enumerateObjectsUsingBlock:^(AlbumModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSOperation *operation = self.allDownloads[obj];
        if (operation != nil) {
            [operation cancel];
        }
    }];
    
    NSMutableArray<AlbumModel *> *newAlbumModels = self.albumModels.mutableCopy;
    [newAlbumModels removeObjectsAtIndexes:indexesForRemoval];
    self.albumModels = newAlbumModels;
    
    NSMutableArray<PhotoViewModel *> *newPhotoViewModels = self.photoViewModels.mutableCopy;
    [newPhotoViewModels removeObjectsAtIndexes:indexesForRemoval];
    self.photoViewModels = newPhotoViewModels;
    
    NSMutableArray<NSIndexPath *> *removedIndexPaths = [NSMutableArray new];
    [indexesForRemoval enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        [removedIndexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
    }];
    return removedIndexPaths.copy;
}

#pragma mark - Helpers

- (void)startPhotosDownload {
    __weak typeof(self) weakSelf = self;
    
    for (NSInteger i = 0; i < self.albumModels.count; i++) {
        AlbumModel *albumModel = self.albumModels[i];
        PhotoViewModel *viewModel = self.photoViewModels[i];
        
        NSOperation *operation = [self.imageLoader loadImage:albumModel.url completion:^(UIImage * _Nullable image, NSError * _Nullable error) {
            viewModel.image = image;
            
            if ([weakSelf.visibleAlbums containsObject:albumModel]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.delegate didUpdatePhotoAtIndex:i];
                });
            }
        }];
        operation.completionBlock = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.allDownloads removeObjectForKey:albumModel];
                [weakSelf.highPriorityDownloads removeObjectForKey:albumModel];
            });
        };
        [self.allDownloads setObject:operation forKey:albumModel];
    }
}

- (void)cancelLastUpdate {
    [self.allDownloads enumerateKeysAndObjectsUsingBlock:^(AlbumModel * _Nonnull key, NSOperation * _Nonnull operation, BOOL * _Nonnull stop) {
        [operation cancel];
    }];
}

@end
