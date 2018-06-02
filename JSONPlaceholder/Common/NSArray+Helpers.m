//
//  NSArray+Helpers.m
//  JSONPlaceholder
//
//  Created by Leonid Kokhnovych on 2018-06-01.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

#import "NSArray+Helpers.h"

@implementation NSArray (Helpers)

- (NSArray *)map:(id (^)(id obj))block {
    NSMutableArray *mutableArray = [NSMutableArray new];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [mutableArray addObject:block(obj)];
    }];
    return mutableArray.copy;
}

- (NSArray *)filter:(BOOL (^)(id obj))block {
    NSMutableArray *mutableArray = [NSMutableArray new];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj) == YES) {
            [mutableArray addObject:obj];
        }
    }];
    return mutableArray.copy;
}

- (NSArray *)flatMap:(id (^)(id obj))block {
    NSMutableArray *mutableArray = [NSMutableArray new];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id _obj = block(obj);
        if ([_obj isKindOfClass:[NSArray class]]) {
            NSArray *_array = [_obj flatMap:block];
            [mutableArray addObjectsFromArray:_array];
            return;
        }
        [mutableArray addObject:_obj];
    }];
    return mutableArray.copy;
}

- (NSArray *)shuffle {
    NSUInteger count = [self count];
    NSMutableArray *mutableArray = [self mutableCopy];
    for (NSUInteger i = 0; i < count - 1; i++) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    return mutableArray.copy;
}

@end
