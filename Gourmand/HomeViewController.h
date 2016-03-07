//
//  HomeViewController.h
//  Gourmand
//
//  Created by MacMini on 3/6/16.
//  Copyright © 2016 MacMini. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MosaicView.h"
#import "MosaicViewDelegateProtocol.h"

@interface HomeViewController : UIViewController <MosaicViewDelegateProtocol>{
    __weak IBOutlet MosaicView *mosaicView;
    UIImageView *snapshotBeforeRotation;
    UIImageView *snapshotAfterRotation;
}

@end