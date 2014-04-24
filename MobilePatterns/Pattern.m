//
//  Pattern.m
//  MobilePatterns
//
//  Created by Joseph Anderson on 4/21/14.
//  Copyright (c) 2014 yoshyosh. All rights reserved.
//

#import "Pattern.h"

@implementation Pattern

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self){
        self.appName = dictionary[@"app"];
        self.tags = dictionary[@"tags"];
        self.platform = dictionary[@"platform"];
        self.urlPrefix = dictionary[@"image"][@"prefix"];
        self.picSize = dictionary[@"image"][@"sizes"][0];
        self.urlSuffix = dictionary[@"image"][@"suffix"];
        
        NSString *concatenatedUrl = [NSString stringWithFormat:@"%@%@%@", self.urlPrefix, self.picSize, self.urlSuffix];
        self.patternPicUrl = [concatenatedUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return self;
}

+ (NSArray *)patternsWithArray:(NSArray *)array {
    NSMutableArray *patterns = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in array) {
        Pattern *pattern = [[Pattern alloc] initWithDictionary:dictionary];
        [patterns addObject:pattern];
    }
    return patterns;
}

+ (NSArray *)allPatternNames:(NSArray *)array {
    NSMutableArray *names = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in array) {
        NSString *appName = dictionary[@"name"];
        [names addObject:appName];
    }
    return names;
}

+ (NSString *)buildPatternUrlRequest:(NSString *)string {
    NSString *beginUrl = @"http://mobile-patterns.com/api/v1/patterns?app=";
    NSString *finalParams = @"&sort=newest&limit=5";
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@%@", beginUrl, string, finalParams];
    NSString *webUrl = [fullUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //Figure out best way/patterns to build URLs
    return webUrl;
}

@end
