//
//  HomeViewDataSet.m
//  Gourmand
//
//  Created by MacMini on 3/6/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

#import "HomeViewDataSet.h"
#import "MosaicData.h"
#import <Parse/Parse.h>

@implementation HomeViewDataSet

#pragma mark - Private

-(void)loadFromDisk{
//    NSString *pathString = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
//    NSData *elementsData = [NSData dataWithContentsOfFile:pathString];
//    
//    NSError *anError = nil;
//    NSArray *parsedElements = [NSJSONSerialization JSONObjectWithData:elementsData
//                                                              options:NSJSONReadingAllowFragments
//                                                                error:&anError];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Cook"];
    [query includeKey:@"user"];
    [query includeKey:@"food"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error == nil) {
            for (PFObject *cell in objects) {
                MosaicData *module = [[MosaicData alloc] initWithParse:cell];
                [elements addObject:module];
            }
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"update"
             object:self];
        } else {
            NSLog(@"error in fetching home photo");
        }
    }];
    
//    for (NSDictionary *aModuleDict in parsedElements){
//    MosaicData *aMosaicModule = [[MosaicData alloc] initWithDictionary:aModuleDict];
//    [elements addObject:aMosaicModule];
//    }
}

#pragma mark - Public

-(id)init{
    self = [super init];
    
    if (self){
        elements = [[NSMutableArray alloc] init];
        [self loadFromDisk];
    }
    
    return self;
}

//  Singleton method proposed in WWDC 2012
+ (HomeViewDataSet *)sharedInstance {
    static HomeViewDataSet *sharedInstance;
    if (sharedInstance == nil)
        sharedInstance = [HomeViewDataSet new];
    return sharedInstance;
}

#pragma mark - MosaicViewDatasourceProtocol

-(NSArray *)mosaicElements{
    NSArray *retVal = elements;
    return retVal;
}

@end