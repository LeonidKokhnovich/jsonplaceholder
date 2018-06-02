//
//  AlbumServiceProvider.h
//  JSONPlaceholder
//
//  Created by Leonid Kokhnovych on 2018-06-01.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AlbumModel;

@interface AlbumServiceProvider : NSObject

+ (instancetype)shared;

- (void)fetchAlbumsWithCompletion:(void (^ _Nonnull)(NSArray<AlbumModel *> * _Nullable, NSError * _Nullable))completion;

@end
