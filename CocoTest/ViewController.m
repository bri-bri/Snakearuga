//
//  ViewController.m
//  WormVine
//
//  Created by Brian Hansen on 8/25/12.
//  Copyright (c) 2012 Vinesoft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //TheWorm *testWorm = [[TheWorm alloc] initWithView:self.view];
    
    theModel = [[TheWorm alloc] initWithView:self.view];
    
    WormPart* testWorm = [[WormPart alloc] initWithFrame:CGRectMake(20,60,40,40)];
    WormPart* testWorm2 = [[WormPart alloc] initWithFrame:CGRectMake(60,60,40,40)];
    WormPart* testWorm3 = [[WormPart alloc] initWithFrame:CGRectMake(60,20,40,40)];
    [testWorm2 changeDirection:NORTH];
    [testWorm3 changeDirection:NORTH];
    [testWorm3 changeDirection:NORTH];
    [testWorm3 changeDirection:WEST];
    [testWorm3 changeDirection:SOUTH];
    
    [testWorm2 changeDirection: WEST];
    [testWorm2 changeDirection: SOUTH];
    
    //[self.view addSubview:testWorm];
    //[self.view addSubview:testWorm2];
    //[self.view addSubview:testWorm3];
    testWorm.isGrowing = -1;
    testWorm3.isGrowing = 1;
    [testWorm animateWorm:0.4];
    [testWorm3 animateWorm:0.4];
    
    UISwipeGestureRecognizer *northSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *eastSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *southSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *westSwipe =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    [northSwipe setDirection:UISwipeGestureRecognizerDirectionUp];
    [eastSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [southSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [westSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
    
    [self.view addGestureRecognizer:northSwipe];
    [self.view addGestureRecognizer:eastSwipe];
    [self.view addGestureRecognizer:southSwipe];
    [self.view addGestureRecognizer:westSwipe];
    
    [self performSelector:@selector(startTiming) withObject:nil afterDelay:1.6];
    }

-(void)handleSwipe:(UISwipeGestureRecognizer*) swipe{
    switch(swipe.direction){
        case UISwipeGestureRecognizerDirectionUp:
            [theModel turnWorm:NORTH];
            break;
        case UISwipeGestureRecognizerDirectionRight:
            [theModel turnWorm:EAST];
            break;
        case UISwipeGestureRecognizerDirectionDown:
            [theModel turnWorm:SOUTH];
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            [theModel turnWorm:WEST];
            break;
        default:
            break;
    }
}

-(void)startTiming
{
    CADisplayLink *gameTimer = [CADisplayLink displayLinkWithTarget:theModel
                                                           selector:@selector(updateModelWithTime:)];
    
    [gameTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
