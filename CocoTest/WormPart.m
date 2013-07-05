//
//  WormPart.m
//  CocoTest
//
//  Created by Brian Hansen on 9/22/12.
//
//

#import "WormPart.h"

@implementation WormPart

@synthesize wormDirection,clipFrame,isBent,isGrowing,turnNeeded;


CGFloat retina;

- (id)init
{
    retina =  CC_CONTENT_SCALE_FACTOR();
    
    self = [super initWithFile:@"snakeBody.png" andFrame:CGRectMake(200,200,WORM_WIDTH,WORM_WIDTH)];
    
    if(self){

        wormDirection = EAST;
        turnNeeded = FALSE;

        clipFrame = CGRectMake(0, 0, 0, 0);

        isBent = FALSE;
        //[self displayCollisionFrame];
    }
    return self;
}

-(void)moveWorm:(CGFloat)distance {
    
    switch (wormDirection) {
        case EAST:
            self.position = ccp(self.position.x + distance, self.position.y);
            break;
        case SOUTH:
            self.position = ccp(self.position.x, self.position.y - distance);
            break;
        case WEST:
            self.position = ccp(self.position.x - distance, self.position.y);
            break;
        case NORTH:
            self.position = ccp(self.position.x, self.position.y + distance);
            break;
        default:
            break;
    }

}

-(BOOL)changeDirection:(NSInteger)direction {
    
    
    BOOL turnNeededTrack = turnNeeded;
    NSString* imagePath;
    CGFloat bend;
    bend = [self bendWithDirectionOne:wormDirection andDirectionTwo:direction];
    
    if(wormDirection == direction){
        return false;
    }
    [self setRotation:bend];

    wormDirection = direction;

        return TRUE;
}

-(CGFloat)bendWithDirectionOne:(NSInteger)directionOne andDirectionTwo:(NSInteger)directionTwo {
    if(directionOne == directionTwo){
        isBent = FALSE;
        if(turnNeeded){
            turnNeeded = FALSE;
            switch(directionOne) {
                case NORTH:
                    return TURN_NORTH;
                    break;
                case EAST:
                    return TURN_EAST;
                    break;
                case SOUTH:
                    return TURN_SOUTH;
                    break;
                case WEST:
                    return TURN_WEST;
                    break;
            }
        }
        return 0;
    }
    
    isBent = TRUE;
    switch (directionTwo) {
        case NORTH:
            switch (directionOne) {
                case EAST:
                    return TURN_NORTH;
                    break;
                case WEST:
                    turnNeeded = TRUE;
                    return TURN_NORTH;
                    break;
                case SOUTH:
                    [self changeDirection:EAST];
                    return TURN_NORTH;
                    break;
                default:
                    return -1;
                    break;
            }
            break;
        case EAST:
            switch (directionOne) {
                case NORTH:
                    turnNeeded = TRUE;
                    return TURN_EAST;
                    break;
                case SOUTH:
                    return TURN_EAST;
                    break;
                case WEST:
                    [self changeDirection:SOUTH];
                    return TURN_EAST;
                    break;
                default:
                    return -1;
                    break;
            }
            break;
        case SOUTH:
            switch (directionOne) {
                case EAST:
                    turnNeeded = TRUE;
                    return TURN_SOUTH;
                    break;
                case WEST:
                    return TURN_SOUTH;
                    break;
                case NORTH:
                    [self changeDirection:WEST];
                    return TURN_SOUTH;
                    break;
                default:
                    return -1;
                    break;
            }
            break;
        case WEST:
            switch (directionOne) {
                case NORTH:
                    return TURN_WEST;
                    break;
                case SOUTH:
                    turnNeeded = TRUE;
                    return TURN_WEST;
                    break;
                case EAST:
                    [self changeDirection:NORTH];
                    return TURN_WEST;
                    break;
                default:
                    return -1;
                    break;
            }
            break;
        default:
            return -1;
            break;
    }
    
    
}

-(CGRect)getClipFrame {
    return clipFrame;
}

-(void)setClipFrame:(CGRect)rect {
    clipFrame = rect;
}

-(void)draw {
    if(clipFrame.size.width > 0){
        glEnable(GL_SCISSOR_TEST);
        glScissor(clipFrame.origin.x*retina-2, clipFrame.origin.y*retina-2,clipFrame.size.width*retina+2, clipFrame.size.height*retina+2);
        
        [super draw];
        glDisable(GL_SCISSOR_TEST);
    } else {
        [super draw];
    }
}


@end
