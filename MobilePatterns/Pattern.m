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
        self.picSize = dictionary[@"image"][@"size"][0];
        self.urlSuffix = dictionary[@"image"][@"suffix"];
        self.patternPicUrl = [NSString stringWithFormat:@"%@%@%@", self.urlPrefix, self.picSize, self.urlSuffix];
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

@end
