//
//  HomeViewDataSet.m
//  Gourmand
//
//  Created by MacMini on 3/6/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

#import "HomeViewDataSet.h"
#import "MosaicData.h"

@implementation HomeViewDataSet

#pragma mark - Private

-(void)loadFromDisk{
    NSString *pathString = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *elementsData = [NSData dataWithContentsOfFile:pathString];
    
    NSError *anError = nil;
    NSArray *parsedElements = [NSJSONSerialization JSONObjectWithData:elementsData
                                                              options:NSJSONReadingAllowFragments
                                                                error:&anError];
    
    for (NSDictionary *aModuleDict in parsedElements){
    *aMosaicModule = [[MosaicData alloc] initWithDictionary:aModuleDict];
        [elements addObject:aMosaicModule];
    }
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