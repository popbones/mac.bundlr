//
//  PPBBundlrBundle.m
//  Bundlr
//
//  Created by Popbones on 20/12/2013.
//  Copyright (c) 2013 Popbones. All rights reserved.
//

#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>

#import "PPBBundlrBundle.h"

@implementation PPBBundlrBundle

+(PPBBundlrBundle *)bundleWithPath:(NSString *)fullPath
{
    return [[PPBBundlrBundle alloc]initWithPath:fullPath];
}

+(PPBBundlrBundle *)bundleWithURL:(NSURL *)url
{
    return [[PPBBundlrBundle alloc]initWithURL:url];
}

// Test if there is manually defined entry point in the bunlde
// Manually defined entry point is simple a file named EntryPoint in the bundle root dir
-(BOOL) isEntryPointDefinedManually
{
    NSString *manualEntryPoint = [[self containerPath] stringByAppendingPathComponent:kBundlrManualEntryPoint];
    return[[NSFileManager defaultManager] fileExistsAtPath:manualEntryPoint];
}

// Get manual entry point pathname
// This function will test if the file exist when called
// This function returns nil if not found
-(NSString *) manualEntryPointPath
{
    
    if ([self isEntryPointDefinedManually])
    {
        return [[self containerPath] stringByAppendingPathComponent:kBundlrManualEntryPoint];
    }
    
    return nil;
}

// Test if there is defined entry point in the bundle's Info.plist
// This requires that the key BundlrEntryPoint exist in the Info.plist and it's value is not empty string
-(BOOL) isEntryPointDefinedInInfoPlist
{
    NSString *entryPoint = [[self infoDictionary] objectForKey:kBundlrEntryPointPropertyKey];
    if (entryPoint != nil && ![entryPoint isEqualToString:@""])
    {
        return YES;
    }
    return NO;
}

// Get plist entry point pathname
// This will first look defined entry point file under BundleDir/Data/ than check BundleDir/
// This function will test if the file exist when called
// This function returns nil if not found
-(NSString *) plistEntryPointPath
{
    NSString *entryPointPath;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *dataPath = [self dataPath];
    NSString *entryPointName = [[self infoDictionary] objectForKey:kBundlrEntryPointPropertyKey];
    
    // If BundlrEntryPoint is defined in Info.plist
    if ([self isEntryPointDefinedInInfoPlist])
    {
        // Look for the file under Data dir
        if (dataPath != nil)
        {
            entryPointPath = [dataPath stringByAppendingPathComponent:entryPointName];
            if ([fileManager fileExistsAtPath:entryPointPath])
            {
                return entryPointPath;
            }
        }
        
        // If there is no Data dir or defined entry point file is not found under data dir, try bundle dir
        
        entryPointPath = [[self containerPath] stringByAppendingPathComponent:entryPointName];
        if ([fileManager fileExistsAtPath:entryPointPath])
        {
            return entryPointPath;
        }
    }
    
    // If defined entry point does not exist anywhere under either BundleDir/Data/ or BunderDir/, return nil
    return nil;
}

// Get the Data dir path
// Returns nil if the bundle does not have a Data dir
-(NSString *) dataPath
{
    NSString *dataPath;
    
    dataPath = [[self containerPath] stringByAppendingPathComponent:kBundlrBundleDataDirName];
    
    BOOL isDirFlag = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:dataPath isDirectory:&isDirFlag] && isDirFlag)
    {
        return dataPath;
    } else {
        return nil;
    }
}

-(NSString *) containerPath
{
    BOOL isDir;
    NSString *contentsPath = [[self bundlePath] stringByAppendingPathComponent:@"Contents"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:contentsPath isDirectory:&isDir] && isDir) {
        return contentsPath;
    } else {
        return [self bundlePath];
    }
}

-(NSString *) entryPointPath
{
    NSString *entryPointPath;
    
    if ([self isEntryPointDefinedManually])
    {
        entryPointPath = [self manualEntryPointPath];
        if (entryPointPath != nil)
        {
            return entryPointPath;
        }
    }
    
    if ([self isEntryPointDefinedInInfoPlist])
    {
        entryPointPath = [self plistEntryPointPath];
        if (entryPointPath != nil)
        {
            return entryPointPath;
        }
    }
    
    if ([self dataPath])
    {
        return [self dataPath];
    }
    
    return nil;
}

-(NSImage *) entryPointThumbnail
{
    NSString * entryPointPath = [self entryPointPath];
    
    if (!entryPointPath)
    {
        return nil;
    }
    
    NSURL *entryPointUrl = [NSURL URLWithString:entryPointPath];
    CFURLRef url = (__bridge_retained CFURLRef)entryPointUrl;
    
    CGImageRef thumbnail = QLThumbnailImageCreate(NULL, url, CGSizeMake(512, 512), NULL);
    
    NSImage *thumbnailImage = (__bridge_transfer NSImage *)thumbnail;
    
    return thumbnailImage;
}

//-(BOOL) hasQuickLookData
//{
//    NSString *quickLookFilePath = [[self containerPath] stringByAppendingString:@"QuickLook/Thumbnail.png"];
//    BOOL isDir;
//    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:quickLookFilePath isDirectory:&isDir] && !isDir)
//    {
//        return YES;
//    }
//    
//    return NO;
//}
//
//-(void) setQuickLookData:(NSImage *)thumbImg
//{
//    
//    NSString *quickLookDir = [[self containerPath] stringByAppendingString:@"QuickLook"];
//    NSString *quickLookFilePath = [quickLookDir stringByAppendingString:@"Thumbnail.png"];
//
//    BOOL isDir;
//    if (![[NSFileManager defaultManager] fileExistsAtPath:quickLookDir isDirectory:&isDir] || !isDir)
//    {
//        [[NSFileManager defaultManager] createDirectoryAtPath:@"QuickLook" withIntermediateDirectories:NO attributes:nil error:nil];
//    }
//    
//    NSData *imageData = TIFFRepresentation(thumbImg);
//    
//    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
//
//    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
//
//    imageData = [imageRep representationUsingType:NSPNGFileType properties:imageProps];
//    
//    [imageData writeToFile:quickLookFilePath atomically:NO];
//}

@end