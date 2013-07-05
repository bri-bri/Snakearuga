//
//  WormLayer.m
//  CocoTest
//
//  Created by Brian Hansen on 9/22/12.
//
//

#import "WormLayer.h"

#define kScoreKey        @"Score"
#define kDataFile       @"data.plist"

@implementation WormLayer

@synthesize docPath = _docPath;
@synthesize highScore;


WormPart* worm;
TheWorm* theWorm;
TheEnemies* theEnemies;
NSInteger direction;
CGPoint startPoint;
CGFloat distanceMoved = 0;
NSMutableDictionary *touchSet;
BOOL isSwipe = false;
NSInteger growing = 0;
CGFloat sensitivityFactor = 1;
CCLabelTTF *highScoreLabel,*scoreLabel,*CBStatus;
CCMenu *overlayMenu;
CCMenuItemImage * menuItem1;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	WormLayer *layer = [WormLayer node];
    CCLayerColor *background = [CCLayerColor layerWithColor:ccc4(200, 255, 200, 255)];
	// add layer as a child to scene
    [scene addChild: background];
	[scene addChild: layer];
	
	// return the scene
	return scene;
}



// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {

        touchSet = [[NSMutableDictionary alloc] init];
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        NSInteger data = [WormDatabase loadWormDocs];
        NSLog(@"%i",data);
        if(data > 0){
            highScore = data;
        } else {
            highScore = 0;
        }
        
        
        CCLabelTTF *highScoreTitle = [CCLabelTTF labelWithString:@"High Score:" fontName:@"Helvetica" fontSize:20];
        highScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i",highScore] fontName:@"Helvetica" fontSize:20];
        highScoreTitle.contentSize = CGSizeMake(55,20);
        highScoreLabel.contentSize = CGSizeMake(25,20);
        highScoreLabel.anchorPoint = ccp(0,0);
        highScoreTitle.anchorPoint = ccp(0,0);
        
        highScoreTitle.position = ccp(8,screenSize.height-highScoreTitle.contentSize.height-7);
        highScoreLabel.position = ccp(highScoreTitle.position.x + highScoreTitle.contentSize.width*2 +2,highScoreTitle.position.y);
        highScoreTitle.color = ccc3(255,150,58);
        highScoreLabel.color = ccc3(255,150,58);
        
        CBStatus = [CCLabelTTF labelWithString:@"" fontName:@"Helvetica" fontSize:20];
        CBStatus.contentSize = CGSizeMake(55,20);
        CBStatus.anchorPoint = ccp(0,0);
        
        CBStatus.position = ccp(8,screenSize.height-CBStatus.contentSize.height-32);
        CBStatus.color = ccc3(255,150,58);
        
        CCLabelTTF *scoreTitle = [CCLabelTTF labelWithString:@"Score:" fontName:@"Helvetica" fontSize:20];
        scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Helvetica" fontSize:20];
        scoreTitle.contentSize = CGSizeMake(65,20);
        scoreLabel.contentSize = CGSizeMake(40,20);
        scoreTitle.anchorPoint = ccp(0,0);
        scoreLabel.anchorPoint = ccp(0,0);
        scoreTitle.position = ccp(screenSize.width - scoreLabel.contentSize.width-scoreTitle.contentSize.width-8,highScoreTitle.position.y);
        scoreLabel.position = ccp(scoreTitle.position.x + scoreTitle.contentSize.width +2,highScoreTitle.position.y);
        
        menuItem1 = [CCMenuItemImage itemFromNormalImage:@"colorButton1.png"
                                                             selectedImage: @"colorButton2.png"
                                                                    target:self
                                                                  selector:@selector(handleTap)];
        menuItem1.anchorPoint = CGPointZero;
                menuItem1.scale = CC_CONTENT_SCALE_FACTOR();
        
        menuItem1.position = ccp(screenSize.width - menuItem1.contentSize.width*CC_CONTENT_SCALE_FACTOR()-10,10);

        overlayMenu = [CCMenu menuWithItems:menuItem1, nil];
        
        overlayMenu.position = CGPointZero;
        scoreTitle.color = ccc3(255,150,58);
        scoreLabel.color = ccc3(255,150,58);
        
        direction = EAST;
        
        theEnemies = [[TheEnemies alloc] init];
        theWorm = [[TheWorm alloc] init];
        [self addChild:theWorm];
        [self addChild:theEnemies];
        [self addChild:highScoreTitle];
        [self addChild:highScoreLabel];
        [self addChild:CBStatus];
        [self addChild:scoreTitle];
        [self addChild:scoreLabel];
        
        [self addChild:overlayMenu];
        [self schedule:@selector(nextFrame:)];

        _docPath = [WormDatabase getPrivateDocsDir];
        self.isTouchEnabled = YES;
	}
	return self;
}

- (id)initWithDocPath:(NSString *)docPath {
    if ((self = [super init])) {
        _docPath = [WormDatabase getPrivateDocsDir];
    }
    return self;
}

- (NSInteger)data {
    
    if (highScore != 0) return 0;
    
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSData *codedData = [[[NSData alloc] initWithContentsOfFile:dataPath] autorelease];
    if (codedData == nil) return 0;
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    highScore = [unarchiver decodeIntegerForKey:kScoreKey];
    [unarchiver finishDecoding];
    [unarchiver release];
    
    return highScore;
    
}

- (void)saveData {
    
    if (highScore == 0) return;
    
    //[self createDataPath];

    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSLog(@"saving highscore: %ld to %@",(long)highScore,dataPath);
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeInteger:highScore forKey:kScoreKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
    [archiver release];
    [data release];
    
}

- (void)deleteDoc {
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:_docPath error:&error];
    if (!success) {
        NSLog(@"Error removing document path: %@", error.localizedDescription);
    }
    
}

-(void)registerWithTouchDispatcher {
        [[CCTouchDispatcher sharedDispatcher] addStandardDelegate:self priority:0];
    
}

-(void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    for(UITouch *touch in touches){
        startPoint = [self convertTouchToNodeSpace:touch];
        
        ShellObject *newShell = [[ShellObject alloc] initWithHash:[touch hash]];
        newShell.pointOne = startPoint;
        [touchSet setObject:newShell forKey:[NSNumber numberWithInt:[touch hash]]];
    }
}

-(void)ccTouchesMoved:(NSSet*)touches withEvent:(UIEvent *)event {

    for(UITouch *touch in touches){
        NSNumber *hash = [NSNumber numberWithInt:[touch hash]];
            ShellObject *tempTouch = [touchSet objectForKey:hash];
            if(tempTouch){
                [self handleSwipe:touch];
                [touchSet setObject:tempTouch forKey:hash];
        }
    }

}

-(void)ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent *)event {
    for(UITouch *touch in touches){
        NSNumber *hash = [NSNumber numberWithInt:[touch hash]];
        ShellObject *touchObject = [touchSet objectForKey:hash];
        
            if(touchObject.boolean == TRUE || (!(touchObject.pointTwo.x == 0 && touchObject.pointTwo.y == 0) && (fabs(touchObject.pointOne.x - touchObject.pointTwo.x) > 5 || fabs(touchObject.pointOne.y - touchObject.pointTwo.y) > 5))){
                sensitivityFactor = 1;
            } else {
                //[self handleTap];
            }
        [touchSet removeObjectForKey:hash];
    }
    

}

-(void)handleSwipe:(UITouch*)touch {
    ShellObject *touchObject = [touchSet objectForKey:[NSNumber numberWithInt:[touch hash]]];
    CGPoint touchLocation = touchObject.pointOne;
    CGPoint endLocation = [self convertTouchToNodeSpace:touch];
    CGFloat xMove = touchLocation.x - endLocation.x;
    CGFloat yMove = touchLocation.y - endLocation.y;
    NSInteger xDirection = -1;
    NSInteger yDirection = -1;
    
        if(abs(xMove) > 18*sensitivityFactor){
            if(xMove > 0){
                xDirection = WEST;
                worm.scaleX = -1;
            }
            else {
                xDirection = EAST;
                worm.scaleX = 1;
            }
        }
        if(abs(yMove) > 18*sensitivityFactor){
            if(yMove > 0)
                yDirection = SOUTH;
            else
                yDirection = NORTH;

        }
    
    NSInteger tempDirection = theWorm.theDirection;
    if((tempDirection == EAST || tempDirection == WEST) && yDirection > -1){
        touchObject.pointOne = [self convertTouchToNodeSpace:touch];
        touchObject.boolean = TRUE;
        direction = yDirection;
        sensitivityFactor = 1.6;

    }
    else if((tempDirection == NORTH || tempDirection == SOUTH) && xDirection > -1) {
        touchObject.pointOne = [self convertTouchToNodeSpace:touch];
        touchObject.boolean = TRUE;
        direction = xDirection;
        sensitivityFactor = 1.6;
    }
}

-(void)handleTap {
    [theWorm changeColor];
    
    [[CBHelper sharedCBHelper] showInterstitial:@"test"];
    
    id ni = [CCSprite spriteWithTexture:[(CCSprite*)menuItem1.normalImage texture]];
    id si = [CCSprite spriteWithTexture:[(CCSprite*)menuItem1.selectedImage texture]];
    [menuItem1 setNormalImage:si];
    [menuItem1 setSelectedImage:ni];
    
}

-(void) nextFrame:(ccTime)dt {
    if(distanceMoved >= WORM_WIDTH-2){
        [theWorm moveWorm:(WORM_WIDTH-2)-distanceMoved];
        [theWorm turnWorm:direction];
        if(growing > 0){
            [theWorm growWorm];
            if([theWorm count] > highScore){
                highScore = [theWorm count];
                [highScoreLabel setString:[NSString stringWithFormat:@"%i",[theWorm count] ]];
                [self saveData];
            }
            growing--;
        }
        distanceMoved = 0;
        if(rand()%3 == 0){
        [theEnemies addBullet];
        }
        [scoreLabel setString:[NSString stringWithFormat:@"%i",[theWorm count] ]];
    }
    
    [CBStatus setString:[[CBHelper sharedCBHelper] getStatus:@"test"]];
    [theWorm moveWorm:120*dt];
    [theEnemies moveBullets:120*dt];
    
    NSMutableArray *bullets = [theEnemies getBullets];
    
    for(int i=0;i<[bullets count];i++){
        NSInteger tempInt = [theWorm checkCollision:bullets[i]];
        if(tempInt < 0){
            growing++;
            [theEnemies removeBullet:bullets[i]];
        } else if(tempInt > 0) {
            [theEnemies removeBullet:bullets[i]];
        }
    }
    distanceMoved += 120*dt;
}

@end
