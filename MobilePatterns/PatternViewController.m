//
//  PatternViewController.m
//  MobilePatterns
//
//  Created by Joseph Anderson on 4/18/14.
//  Copyright (c) 2014 yoshyosh. All rights reserved.
//

#import "PatternViewController.h"
#import "UIImageView+AFNetworking.h"
#import "PatternCacheItem.h"

@interface PatternViewController ()

@property (nonatomic) RLMRealm *realm;

@end

@implementation PatternViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //Initialize realm, our local DB
        self.realm = [RLMRealm defaultRealm];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setImageWithCacheOrNetwork];
    self.appNameLabel.text = self.appName;
    self.tagsLabel.text = self.tagString;
}

- (void)setImageWithCacheOrNetwork {
    // Check local db if we have this image url
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"url = %@", [self.imageURL absoluteString]];
    RLMArray *imageCacheArray = [PatternCacheItem objectsWithPredicate:pred];
    if (imageCacheArray.count) {
        //Set UIImageView to image from cache
        PatternCacheItem *fetchedItem = imageCacheArray[0];
        NSData *imageData = fetchedItem.imgData;
        self.screenImage.image = [UIImage imageWithData:imageData];
        
        // update updated at (last seen/accessed) of this PatternCacheItem so when we sort, its at the head of the cache
        [self updateCachedImageUpdatedAt:fetchedItem];
    } else {
        // Set screen image using AFNetworking setimageWithUrl
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.imageURL];
        __weak typeof(self) weakSelf = self;
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        [self.screenImage setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            NSData *fetchedImageData = [[NSData alloc] init];
            fetchedImageData = UIImageJPEGRepresentation(image, 0.5f);
            weakSelf.screenImage.image = image;
            [weakSelf saveImageToCacheWithUrl:[weakSelf.imageURL absoluteString] andImageData:fetchedImageData];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"error fetching image w/ afnetworking: %@", [error localizedDescription]);
        }];
        
    }
}

- (void)saveImageToCacheWithUrl:(NSString *)imgUrl andImageData:(NSData *)cacheImageData {
    RLMArray *cacheSortedByRecent = [[PatternCacheItem allObjects] arraySortedByProperty:@"updatedAt" ascending:NO];
    //Doing a double request here, not sure how bad this is on performance, compared to using another NSPredicate
    RLMArray *cacheSortedByLeastRecent = [[PatternCacheItem allObjects] arraySortedByProperty:@"updatedAt" ascending:YES];
    NSUInteger currentCacheTotal = cacheSortedByRecent.count;
    NSUInteger maxCacheItemCount = 5;
    // Check how full the cache is, If its full (currentCacheTotal > 200 or something), remove items from cache until cacheTotal == 200
    if (currentCacheTotal > maxCacheItemCount) {
        //We add one to account for 0 index case
        NSUInteger overLimitCount = (currentCacheTotal - maxCacheItemCount) + 1;
        for (PatternCacheItem *item in cacheSortedByLeastRecent) {
            NSLog(@"Image to be deleted: %@, last accessed: %@", item.url, item.updatedAt);
            [self.realm beginWriteTransaction];
            [self.realm deleteObject:item];
            [self.realm commitWriteTransaction];
            overLimitCount--;
            if (overLimitCount <= 0) {
                break;
            }
        }
    }
    // Then save this item object to our local storage, to add it to cache
    [self.realm beginWriteTransaction];
    PatternCacheItem *item = [[PatternCacheItem alloc] init];
    item.url = imgUrl;
    item.imgData = cacheImageData;
    NSDate *currentDate = [NSDate date];
    item.createdAt = currentDate;
    item.updatedAt = currentDate;
    [self.realm addObject:item];
    [self.realm commitWriteTransaction];
}

// Updates the updatedAt field on a cacheItem, so we know what was most recently used
- (void)updateCachedImageUpdatedAt:(PatternCacheItem *)fetchedItem {
    [self.realm beginWriteTransaction];
    //Loops through all the properties until it finds the updatedAt field, then uses that to set the new current time
    for (RLMProperty *prop in fetchedItem.objectSchema.properties){
        if ([prop.name isEqualToString:@"updatedAt"]) {
            fetchedItem[prop.name] = [NSDate date];
        }
    }
    [self.realm commitWriteTransaction];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
