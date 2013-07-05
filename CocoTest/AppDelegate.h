//
//  AppDelegate.h
//  CocoTest
//
//  Created by Brian Hansen on 9/22/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "Chartboost.h"
#import "CBHelper.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;
    
    BOOL chartboostDefault_,chartboostTest_;
    Chartboost *chartboost_;
	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (readonly) Chartboost *chartboost_;
@property BOOL chartboostDefault_,chartboostTest_;

@end
