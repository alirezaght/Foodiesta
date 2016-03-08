//
//  MosaicModule.h
//  MosaicUI
//
//  Created by Ezequiel Becerra on 10/21/12.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface MosaicData : NSObject{
//    NSString *imageFilename;
    PFFile *image ;
    NSString *title;
    NSString *price ;
    NSInteger size;
}

-(id)initWithDictionary:(NSDictionary *)aDict;

-(id)initWithParse:(PFObject *)parse ;


@property (strong) NSString *imageFilename;
@property (strong) NSString *title;
@property (readwrite) NSInteger size;
@property (strong) NSString *price ;
@property (strong) PFFile *image;

@end
