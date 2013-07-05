//
//  WormData.h
//  CocoTest
//
//  Created by Brian Hansen on 10/7/12.
//
//

#import <Foundation/Foundation.h>
#import "WormDatabase.h"

@interface WormData : NSObject <NSCoding> {
    NSInteger highScore;
}

@property NSInteger highScore;

- (id)init;
- (id)initWithScore:(NSInteger)score;

@end
