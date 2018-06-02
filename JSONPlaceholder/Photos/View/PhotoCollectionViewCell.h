//
//  PhotoCollectionViewCell.h
//  JSONPlaceholder
//
//  Created by Leonid Kokhnovych on 2018-06-01.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PhotoViewModel;

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

+ (NSString *)reuseIdentifier;
+ (CGSize)expectedSize;
- (void)setupWithViewModel:(PhotoViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
