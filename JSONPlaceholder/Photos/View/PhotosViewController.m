//
//  PhotosViewController.m
//  JSONPlaceholder
//
//  Created by Leonid Kokhnovych on 2018-06-01.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotosViewModel.h"

@interface PhotosViewController () <PhotosViewModelDelegate>

@property (nonatomic) PhotosViewModel *viewModel;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [PhotosViewModel new];
    self.viewModel.delegate = self;
    [self.viewModel updatePhotos];
}

- (void)didUpdatePhotos {
    NSLog(@"Did update photos: %tu", self.viewModel.photoViewModels.count);
}

- (void)didUpdatePhotosWithError:(NSError * _Nonnull)error {
    NSLog(@"Did update photos with error %@", error);
}

@end
