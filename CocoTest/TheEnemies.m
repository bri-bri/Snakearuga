//
//  TheEnemies.m
//  CocoTest
//
//  Created by Brian Hansen on 10/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TheEnemies.h"


@implementation TheEnemies

CGSize  winSize;
-(id)init {
    if(self = [super init]){
        
        winSize = [[CCDirector sharedDirector] winSize];
        theEnemies = [[NSMutableArray alloc] init];
        bullets = [[NSMutableArray alloc] init];
        [self addBullet];

    }
    return self;
}

-(void)addBullet {
    Bullet* newBullet = [[Bullet alloc] init];
    CGFloat position = rand()%100+1;
    CGFloat position2 = rand()%100+1;
    CGPoint velocity = newBullet.velocity;
    CGPoint origin = newBullet.position;
    CGFloat multiplier = 1;
    CGFloat multiplier2 = 1;
    

    if(position > 50){
        multiplier *= -1;
    }
    if(position2 > 50){
        multiplier2 *= -1;
    }
 
    origin.y += winSize.height * position/100;
    velocity.y *= multiplier;
    origin.x += winSize.width * position2/100;
    velocity.x *= multiplier2;
    
    if(rand()%2 ==1){
        if(multiplier < 0)
            origin.y = winSize.height;
        else
            origin.y = -10;
    } else {
        if(multiplier2 < 0)
            origin.x = winSize.width;
        else
            origin.x = -10;
    }
    newBullet.position = origin;
    newBullet.velocity = velocity;

    if(rand()%2 == 1){
        [newBullet changeColor];
    }
    
    [bullets addObject:newBullet];
    [self addChild:newBullet];
}

-(void)removeBullet:(Bullet *)bullet {
    [bullets removeObject:bullet];
    [self removeChild:bullet cleanup:TRUE];
}

-(void)moveBullets:(ccTime)time {
    for(int i=0; i< [bullets count];i++){
        Bullet *tempBullet = bullets[i];
        CGPoint bulletPosition = tempBullet.position;
        [tempBullet moveBullet:time*1];
        if(bulletPosition.x > winSize.width || bulletPosition.y > winSize.height || bulletPosition.x < -10 || bulletPosition.y < -10)
            [self removeBullet:tempBullet];
    }
}

-(NSMutableArray*)getBullets {
    return bullets;
}
@end
