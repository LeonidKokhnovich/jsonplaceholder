//
//  URLTask.h
//  JSONPlaceholder
//
//  Created by Leonid Kokhnovych on 2018-06-01.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

#ifndef URLTask_h
#define URLTask_h

typedef NS_ENUM(NSInteger, URLTaskErrorCode) {
    URLTaskErrorCodeInvalidURL,
    URLTaskErrorCodeInvalidResponse,
    URLTaskErrorCodeRequestFailed,
    URLTaskErrorCodeInvalidData,
    URLTaskErrorCodeUnableToParse
};

#endif /* URLTask_h */
