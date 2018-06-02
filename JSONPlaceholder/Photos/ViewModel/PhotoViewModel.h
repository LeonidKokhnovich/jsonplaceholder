//
//  PhotoViewModel.h
//  JSONPlaceholder
//
//  Created by Leonid Kokhnovych on 2018-06-01.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewModel : NSObject

@property (nonatomic, nonnull) NSString *title;
@property (atomic, nullable) UIImage *image;

@end
