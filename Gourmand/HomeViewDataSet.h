//
//  HomeViewDataSet.h
//  Gourmand
//
//  Created by MacMini on 3/6/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MosaicViewDatasourceProtocol.h"

@interface HomeViewDataSet : NSObject <MosaicViewDatasourceProtocol>{
    NSMutableArray *elements;
}

+ (HomeViewDataSet *)sharedInstance;

@end
