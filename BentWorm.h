//
//  BentWorm.h
//  CocoTest
//
//  Created by Brian Hansen on 9/25/12.
//
//

#import "WormPart.h"

@interface BentWorm : CCCollisionSprite {
    BOOL willBend;
}

-(id)initWithDirectionOne:(NSInteger)directionOne andDirectionTwo:(NSInteger)directionTwo;
@end
