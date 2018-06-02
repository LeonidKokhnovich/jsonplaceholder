//
//  AlbumModel.h
//  JSONPlaceholder
//
//  Created by Leonid Kokhnovych on 2018-06-01.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumModel : NSObject

@property (nonatomic) NSNumber *albumId;
@property (nonatomic) NSNumber *identifier;
@property (nonatomic) NSString *title;
@property (nonatomic) NSURL *url;
@property (nonatomic) NSURL *thumbnailURL;

- (instancetype _Nullable)initWithJSON:(NSDictionary<NSString *, id> * _Nonnull)json;

@end
