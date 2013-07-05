//
//  ViewController.h
//  WormVine
//
//  Created by Brian Hansen on 8/25/12.
//  Copyright (c) 2012 Vinesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TheWorm.h"

@interface ViewController : UIViewController {
    TheWorm *theModel;
}

-(void)startTiming;

-(void)handleSwipe:(UISwipeGestureRecognizer*) swipe;
@end
