//
//  AsyncOperation.h
//  JSONPlaceholder
//
//  Created by Leonid Kokhnovych on 2018-06-01.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsyncOperation : NSOperation

// Override in subclass.
- (void)main;

// Complete the operation when done using this method.
- (void)completeOperation;

@end
