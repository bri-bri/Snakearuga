//
//  CCCollisionSprite.m
//  CocoTest
//
//  Created by Brian Hansen on 10/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCCollisionSprite.h"


@implementation CCCollisionSprite
CGFloat retina;
@synthesize _scale,_scaleX,_scaleY;

-(id)initWithFile:(NSString *)filename {
    if(self = [super initWithFile:filename]){
        retina =  CC_CONTENT_SCALE_FACTOR();
        _scale,_scaleX,_scaleY=1;
        
        collisionNode = [[CCNode alloc] init];
        collisionNode.contentSize = CGSizeMake(self.contentSize.width-self.contentSize.width/4,
                                               self.contentSize.height-self.contentSize.height/4);
        CGPoint tempPoint = self.position;
        tempPoint.x = tempPoint.x + (self.contentSize.width - collisionNode.contentSize.width)/2;
        tempPoint.y = tempPoint.y + (self.contentSize.height - collisionNode.contentSize.height)/2;
        collisionNode.position = tempPoint;
        
        theFrame = CGRectMake(0,0,self.contentSize.width,self.contentSize.height);
        clippingFrame = CGRectMake(0,0,0,0);
        [self addChild:collisionNode];
    }
    return self;
}

-(id)initWithFile:(NSString *)filename andFrame:(CGRect)frame {
    if(self = [self initWithFile:filename]){
        
        theFrame = frame;
        _scale = 1;
        _scaleX = frame.size.width/self.contentSize.width;
        _scaleY = frame.size.height/self.contentSize.height;
        if(_scaleX == _scaleY)
            _scale = _scaleX;
        
        self.scaleX = _scaleX;
        self.scaleY = _scaleY;

        collisionNode = [[CCNode alloc] init];
        
        collisionNode.contentSize = CGSizeMake(self.contentSize.width - self.contentSize.width/4,
                                               self.contentSize.height - self.contentSize.height/3);

        CGPoint tempPoint = self.position;
        tempPoint.x = tempPoint.x + (self.contentSize.width - collisionNode.contentSize.width)/2;
        tempPoint.y = tempPoint.y + (self.contentSize.height - collisionNode.contentSize.height)/2;
        collisionNode.position = tempPoint;
        
        self.position = ccp(frame.origin.x,frame.origin.y);
        theFrame = CGRectMake(0,0,self.contentSize.width,self.contentSize.height);
        [self addChild:collisionNode];
    }
    return self;
}
-(id)initWithFile:(NSString *)filename andFrame:(CGRect)frame andLocalCollisionFrame:(CGRect)collisionFrame {
    if(self = [self initWithFile:filename andFrame:frame]){
        self.position = ccp(0,0);
        collisionNode.position = ccp(0,0);
        collisionNode.contentSize = CGSizeMake(collisionFrame.size.width,collisionFrame.size.height);
        collisionNode.position = ccp(collisionFrame.origin.x,collisionFrame.origin.y);
        self.position = ccp(frame.origin.x,frame.origin.y);
    }
    return self;
}

-(id)initWithFile:(NSString *)filename andFrame:(CGRect)frame andWorldCollisionFrame:(CGRect)collisionFrame {
    if(self = [self initWithFile:filename andFrame:frame]){
        self.position = ccp(0,0);
        collisionNode.position = ccp(0,0);
        collisionNode.contentSize = CGSizeMake(collisionFrame.size.width,collisionFrame.size.height);
        collisionNode.position = [self convertToNodeSpace:ccp(collisionFrame.origin.x,collisionFrame.origin.y)];
        self.position = ccp(frame.origin.x,frame.origin.y);
    }
    return self;
}

-(CGRect)convertRectToWorldSpace:(CGRect)rect {
    CGPoint worldPoint = [self convertToWorldSpace:rect.origin];
    CGPoint maxPoint = [self convertToWorldSpace:ccp(rect.origin.x+rect.size.width,rect.origin.y+rect.size.height)];
    CGFloat minX = MIN(worldPoint.x,maxPoint.x);
    CGFloat maxX = MAX(worldPoint.x, maxPoint.x);
    CGFloat minY = MIN(worldPoint.y, maxPoint.y);
    CGFloat maxY = MAX(worldPoint.y,maxPoint.y);
    
    worldPoint = ccp(minX,minY);
    return CGRectMake(worldPoint.x,worldPoint.y,maxX-minX,maxY-minY);
}

-(CGRect)getFrame {

    return [self convertRectToWorldSpace:theFrame];
}

-(CGRect)getClipFrame {
    return clippingFrame;
}

-(void)setClipFrame:(CGRect)rect {
    clippingFrame = rect;
}

-(CGRect)getCollisionFrame {
    return [self convertRectToWorldSpace:CGRectMake(collisionNode.position.x,collisionNode.position.y,collisionNode.contentSize.width,collisionNode.contentSize.height)];
}

-(void)displayCollisionFrame {
    nodeHighlight = [[CCLayerColor alloc] initWithColor:ccc4(244, 20, 80, 100)];
    nodeHighlight.contentSize = collisionNode.contentSize;
    [collisionNode addChild:nodeHighlight];
}

-(void)displayCollisionFrameWithColor:(ccColor4B)color {
    nodeHighlight = [[CCLayerColor alloc] initWithColor:color];
    nodeHighlight.contentSize = collisionNode.contentSize;
    [collisionNode addChild:nodeHighlight];
}

-(void)stampCollisionFrame {
    if(self.parent){
    nodeHighlight = [[CCLayerColor alloc] initWithColor:ccc4(244, 20, 80, 100)];
    nodeHighlight.contentSize = collisionNode.contentSize;
    [self.parent addChild:nodeHighlight];
        
        //need to convert position to world space!
    }
}

-(void)stampCollisionFrameWithColor:(ccColor4B)color {
    if(self.parent){
    nodeHighlight = [[CCLayerColor alloc] initWithColor:ccc4(244, 20, 80, 100)];
    nodeHighlight.contentSize = collisionNode.contentSize;
    [self.parent addChild:nodeHighlight];
        
        //need to convert position to world space!
    }
}

-(void)hideCollisionFrame {
    [collisionNode removeChild:nodeHighlight cleanup:FALSE];
}

-(void)draw {
    if(clippingFrame.size.width > 0){
        NSLog(@"CLIP");
        [super draw];
    } else {
        [super draw];
    }
}

@end
