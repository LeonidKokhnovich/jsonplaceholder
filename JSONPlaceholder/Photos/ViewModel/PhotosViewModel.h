//
//  PhotosViewModel.h
//  JSONPlaceholder
//
//  Created by Leonid Kokhnovych on 2018-06-01.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PhotosViewModelDelegate <NSObject>

- (void)didUpdatePhotos;
- (void)didUpdatePhotoAtIndex:(NSInteger)index;
- (void)didUpdatePhotosWithError:(NSError *)error;

@end

@interface PhotosViewModel : NSObject

@property (weak, nonatomic, nullable) id <PhotosViewModelDelegate> delegate;
@property (readonly, nonatomic) NSArray<PhotoViewModel *> *photoViewModels;

- (void)updatePhotos;
- (void)updateWithVisibleIndexes:(NSArray<NSIndexPath *> *)indexes;
- (void)updatePhotosDownloadPriorities;
- (NSArray<NSIndexPath *> *)removePhotosWithLettersBOrD;
- (void)reoderPhotos;

@end

NS_ASSUME_NONNULL_END
