//
//  Pattern.h
//  MobilePatterns
//
//  Created by Joseph Anderson on 4/21/14.
//  Copyright (c) 2014 yoshyosh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pattern : NSObject

@property (nonatomic) NSString *appName;
@property (nonatomic) NSArray *tags;
@property (nonatomic) NSString *platform;
@property (nonatomic) NSString *urlPrefix;
@property (nonatomic) NSString *urlSuffix;
@property (nonatomic) NSString *picSize;
@property (nonatomic) NSString *patternPicUrl;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)patternsWithArray:(NSArray *)array;
+ (NSArray *)allPatternNames:(NSArray *)array;
+ (NSString *)buildPatternUrlRequest:(NSString *)string;
+ (NSString *)buildPatternTagUrlRequest:(NSString *)string;
@end
