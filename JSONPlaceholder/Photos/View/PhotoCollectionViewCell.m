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

+ (CGSize)estimatedSize {
    return CGSizeMake(100, 100);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGFloat rotationInRadians = 45 * M_PI / 180;
    self.titleLabel.layer.affineTransform = CGAffineTransformRotate(CGAffineTransformIdentity, rotationInRadians);
    
    CGFloat cornerRadius = 10.0;
    self.photoImageView.layer.cornerRadius = cornerRadius;
    self.photoImageView.layer.borderWidth = 5.0;
    self.photoImageView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    CAShapeLayer *shadowLayer = [[CAShapeLayer alloc] init];
    shadowLayer.path = [[UIBezierPath bezierPathWithRoundedRect:self.photoImageView.frame cornerRadius:cornerRadius] CGPath];
    shadowLayer.fillColor = [[UIColor whiteColor] CGColor];
    shadowLayer.shadowColor = [[UIColor grayColor] CGColor];
    shadowLayer.shadowPath = shadowLayer.path;
    shadowLayer.shadowOffset = CGSizeMake(5.0, 5.0);
    shadowLayer.shadowOpacity = 1.0;
    shadowLayer.shadowRadius = 2;
    [self.contentView.layer insertSublayer:shadowLayer atIndex:0];
}

- (void)setupWithViewModel:(PhotoViewModel * _Nonnull)viewModel {
    self.photoImageView.image = viewModel.image;
    self.titleLabel.text = viewModel.title;
}

@end
