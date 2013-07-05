//
//  TheWorm.h
//  CocoTest
//
//  Created by Brian Hansen on 9/23/12.
//
//

#import "WormHead.h"
#import "BentWorm.h"
#import "ElDirector.h"
#import "Bullet.h"

@interface TheWorm : CCLayer {
    NSMutableArray *theWorm;
    NSMutableArray *bentWorms;
    NSMutableArray *ghostWorms;
    
    NSMutableDictionary *growWorm;
    NSMutableDictionary *shrinkWorm;
    
    WormHead *wormHead;
    BentWorm *bentWorm;
    
    CGRect wormFrame;
    CGFloat speed;
    CGFloat lastTime;
    CGFloat timeDelta;
    CGFloat distanceMoved;
    
    NSInteger theDirection;
    NSInteger growing;
    NSInteger selectorInt;
    NSInteger color;
    
    BOOL noTurn;
}

@property int growing;
@property(readonly) NSInteger theDirection;

-(id)init;
-(id)initWithWorms:(NSMutableArray*)worms;

-(NSInteger)count;

-(void)moveWorm:(CGFloat)distance;
-(void)growWorm;
-(void)turnWorm:(NSInteger) direction;

-(void)addWorm;
-(void)shuffleWorm;
-(void)chopWorm:(WormPart*)worm;

-(void)changeColor;
-(void)refreshColor;
-(NSInteger)getColor;

-(BOOL)isInBounds:(NSInteger)index;
-(NSInteger)checkCollision:(Bullet*)sprite;
-(CGRect)glClipFrame:(CGRect)nodeFrame withDirection:(NSInteger)direction;

-(void)animateAppear:(NSInteger) section;
-(void)animateDisappear:(NSInteger) section;
@end
