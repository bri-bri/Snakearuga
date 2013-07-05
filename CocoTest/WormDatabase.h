//
//  WormDatabase.h
//  CocoTest
//
//  Created by Brian Hansen on 10/7/12.
//
//

#import <Foundation/Foundation.h>
#import "WormData.h"
@interface WormDatabase : NSObject

+ (NSString *)getPrivateDocsDir;
+ (NSInteger)loadWormDocs;
+ (NSString *)nextWormDocPath;

@end
