//
//  ShellObject.m
//  CocoTest
//
//  Created by Brian Hansen on 10/4/12.
//
//

#import "ShellObject.h"

@implementation ShellObject

@synthesize floatOne,floatTwo,pointOne,pointTwo,rectangleOne,rectangleTwo,intOne,intTwo,hash,boolean;

-(id)init {
    
    if(self = [super init]){
        hash = rand();
        boolean = FALSE;
        pointOne = CGPointMake(-1, -1);
        pointTwo = CGPointMake(-1,-1);
    }
    return self;
}

-(id)initWithHash:(NSUInteger)newHash {
    if(self = [super init]){
        hash = newHash;
    }
    return self;
}

-(id)initWithInt:(NSInteger)integer {
    
    if(self=[super init]){
        int prime = 31;
        int result = 1;
        intOne = integer;
        result = prime * result + integer;
        hash = result;
    }
    return self;
}

-(id)initWithCGPoint:(CGPoint)point {
    if(self=[super init]){
        int prime = 31;
        int result = 1;
        
        pointOne = point;
        result = prime * result + point.x;
        result = prime * result + point.y;
        hash = result;
    }
    return self;
}

-(id)initWithBool:(BOOL)theBool {
    if(self = [super init]){
        int prime = 31;
        int result = 1;
        
        boolean = theBool;
        
        result = prime * result + (theBool)?1231:1237;
        hash = result;
    }
    return self;
}

-(id)initWithCGRect:(CGRect)rect {
    if(self=[super init]){
        int prime = 31;
        int result = 1;
        
        rectangleOne = rect;
        result = prime * result + rect.origin.x;
        result = prime * result + rect.origin.y;
        result = prime * result + rect.size.width;
        result = prime * result + rect.size.height;
        hash = result;
    }
    return self;
}

-(id)initWithCGFloat:(CGFloat)number {
    if(self=[super init]){
        int prime = 31;
        int result = 1;
        
        floatOne = number;
        result = prime * result + number;
        hash = result;
    }
    return self;
}

-(NSUInteger)hash {
    
    return hash;
}

- (BOOL)isEqual:(id)other {
    
    if(self == other){
        return TRUE;
    } else if([other hash] == hash){
        return TRUE;
    }
    
    return false;
}

@end
