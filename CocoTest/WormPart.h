//
//  WormPart.h
//  CocoTest
//
//  Created by Brian Hansen on 9/22/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCCollisionSprite.h"

#define TURN_NORTH -90
#define TURN_SOUTH 90
#define TURN_WEST 180
#define TURN_EAST 0

#define GROWING 1
#define NORMAL 0
#define SHRINKING -1

#define NORTH 0
#define EAST 1
#define SOUTH 2
#define WEST 3
#define HORIZONTAL 1
#define VERTICAL 2

@interface WormPart : CCCollisionSprite {
    NSInteger wormDirection;
    BOOL isBent;
    NSInteger isGrowing;
    BOOL turnNeeded;
    
    CGRect clipFrame;
}

@property NSInteger wormDirection, isGrowing;
@property BOOL isBent, turnNeeded;
@property CGRect clipFrame;

-(id)init;
-(void)moveWorm:(CGFloat)distance;
-(BOOL)changeDirection:(NSInteger)direction;
-(CGFloat)bendWithDirectionOne:(NSInteger)directionOne andDirectionTwo:(NSInteger)directionTwo;

@end
