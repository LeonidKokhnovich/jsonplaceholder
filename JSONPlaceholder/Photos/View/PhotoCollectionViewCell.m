//
//  PhotoCollectionViewCell.m
//  JSONPlaceholder
//
//  Created by Leonid Kokhnovych on 2018-06-01.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "PhotoViewModel.h"

@implementation PhotoCollectionViewCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([PhotoCollectionViewCell class]);
}

+ (CGSize)expectedSize {
    return CGSizeMake(100, 100);
}

- (void)setupWithViewModel:(PhotoViewModel * _Nonnull)viewModel {
    self.photoImageView.image = viewModel.image;
    self.titleLabel.text = viewModel.title;
}

@end
