//
//  PatternCacheItem.h
//  MobilePatterns
//
//  Created by Joseph Anderson on 7/20/14.
//  Copyright (c) 2014 yoshyosh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@class PatternImageData;

@interface PatternCacheItem : RLMObject

@property (nonatomic) NSString *url;
@property (nonatomic) NSData *imgData;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSDate *updatedAt;

@end
