//
//  PhotosViewController.m
//  JSONPlaceholder
//
//  Created by Leonid Kokhnovych on 2018-06-01.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotosViewModel.h"
#import "PhotoCollectionViewCell.h"

@interface PhotosViewController () <PhotosViewModelDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) PhotosViewModel *viewModel;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [PhotosViewModel new];
    self.viewModel.delegate = self;
    [self.viewModel updatePhotos];
}

- (IBAction)removeButtonTapped:(id)sender {
    
}

- (IBAction)reorderRandomlyButtonTapped:(id)sender {

}

#pragma mark - UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.photoViewModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PhotoCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    PhotoViewModel *viewModel = self.viewModel.photoViewModels[indexPath.row];
    [cell setupWithViewModel:viewModel];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [PhotoCollectionViewCell expectedSize];
}

#pragma mark - PhotosViewModelDelegate

- (void)didUpdatePhotos {
    NSLog(@"Did update photos: %tu", self.viewModel.photoViewModels.count);
    [self.collectionView reloadData];
}

- (void)didUpdatePhotosWithError:(NSError * _Nonnull)error {
    NSLog(@"Did update photos with error %@", error);
}

@end
