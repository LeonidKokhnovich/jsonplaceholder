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

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGFloat rotationInRadians = 45 * M_PI / 180;
    self.titleLabel.layer.affineTransform = CGAffineTransformRotate(CGAffineTransformIdentity, rotationInRadians);
    
    self.photoImageView.layer.cornerRadius = 10.0;
    self.photoImageView.layer.borderWidth = 5.0;
    self.photoImageView.layer.borderColor = [[UIColor blackColor] CGColor];
}

- (void)setupWithViewModel:(PhotoViewModel * _Nonnull)viewModel {
    self.photoImageView.image = viewModel.image;
    self.titleLabel.text = viewModel.title;
}

@end
