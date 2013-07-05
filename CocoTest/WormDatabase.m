//
//  WormDatabase.m
//  CocoTest
//
//  Created by Brian Hansen on 10/7/12.
//
//

#import "WormDatabase.h"
#import "WormLayer.h"

@implementation WormDatabase

+ (NSString *)getPrivateDocsDir {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    return documentsDirectory;
    
}

+ (NSInteger)loadWormDocs {
    
    // Get private docs dir
    NSString *documentsDirectory = [WormDatabase getPrivateDocsDir];
    NSLog(@"Loading score from %@", documentsDirectory);
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return -1;
    }
    
    // Create ScaryBugDoc for each file
            NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:[documentsDirectory stringByAppendingFormat:@"/highScore.worms/data.plist"]];
            NSLog(@"%d",[[[data valueForKey:@"$top"] valueForKey:@"Score"] integerValue]);
            
            return [[[data valueForKey:@"$top"] valueForKey:@"Score"] integerValue];
    
    return -1;
    
}

+ (NSString *)nextWormDocPath {
    
    // Get private docs dir
    NSString *documentsDirectory = [WormDatabase getPrivateDocsDir];
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    // Search for an available name
    int maxNumber = 0;
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"worms" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fileName = [file stringByDeletingPathExtension];
            maxNumber = MAX(maxNumber, fileName.intValue);
        }
    }
    
    // Get available name
    NSString *availableName = @"highScore.worms";
    return [documentsDirectory stringByAppendingPathComponent:availableName];
    
}



@end
