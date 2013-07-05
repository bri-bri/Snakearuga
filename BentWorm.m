//
//  BentWorm.m
//  CocoTest
//
//  Created by Brian Hansen on 9/25/12.
//
//

#import "BentWorm.h"
#import "AppDelegate.h"

@implementation BentWorm

CGFloat retina;

-(id)initWithDirectionOne:(NSInteger)directionOne andDirectionTwo:(NSInteger)directionTwo {
    retina =  CC_CONTENT_SCALE_FACTOR();
    if(self = [super initWithFile:@"snakeBend.png" andFrame:CGRectMake(0,0,WORM_WIDTH,WORM_WIDTH)]){
        
        willBend = TRUE;
        
        switch(directionTwo){
            case NORTH:
                if(directionOne == EAST)
                    [self setRotation:TURN_NORTH];
                else if(directionOne == WEST)
                    [self setRotation:TURN_EAST];
                else
                    self = nil;
                break;
            case EAST:
                if(directionOne == SOUTH)
                    [self setRotation:TURN_EAST];
                else if(directionOne == NORTH)
                    [self setRotation:TURN_SOUTH];
                else
                    self = nil;
                break;
            case SOUTH:
                if(directionOne == WEST)
                    [self setRotation:TURN_SOUTH];
                else if(directionOne == EAST)
                    [self setRotation:TURN_WEST];
                else
                    self = nil;
                break;
            case WEST:
                if(directionOne == NORTH)
                    [self setRotation:TURN_WEST];
                else if(directionOne == SOUTH)
                    [self setRotation:TURN_NORTH];
                else
                    self = nil;
                break;
            default:
                self = nil;
                break;
        }
        
    }

    return self;
}

-(void)draw {
    if(willBend){

        CCSpriteFrame *selfFrame = self.displayFrame;
        
        CGRect clipRect = selfFrame.rect;
        
        //glEnable(GL_SCISSOR_TEST);
        
        CCDirector *director = [CCDirector sharedDirector];
        CGSize size = [director winSize];
        CGPoint origin = [self convertToWorldSpaceAR:clipRect.origin];
        CGPoint topRight = [self convertToWorldSpaceAR:ccpAdd(clipRect.origin, ccp(clipRect.size.width, clipRect.size.height))];
        CGRect scissorRect = CGRectMake(origin.x, origin.y, abs(topRight.x-origin.x), abs(topRight.y-origin.y));
        
        // transform the clipping rectangle to adjust to the current screen
        // orientation: the rectangle that has to be passed into glScissor is
        // always based on the coordinate system as if the device was held with the
        // home button at the bottom. the transformations account for different
        // device orientations and adjust the clipping rectangle to what the user
        // expects to happen.
        
        // Handle Retina
        scissorRect = CC_RECT_POINTS_TO_PIXELS(scissorRect);
        
        glScissor(scissorRect.origin.x, scissorRect.origin.y,scissorRect.size.width, scissorRect.size.height);
    //glScissor(bentWorm.position.x, bentWorm.position.y, 61, 61);
        [super draw];
        glDisable(GL_SCISSOR_TEST);
    } else {
        [super draw];
    }
}

@end
