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

@interface PhotosViewController () <PhotosViewModelDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

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
    [self.collectionView performBatchUpdates:^ {
        NSArray<NSIndexPath *> *removedIndexPaths = [self.viewModel removePhotosWithLettersBOrD];
        [self.collectionView deleteItemsAtIndexPaths:removedIndexPaths];
    } completion:^(BOOL finished) {
        if (finished) {
            // Since items were removed, we need to make sure the scroll position is updated on the view model layer.
            [self.viewModel updateWithVisibleIndexes:self.collectionView.indexPathsForVisibleItems];
        }
    }];
}

- (IBAction)reorderRandomlyButtonTapped:(id)sender {
    [self.viewModel reoderPhotos];
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

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel updateWithVisibleIndexes:collectionView.indexPathsForVisibleItems];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel updateWithVisibleIndexes:collectionView.indexPathsForVisibleItems];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        [self.viewModel handleScrollFinished];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.viewModel handleScrollFinished];
}

#pragma mark - PhotosViewModelDelegate

- (void)didUpdatePhotos {
    NSLog(@"Did update photos: %tu", self.viewModel.photoViewModels.count);
    [self.collectionView reloadData];
}

- (void)didUpdatePhotoAtIndex:(NSInteger)index {
    if (index < [self.collectionView numberOfItemsInSection:0]) {
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    } else {
        [self.collectionView reloadData];
    }
}

- (void)didUpdatePhotosWithError:(NSError * _Nonnull)error {
    NSLog(@"Did update photos with error %@", error);
    // TODO: Display alert with error
}

@end
