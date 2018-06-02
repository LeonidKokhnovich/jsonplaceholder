//
//  AlbumModel.m
//  JSONPlaceholder
//
//  Created by Leonid Kokhnovych on 2018-06-01.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

#import "AlbumModel.h"

static NSString *AlbumModelCodableKeyAlbumId = @"albumId";
static NSString *AlbumModelCodableKeyId = @"id";
static NSString *AlbumModelCodableKeyTitle = @"title";
static NSString *AlbumModelCodableKeyURL = @"url";
static NSString *AlbumModelCodableKeyThumbnailURL = @"thumbnailUrl";

@implementation AlbumModel

- (instancetype _Nullable)initWithJSON:(NSDictionary<NSString *, id> * _Nonnull)json {
    if (self = [super init]) {
        NSNumber *identifier = [json objectForKey:AlbumModelCodableKeyId];
        if (identifier == nil || [identifier isKindOfClass:[NSNumber class]] == NO) {
            return nil;
        }
        
        NSNumber *albumId = [json objectForKey:AlbumModelCodableKeyAlbumId];
        if (albumId == nil || [albumId isKindOfClass:[NSNumber class]] == NO) {
            return nil;
        }
        
        NSString *title = [json objectForKey:AlbumModelCodableKeyTitle];
        if (title == nil || [title isKindOfClass:[NSString class]] == NO) {
            return nil;
        }
        
        NSString *urlString = [json objectForKey:AlbumModelCodableKeyURL];
        if (urlString == nil || [urlString isKindOfClass:[NSString class]] == NO) {
            return nil;
        }
        
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        if (url == nil) {
            return nil;
        }
        
        NSString *thumbnailURLString = [json objectForKey:AlbumModelCodableKeyThumbnailURL];
        if (thumbnailURLString == nil || [thumbnailURLString isKindOfClass:[NSString class]] == NO) {
            return nil;
        }
        
        NSURL *thumbnailURL = [[NSURL alloc] initWithString:thumbnailURLString];
        if (thumbnailURLString == nil) {
            return nil;
        }
        
        self.identifier = identifier;
        self.albumId = albumId;
        self.title = title;
        self.url = url;
        self.thumbnailURL = thumbnailURL;
        
        return self;
    } else {
        return nil;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    AlbumModel *copy = [[[self class] alloc] init];
    if (copy) {
        copy.albumId = self.albumId;
        copy.identifier = self.identifier;
        copy.title = self.title;
        copy.url = self.url;
        copy.thumbnailURL = self.thumbnailURL;
    }
    return copy;
}

- (NSUInteger)hash {
    return self.identifier.hash;
}

- (BOOL)isEqual:(id)object {
    if ([super isEqual:object]) {
        return YES;
    } else if ([object isKindOfClass:[self class]]) {
        AlbumModel *otherModel = (AlbumModel *)object;
        return self.identifier == otherModel.identifier;
    } else {
        return NO;
    }
}

@end
