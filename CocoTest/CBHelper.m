//
//  CBHelper.m
//
//  Created by Brian Hansen on 1/27/13.
//
//

#import "CBHelper.h"

const int NOTCACHED = 0;
const int CACHED = 1;
const int LOADING = 2;
const int TIMEOUT = 3;
NSString* CBDefault = @"CBHelper_Default";

@implementation CBHelper 

static CBHelper* sharedCBHelper;
static NSMutableArray* statusMessages;
static NSMutableDictionary* locationList;
static int failcount = 0;

+(CBHelper*)sharedCBHelper {
    
    @synchronized(self){
        if (!sharedCBHelper){
            
            sharedCBHelper = [[CBHelper alloc] init];
            locationList = [[NSMutableDictionary alloc] init];
            [locationList setValue:[NSNumber numberWithInt:NOTCACHED] forKey:CBDefault];
            
            statusMessages = [[NSMutableArray alloc] initWithCapacity:4];
            [statusMessages insertObject:@"Ad not loaded." atIndex:NOTCACHED];
            [statusMessages insertObject:@"Ad ready!" atIndex:CACHED];
            [statusMessages insertObject:@"Fetching ad..." atIndex:LOADING];
            [statusMessages insertObject:@"Error fetching ad." atIndex:TIMEOUT];
        }
        return sharedCBHelper;
    }
}

-(void) startSessionWithId:(NSString *)appId andSignature:(NSString *)appSignature {
    Chartboost* cb = [Chartboost sharedChartboost];
    
    cb.appId = appId;
    cb.appSignature = appSignature;
    
    cb.delegate = self;
    [cb startSession];
    [self cacheInterstitial];
}


-(BOOL) isLoading {
    return [self isLoading:CBDefault];
}
-(BOOL) isLoading:(NSString*)location {
        if([location length] == 0){ location = CBDefault;}
    return ([locationList valueForKey:location] == [NSNumber numberWithInt:LOADING]);
}

-(BOOL) isCached {
    BOOL cached = [[Chartboost sharedChartboost] hasCachedInterstitial];
    if(cached) {
        [locationList setValue:[NSNumber numberWithInt:CACHED] forKey:CBDefault];
        failcount = 0;
    }
    else
        [self cacheInterstitial];
    return cached;
}
-(BOOL) isCached:(NSString*)location {
    if([location length] == 0){ location = CBDefault;}
    BOOL cached = [[Chartboost sharedChartboost] hasCachedInterstitial];
    
    if(cached) {
        [locationList setValue:[NSNumber numberWithInt:CACHED] forKey:location];
        failcount = 0;
    }
    else
        [self cacheInterstitial:location];
    return cached;
}

-(void) failedToCache {
    [self failedToCache:CBDefault];
}
-(void) failedToCache:(NSString*)location {
    if(failcount <5) [locationList setValue:[NSNumber numberWithInt:NOTCACHED] forKey:location];
    else [locationList setValue:[NSNumber numberWithInt:TIMEOUT] forKey:location];
}

-(NSString*) getStatus {
    [self isCached];
    return [self getStatus:CBDefault];
}
-(NSString*) getStatus:(NSString*)location {
    if([location length] == 0){ location = CBDefault;}
    [self isCached:location];
    NSNumber* statusIndex = [locationList valueForKey:location];
    return [statusMessages objectAtIndex:[statusIndex unsignedIntegerValue]];
    
}


-(void) cacheInterstitial {
    if([locationList valueForKey:CBDefault] == [NSNumber numberWithInt:NOTCACHED]){
        [locationList setValue:[NSNumber numberWithInt:LOADING] forKey:CBDefault];
        failcount++;
        [[Chartboost sharedChartboost] cacheInterstitial];
    }
}
-(void) cacheInterstitial:(NSString*)location {
    if([location length] == 0){ location = CBDefault;}
    if([locationList valueForKey:location] == [NSNumber numberWithInt:NOTCACHED]){
        NSLog(@"Caching!");
        [locationList setValue:[NSNumber numberWithInt:LOADING] forKey:location];
        failcount++;
        [[Chartboost sharedChartboost] cacheInterstitial:location];
    }
}

-(void) showInterstitial {
    if([locationList valueForKey:CBDefault] == [NSNumber numberWithInt:3]){ failcount = 0;[locationList setValue:[NSNumber numberWithInt:NOTCACHED] forKey:CBDefault];}
    if([self isCached]){
        [[Chartboost sharedChartboost] showInterstitial];
    } else {
        NSLog(@"No ad cached, aborting interstitial!");
    }
    [self cacheInterstitial];
}
-(void) showInterstitial:(NSString*)location {
    if([locationList valueForKey:location] == [NSNumber numberWithInt:3]){ failcount = 0;[locationList setValue:[NSNumber numberWithInt:NOTCACHED] forKey:location];}
    if([location length] == 0){ location = CBDefault;}
    if([self isCached:location]){
        [locationList setValue:[NSNumber numberWithInt:NOTCACHED] forKey:location];
        [[Chartboost sharedChartboost] showInterstitial:location];
    } else {
        NSLog(@"No ad cached, aborting interstitial!");
    }
    [self cacheInterstitial:location];
}

-(void) addLocation:(NSString *)location {
    [locationList setValue:[NSNumber numberWithInt:NOTCACHED] forKey:location];
    [self cacheInterstitial:location];
}
@end
