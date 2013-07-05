//
//  CBHelper.h
//
//  Created by Brian Hansen on 1/27/13.
//
//

#import <Foundation/Foundation.h>
#import "Chartboost.h"

@interface CBHelper : NSObject

+(CBHelper*)sharedCBHelper;

-(void) startSessionWithId:(NSString*)appId andSignature:(NSString*)appSignature;

-(BOOL) isLoading:(NSString*)location;
-(BOOL) isCached:(NSString*)location;
-(BOOL) isLoading;
-(BOOL) isCached;

-(NSString*) getStatus;
-(NSString*) getStatus:(NSString*)location;

-(void) failedToCache;
-(void) failedToCache:(NSString*)location;

-(void) cacheInterstitial;
-(void) cacheInterstitial:(NSString*)location;

-(void) showInterstitial;
-(void) showInterstitial:(NSString*)location;

-(void) addLocation:(NSString*)location;
@end
