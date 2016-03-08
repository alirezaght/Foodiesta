//
//  MosaicModule.m
//  MosaicUI
//
//  Created by Ezequiel Becerra on 10/21/12.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import "MosaicData.h"

@implementation MosaicData
@synthesize imageFilename, title, size;

-(id)initWithDictionary:(NSDictionary *)aDict{
    self = [self init];
    if (self){
        self.imageFilename = [aDict objectForKey:@"imageFilename"];
        self.size = [[aDict objectForKey:@"size"] integerValue];
        self.title = [aDict objectForKey:@"title"];
        self.price = @"10.99" ;
    }
    return self;
}


-(id)initWithParse:(PFObject *)parse{
    self = [self init];
    if(self){
        self.image = parse[@"photo"];
        self.price = [parse[@"price"] stringValue] ;
        self.title = parse[@"food"][@"name"];
        self.size = [parse[@"type"] integerValue ];
    }
    return self;
}




-(NSString *)description{
    NSString *retVal = [NSString stringWithFormat:@"%@ %@", [super description], self.title];
    return retVal;
}

@end
