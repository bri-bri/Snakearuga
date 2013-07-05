//
//  ElDirector.m
//  CocoTest
//
//  Created by Brian Hansen on 10/3/12.
//
//

#import "ElDirector.h"

@implementation ElDirector

+(void)changeColor:(CCSprite *)sprite withColor:(NSInteger)color {
    if(color == 0) {
        sprite.blendFunc = (ccBlendFunc) { GL_ONE, GL_ONE };
        sprite.color = ccc3(144, 144, 144);
    } else if(color == 1) {
        sprite.blendFunc = (ccBlendFunc) { GL_ONE, GL_ONE_MINUS_SRC_ALPHA };
        sprite.color = ccc3(94, 94, 94);
    }
    
}

@end
