//
//  TheEnemies.h
//  CocoTest
//
//  Created by Brian Hansen on 10/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Bullet.h"

@interface TheEnemies : CCNode {
    NSMutableArray *theEnemies;
    NSMutableArray *bullets;
}
@property NSMutableArray* bullets;

-(id)init;

-(void)moveBullets:(ccTime)time;
-(void)addBullet;
-(void)removeBullet:(Bullet*)bullet;
-(NSMutableArray*)getBullets;
@end
