//
//  CCCollisionSprite.h
//  CocoTest
//
//  Created by Brian Hansen on 10/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ElDirector.h"

@interface CCCollisionSprite : CCSprite {
    CGFloat _scale,_scaleX,_scaleY;
    
    CCNode *collisionNode;
    CCLayerColor *nodeHighlight;
    CGRect clippingFrame;
    CGRect theFrame;
}

@property(readonly) CGFloat _scale,_scaleX,_scaleY;

-(CCCollisionSprite*)init;
-(CCCollisionSprite*)initWithFile:(NSString *)filename;
-(CCCollisionSprite*)initWithFile:(NSString *)filename andFrame:(CGRect)frame;
-(CCCollisionSprite*)initWithFile:(NSString *)filename andFrame:(CGRect)frame andCollisionFrame:(CGRect)collisionFrame;

-(CGRect)getCollisionFrame;
-(CGRect)getFrame;
-(CGRect)getClipFrame;
-(CGRect)convertRectToWorldSpace:(CGRect)rect;
-(void)setClipFrame:(CGRect)rect;


-(void)displayCollisionFrame;
-(void)displayCollisionFrameWithColor:(ccColor4B)color;
-(void)hideCollisionFrame;


@end
