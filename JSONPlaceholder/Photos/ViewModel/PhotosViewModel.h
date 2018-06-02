//
//  PhotosViewModel.h
//  JSONPlaceholder
//
//  Created by Leonid Kokhnovych on 2018-06-01.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoViewModel.h"

@protocol PhotosViewModelDelegate <NSObject>

- (void)didUpdatePhotos;
- (void)didUpdatePhotosWithError:(NSError * _Nonnull)error;

@end

@interface PhotosViewModel : NSObject

@property (weak, nonatomic) id <PhotosViewModelDelegate> delegate;
@property (readonly, nonatomic, nonnull) NSArray<PhotoViewModel *> *photoViewModels;

- (void)updatePhotos;

@end
