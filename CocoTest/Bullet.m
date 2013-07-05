//
//  Bullet.m
//  CocoTest
//
//  Created by Brian Hansen on 10/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Bullet.h"


@implementation Bullet

@synthesize velocity;

-(id)init {
    
    if(self = [super initWithFile:@"bullet.png" andFrame:CGRectMake(-10,-10,10,10)]){
        velocity = ccp(0.5,0.5);
        color = BLACK;
        [ElDirector changeColor:self withColor:BLACK];
    }
    return self;
}

-(NSInteger)getColor {
    return color;
}

-(void)moveBullet:(CGFloat)distance {
    
    CGPoint tempPosition = self.position;
    CGFloat length = sqrt(velocity.x*velocity.x + velocity.y*velocity.y);
    CGFloat ratioX = fabs(velocity.x/length);
    CGFloat ratioY = fabs(velocity.y/length);
    tempPosition.x = self.position.x + velocity.x*ratioX*distance;
    tempPosition.y = self.position.y + velocity.y*ratioY*distance;
    self.position = tempPosition;
}

-(void)changeColor {
    color = abs(color-1);
    [ElDirector changeColor:self withColor:color];
}

@end
