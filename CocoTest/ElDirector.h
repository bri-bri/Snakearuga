//
//  ElDirector.h
//  CocoTest
//
//  Created by Brian Hansen on 10/3/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ShellObject.h"

#define WHITE 0
#define BLACK 1


#define WORM_WIDTH 25

@interface ElDirector : NSObject

+(void)changeColor:(CCSprite*)sprite withColor:(NSInteger)color;

@end
