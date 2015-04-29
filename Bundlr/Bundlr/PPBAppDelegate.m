//
//  PPBAppDelegate.m
//  Canopener
//
//  Created by Popbones on 19/12/2013.
//  Copyright (c) 2013 Popbones. All rights reserved.
//

#import "PPBAppDelegate.h"

@implementation PPBAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Terminate self right after finish launching
    [[NSApplication sharedApplication] terminate:nil];
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename
{
    PPBBundlrBundle *bundle = [PPBBundlrBundle bundleWithPath:filename];
    NSLog(@"[PPBAppDelegate] opening bundle: %@", filename);
    NSLog(@"[PPBAppDelegate] bundle path: %@", [bundle bundlePath]);
    
    NSString *entryPointPath = [bundle entryPointPath];
    
    NSLog(@"[PPBAppDelegate] entryPointPath: %@", entryPointPath);
    
    if (entryPointPath != nil)
    {
        NSLog(@"[PPBAppDelegate] entryPointPath exists, opening it now.");
        return [PPBAppDelegate openFile:entryPointPath];
    } else {
        NSLog(@"[PPBAppDelegate] entryPointPath is nil, try to open Data directory in the bundle.");
        if ([bundle dataPath] != nil)
        {
            return [PPBAppDelegate openFile:[bundle dataPath]];
        }
        NSLog(@"[PPBAppDelegate] bundle does not have a Data directory.");
    }
    
    return NO;
}

//-(void)generateIconForBundle:bundle
//{
//    NSImage *entryPointQuickLookThumbnail = [bundle entryPointThumbnail];
//    
//    if (entryPointQuickLookThumbnail)
//    {
//        NSString *boxBackFilePathname = [[bundle resourcePath] stringByAppendingPathComponent:@"BoxBack.png"];
//        NSString *boxFrontFilePathname = [[bundle resourcePath] stringByAppendingPathComponent:@"BoxFront.png"];
//        
//        NSRect fullCanvasRect = NSMakeRect(0.0, 0.0, 1024, 1024);
//        NSRect iconRect = NSMakeRect(12, 12, 1000, 1000);
//        NSImage *boxBackImg = [[NSImage alloc]initWithContentsOfFile:boxBackFilePathname];
//        NSImage *boxFrontImg = [[NSImage alloc]initWithContentsOfFile:boxFrontFilePathname];
//        NSImage *result = [[NSImage alloc]initWithSize:NSMakeSize(1024, 1024)];
//        [result lockFocus];
//        
//        [boxBackImg drawInRect:fullCanvasRect];
//        [entryPointQuickLookThumbnail drawInRect:iconRect];
//        [boxFrontImg drawInRect:fullCanvasRect];
//        
//        [result unlockFocus];
//        
//        [bundle setQuickLookData:result];
//    }
//    
//    NSImage *entryPointIcon = [[NSWorkspace sharedWorkspace] iconForFile:[bundle entryPointPath]];
//    if (entryPointIcon)
//    {
//        NSString *boxBackFilePathname = [[bundle resourcePath] stringByAppendingPathComponent:@"BoxBack.png"];
//        NSString *boxFrontFilePathname = [[bundle resourcePath] stringByAppendingPathComponent:@"BoxFront.png"];
//        
//        NSRect fullCanvasRect = NSMakeRect(0.0, 0.0, 1024, 1024);
//        NSRect iconRect = NSMakeRect(12, 12, 1000, 1000);
//        NSImage *boxBackImg = [[NSImage alloc]initWithContentsOfFile:boxBackFilePathname];
//        NSImage *boxFrontImg = [[NSImage alloc]initWithContentsOfFile:boxFrontFilePathname];
//        NSImage *result = [[NSImage alloc]initWithSize:NSMakeSize(1024, 1024)];
//        [result lockFocus];
//        
//        [boxBackImg drawInRect:fullCanvasRect];
//        [entryPointQuickLookThumbnail drawInRect:iconRect];
//        [boxFrontImg drawInRect:fullCanvasRect];
//        
//        [result unlockFocus];
//        
//        [[NSWorkspace sharedWorkspace] setIcon:result forFile:[bundle bundlePath] options:0];
//    }
//    
//}

+ (BOOL)openFile:(NSString *)filename
{
    NSLog(@"Opening file: %@", filename);
    return [[NSWorkspace sharedWorkspace] openFile:filename];
}

@end