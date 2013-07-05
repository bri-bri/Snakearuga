//
//  WormHead.m
//  CocoTest
//
//  Created by Brian Hansen on 9/23/12.
//
//

#import "WormHead.h"

@implementation WormHead

CGFloat retina;
-(id)init {
    self = [super initWithFile:@"snakeHead.png" andFrame:CGRectMake(200,200,WORM_WIDTH,WORM_WIDTH)];
    if(self){

        wormDirection = EAST;
        //[self displayCollisionFrame];
    }
    return self;
}


-(BOOL)changeDirection:(NSInteger)direction {
    switch(direction){
        case NORTH:
            if(wormDirection != SOUTH && wormDirection !=NORTH){
            [self setRotation:TURN_NORTH];
            self.scaleX = fabs(self.scaleX);
            wormDirection = direction;
                return true;
            } else if (wormDirection == SOUTH){
                [self changeDirection:EAST];
                [self changeDirection:NORTH];
            }
            break;
        case EAST:
            if(wormDirection != WEST && wormDirection !=EAST){
            [self setRotation:TURN_EAST];
            self.scaleX = fabs(self.scaleX);;
            self.scaleY = fabs(self.scaleY);;
            wormDirection = direction;
                return true;
            } else if (wormDirection == WEST){
                [self changeDirection:SOUTH];
                [self changeDirection:EAST];
            }
            break;
        case SOUTH:
            if(wormDirection != NORTH && wormDirection != SOUTH){
            [self setRotation:TURN_SOUTH];
            self.scaleX = fabs(self.scaleX);;
            wormDirection = direction;
                return true;
            } else if (wormDirection == NORTH){
                [self changeDirection:EAST];
                [self changeDirection:SOUTH];
            }
            break;
        case WEST:
            if(wormDirection != EAST && wormDirection !=WEST){
            [self setRotation:TURN_WEST];
            self.scaleY = -1*fabs(self.scaleY);
            wormDirection = direction;
                return true;
            } else if (wormDirection == EAST){
                [self changeDirection:SOUTH];
                [self changeDirection:WEST];
            }
            break;
        default:
            return false;
            break;
    }
    return false;
}

@end
