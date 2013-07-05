//
//  ShellObject.h
//  CocoTest
//
//  Created by Brian Hansen on 10/4/12.
//
//

#import <Foundation/Foundation.h>

@interface ShellObject : NSObject {
    NSInteger intOne;
    NSInteger intTwo;
    NSUInteger hash;
    CGPoint pointOne;
    CGPoint pointTwo;
    CGRect rectangleOne;
    CGRect rectangleTwo;
    CGFloat floatOne;
    CGFloat floatTwo;
    BOOL boolean;
}

@property CGFloat floatOne,floatTwo;
@property CGRect rectangleOne,rectangleTwo;
@property CGPoint pointOne,pointTwo;
@property NSUInteger hash;
@property NSInteger intOne,intTwo;
@property BOOL boolean;

-(id)init;
-(id)initWithHash:(NSUInteger)newHash;
-(id)initWithInt:(NSInteger)integer;
-(id)initWithCGPoint:(CGPoint)point;
-(id)initWithCGRect:(CGRect)rect;
-(id)initWithCGFloat:(CGFloat)rect;

-(NSUInteger)hash;
- (BOOL)isEqual:(id)other;
@end
