//
//  AsyncOperation.m
//  JSONPlaceholder
//
//  Created by Leonid Kokhnovych on 2018-06-01.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

#import "AsyncOperation.h"

@interface AsyncOperation ()

@property (atomic, assign) BOOL _executing;
@property (atomic, assign) BOOL _finished;

@end

@implementation AsyncOperation

- (void)start;
{
    if ([self isCancelled])
    {
        [self willChangeValueForKey:@"isFinished"];
        self._finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    self._executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self main];
}

- (void)main;
{
    assert(false);
}

- (BOOL)isAsynchronous;
{
    return YES;
}

- (BOOL)isExecuting {
    return self._executing;
}

- (BOOL)isFinished {
    return self._finished;
}

- (void)completeOperation {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    self._executing = NO;
    self._finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end
