//
//  NSArray+Helpers.h
//  JSONPlaceholder
//
//  Created by Leonid Kokhnovych on 2018-06-01.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Helpers)

// Swift map analog
- (NSArray *)map:(id (^)(id obj))block;

// Swift filter analog
- (NSArray *)filter:(BOOL (^)(id obj))block;

// Swift flatMap analog
- (NSArray *)flatMap:(id (^)(id obj))block;

- (NSArray *)shuffle;

@end

NS_ASSUME_NONNULL_END
