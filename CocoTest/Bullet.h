//
//  Bullet.h
//  CocoTest
//
//  Created by Brian Hansen on 10/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ElDirector.h"
#import "CCCollisionSprite.h"

@interface Bullet : CCCollisionSprite {
    NSInteger color;
    CGPoint velocity;
}

@property CGPoint velocity;

-(void)moveBullet:(CGFloat)distance;
-(void)changeColor;
-(NSInteger)getColor;
@end
