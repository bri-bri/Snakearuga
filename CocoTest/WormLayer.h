//
//  WormLayer.h
//  CocoTest
//
//  Created by Brian Hansen on 9/22/12.
//
//
#import <GameKit/GameKit.h>
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TheWorm.h"
#import "TheEnemies.h"
#import "WormDatabase.h"
#import "WormData.h"
#import "AppDelegate.h"
#import "CBHelper.h"

@interface WormLayer : CCLayer <CCStandardTouchDelegate> {
    NSString *docPath;
    NSInteger highScore;
}

@property (strong) WormData *data;
@property NSInteger highScore;
@property (copy) NSString *docPath;


- (id)init;
- (id)initWithDocPath:(NSString *)docPath;
- (void)deleteDoc;

+(CCScene *) scene;
-(void)handleSwipe:(UITouch*)touch;
-(void)handleTap;

@end
