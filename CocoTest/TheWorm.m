//
//  TheWorm.m
//  CocoTest
//
//  Created by Brian Hansen on 9/23/12.
//
//

#import "TheWorm.h"

@implementation TheWorm

@synthesize growing,theDirection;

CGFloat retina;
CGFloat winWidth;
CGFloat winHeight;
CCLayerColor *boxTracker;

-(id)init {
    
    self = [super init];
    if(self){
        
    retina =  CC_CONTENT_SCALE_FACTOR();
        
    theWorm = [[NSMutableArray alloc] init];
    bentWorms = [[NSMutableArray alloc] init];
    ghostWorms = [[NSMutableArray alloc] init];
    
    WormHead *wormHead = [[WormHead alloc] init];
    theDirection = wormHead.wormDirection;
    
        noTurn = FALSE;
        WormHead *ghostHead = [[WormHead alloc] init];
        [ghostHead changeDirection:wormHead.wormDirection];
        [ghostWorms addObject:ghostHead];
    [theWorm addObject:wormHead];
    [self addChild:wormHead];
        color = BLACK;

        for(int i = 0; i<5; i++){
            [self growWorm];
        }
    
        NSLog(@"WinSize:(%f,%f)", [CCDirector sharedDirector].winSize.width,[CCDirector sharedDirector].winSize.height);
    }
    
    return self;
}

-(void)moveWorm:(CGFloat)distance {
    WormHead* tempHead = theWorm[0];
    [tempHead moveWorm:distance];
    [[ghostWorms objectAtIndex:0] moveWorm:distance];
                [self isInBounds:0];
    
for(int i = 1; i< [theWorm count]; i++){
    WormPart* tempPart = [theWorm objectAtIndex:i];
        if(tempPart.isGrowing != 1){
            [[ghostWorms objectAtIndex:i] moveWorm:distance];
            [tempPart moveWorm:distance];
            [self isInBounds:i];
        }

    }
    [self checkSelfCollision];
}

-(void)growWorm {
    
    WormPart *tempWorm = [theWorm objectAtIndex:[theWorm count]-1];
    
    WormPart *newPart = [[WormPart alloc] init];
    [newPart changeDirection:tempWorm.wormDirection];
    WormPart *ghostWorm = [[WormPart alloc] init];
    [ghostWorm changeDirection:tempWorm.wormDirection];
    
    newPart.isGrowing = 1;
    newPart.position = tempWorm.position;
    [theWorm addObject:newPart];
    [ghostWorms addObject:ghostWorm];
    [self addChild:newPart];
    [self refreshColor];
}

-(void)turnWorm:(NSInteger) direction {
    
    [self shuffleWorm];
    

    WormHead* tempPart = [theWorm objectAtIndex:0];
    CGPoint tempPoint = tempPart.position;
    
    if(tempPoint.x > winWidth-WORM_WIDTH/2 || tempPoint.x < 0 || tempPoint.y > winHeight-WORM_WIDTH/2 || tempPoint.y < 0){
        noTurn = TRUE;
    } else {
        noTurn = FALSE;
    }
    
    if(!noTurn){
    NSInteger headDirection = tempPart.wormDirection;
    
    if([tempPart changeDirection:direction]){
        bentWorm = [[BentWorm alloc] initWithDirectionOne:headDirection andDirectionTwo:direction];
        bentWorm.position = tempPoint;
        if(bentWorm){
            [self addChild:bentWorm];
            theDirection = direction;
            
            WormPart* wormB = [theWorm objectAtIndex:1];
            wormB.clipFrame = [wormB getFrame];
            [bentWorms addObject:bentWorm];
            [self refreshColor];
        }
    }
        
    }
}

-(void)shuffleWorm {
    WormPart* wormA;
    WormPart* wormB;
    WormPart* wormAA;
 
    
    wormB = [theWorm objectAtIndex:[theWorm count]-1];
    for(int i = [theWorm count]-1; i > 0; i--){
        wormA = [theWorm objectAtIndex:i-1];
        wormB.clipFrame = wormA.clipFrame;

        if([wormB changeDirection:wormA.wormDirection]){
            if(i==1){
                wormB.clipFrame = [wormA getFrame];
            } else if(i==[theWorm count]-1){
                wormB.clipFrame = CGRectMake(0,0,0,0);
            } else {
                    wormAA = theWorm[i-2];
                    if(wormA.wormDirection != wormAA.wormDirection){
                        wormB.clipFrame = [wormAA getFrame];
                    }
            }
            [wormB draw];
        }

        wormB.isGrowing = wormA.isGrowing;
        wormB = wormA;
    }

    wormA.isBent = FALSE;
    if([bentWorms count] > 0){

    }
        [self clearBends];
}

-(void)isInBounds:(NSInteger)index {
    
    BOOL needsGhost = FALSE;
    CGPoint origin;
    winWidth = [[CCDirector sharedDirector] winSize].width;
    winHeight = [[CCDirector sharedDirector] winSize].height;
    WormPart* checkPart = theWorm[index];
        
        switch (checkPart.wormDirection) {
            case EAST:
                if(checkPart.position.x > winWidth-WORM_WIDTH/2) {
                    needsGhost = TRUE;
                    origin = checkPart.position;
                    checkPart.position = ccp(checkPart.position.x - winWidth - WORM_WIDTH, checkPart.position.y);
                }
                break;
            case SOUTH:
                if(checkPart.position.y < WORM_WIDTH/2) {
                    needsGhost = TRUE;
                    origin = checkPart.position;
                    checkPart.position = ccp(checkPart.position.x, checkPart.position.y + winHeight + WORM_WIDTH);
                }
                break;
            case WEST:
                if(checkPart.position.x < WORM_WIDTH/2) {
                    needsGhost = TRUE;
                    origin = checkPart.position;
                    checkPart.position = ccp(checkPart.position.x + winWidth + WORM_WIDTH, checkPart.position.y);
                }
                break;
            case NORTH:
                if(checkPart.position.y > winHeight-WORM_WIDTH/2) {
                    needsGhost = TRUE;
                    origin = checkPart.position;
                    checkPart.position = ccp(checkPart.position.x, checkPart.position.y - winHeight - WORM_WIDTH);
                }
                break;
            default:
                break;
        }

    if(needsGhost){
        WormPart* ghostWorm = [ghostWorms objectAtIndex:index];
        ghostWorm.position = origin;
        checkPart.clipFrame = CGRectMake(0,0,0,0);
        [ghostWorm changeDirection:checkPart.wormDirection];
        ghostWorm.scaleY = checkPart.scaleY;
        if(ghostWorm.parent != self)
        [self addChild:ghostWorm];
        if(index > 0)
            [self removeChild:[ghostWorms objectAtIndex:index-1] cleanup:FALSE];
        else
            [self removeChild:[ghostWorms objectAtIndex:[ghostWorms count]-1] cleanup:FALSE];
    }

}

-(void)checkSelfCollision {

    WormHead* tempHead = [theWorm objectAtIndex:0];
    for(int i = 3; i<[theWorm count]; i++){
        WormPart* tempWorm = theWorm[i];
        if(CGRectIntersectsRect([tempHead getCollisionFrame], [tempWorm getCollisionFrame]) && tempWorm.isGrowing < 1){

            [self chopWorm:tempWorm];
            return;
        }
    }
}

-(NSInteger)checkCollision:(Bullet*)sprite {
    CGRect checkFrame = [sprite getCollisionFrame];
    for(int i = 0; i<[theWorm count]; i++){
        WormPart* tempWorm = theWorm[i];
        if(CGRectIntersectsRect(checkFrame, [tempWorm getCollisionFrame]) && tempWorm.isGrowing < 1){
            if([sprite getColor] != [self getColor]){
            [self chopWorm:theWorm[[theWorm count]-1 ]];
            return 1;
            } else {
                return -1;
            }
        }
    }
    return 0;
}

-(NSInteger)getColor {
    return color;
}
-(void)chopWorm:(WormPart*)worm {
    if([theWorm indexOfObject:worm] > 2){
    for(int i = [theWorm count] -1; i >= [theWorm indexOfObject:worm];i--){
        
        WormPart* tempWorm = theWorm[i];
        [theWorm removeObject:tempWorm];
        
        for(int j = 0; j < [bentWorms count]; j++){
            BentWorm* bentWorm = bentWorms[j];
            if(CGRectIntersectsRect([bentWorm getFrame],[tempWorm getCollisionFrame])){
                [bentWorms removeObject:bentWorm];
                [self removeChild:bentWorm cleanup:YES];
            }
        }
        
        WormPart* ghostWorm = [ghostWorms objectAtIndex:i];
        [ghostWorms removeObject:ghostWorm];
        [self removeChild:ghostWorm cleanup:YES];
        [self removeChild:tempWorm cleanup:YES];
    }
    }
}

-(void)clearBends {
    for(int j = 0; j < [bentWorms count]; j++){
        BentWorm* bentWorm = bentWorms[j];
        if([self intersectsWorm:bentWorm] < 0){
            [bentWorms removeObject:bentWorm];
            [self removeChild:bentWorm cleanup:YES];

        }
    }
    
}

-(NSInteger)intersectsWorm:(CCCollisionSprite*)sprite{
    CGRect collisionFrame = [sprite getCollisionFrame];
    for(int i = 1; i < [theWorm count]-1; i++){
        if(CGRectIntersectsRect([theWorm[i] getFrame], collisionFrame)){
            return i;
        }
    }
    WormPart* endWorm = theWorm[[theWorm count]-1];
    endWorm.clipFrame = CGRectMake(0,0,0,0);
    return -1;
}

-(NSInteger)count {
    return [theWorm count];
}

-(CGRect)glClipFrame:(CGRect)nodeFrame withDirection:(NSInteger)direction {
    
    CGPoint point1,point2,point3,point4;
    
    point1 = ccp(nodeFrame.origin.x,nodeFrame.origin.y);
    point2 = ccp(nodeFrame.origin.x+nodeFrame.size.width,nodeFrame.origin.y);
    point3 = ccp(nodeFrame.origin.x,nodeFrame.origin.y+nodeFrame.size.height);
    point4 = ccp(nodeFrame.origin.x+nodeFrame.size.width,nodeFrame.origin.y+nodeFrame.size.height);
    
    CGFloat minX,minY,maxX,maxY;
    
    NSLog(@"Original(%f,%f,%f,%f",point1.x,point1.y,point4.x-point1.x,point4.y-point4.y);

    point1 = [self convertToWorldSpaceAR:point1];
    point2 = [self convertToWorldSpaceAR:point2];
    point3 = [self convertToWorldSpaceAR:point3];
    point4 = [self convertToWorldSpaceAR:point4];

    minX = point1.x;minY = point1.y;maxX = point1.x;maxY = point1.y;
    
    if(point2.x < minX)
        minX = point2.x;
    if(point3.x <minX)
        minX = point3.x;
    if(point4.x < minX)
        minX = point4.x;
    
    if(point2.y < minY)
        minY = point2.y;
    if(point3.y < minY)
        minY = point3.y;
    if(point4.y <minY)
        minY = point4.y;
    
    if(point2.x > maxX)
        maxX = point2.x;
    if(point3.x > maxX)
        maxX = point3.x;
    if(point4.x > maxX)
        maxX = point4.x;
    
    if(point2.y > maxY)
        maxY = point2.y;
    if(point3.y > maxY)
        maxY = point3.y;
    if(point4.y > maxY)
        maxY = point4.y;
    
    NSLog(@"Rectangle(%f,%f,%f,%f",minX,minY,maxX-minX,maxY-minY);
    return CGRectMake(minX,minY,(maxX - minX)*2,(maxY - minY)*2);
    
}

-(void)changeColor {
    color = abs(color-1);
    [self refreshColor];
}

-(void)refreshColor {
    [self refreshColorWithArray:theWorm];
    [self refreshColorWithArray:bentWorms];
    [self refreshColorWithArray:ghostWorms];

}

-(void)refreshColorWithArray:(NSMutableArray*)list{
    CCSprite *tempWorm;
    for(int i=0; i<[list count]; i++) {
        tempWorm = list[i];
        [ElDirector changeColor:tempWorm withColor:color];
    }
}

-(void)animateAppear:(NSInteger) section {
    
}

-(void)animateDisappear:(NSInteger) section {
    
}


@end
