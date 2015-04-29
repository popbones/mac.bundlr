#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options);
void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview);

/* -----------------------------------------------------------------------------
   Generate a preview for file

   This function's job is to create preview for designated file
   ----------------------------------------------------------------------------- */
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "PPBBundlrBundle.h"

#define BUNDLR_THUMB_SIZE 1024
#define BUNDLR_THUMB_WIDTH 721
#define BUNDLR_THUMB_HEIGHT 945
#define BUNDLR_ICON_RECT_X 104
#define BUNDLR_ICON_RECT_Y 240
#define BUNDLR_ICON_WIDTH 512
#define BUNDLR_ICON_HEIGHT 512

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{
    
    @autoreleasepool {

        NSURL *bundleUrl = (__bridge NSURL *)url;
        NSLog(@"[BundlrQL]: bundleUrl: %@", bundleUrl);

        PPBBundlrBundle *bundle = [PPBBundlrBundle bundleWithURL:bundleUrl];

        NSString *entryPointPath = [bundle entryPointPath];
        NSLog(@"[BundlrQL]: entryPointPath: %@", entryPointPath);

        NSString *extension = [[bundleUrl path] pathExtension];

        if (entryPointPath == nil || [entryPointPath isEqualToString:@""])
        {
            return noErr;
        }

        NSSize thumbSize = CGSizeMake(BUNDLR_THUMB_WIDTH, BUNDLR_THUMB_HEIGHT);

        CFBundleRef genBundleRef = QLPreviewRequestGetGeneratorBundle(preview);
        NSURL *resourceDir = (__bridge_transfer NSURL *)CFBundleCopyResourcesDirectoryURL(genBundleRef);

        NSLog(@"[BundlrQL]: successfully aquired context!");
        NSImage *entryPointIcon = [[NSWorkspace sharedWorkspace] iconForFile:entryPointPath];
        NSImage *thumbnailBackground = [[NSImage alloc]initWithContentsOfURL:[resourceDir URLByAppendingPathComponent:@"ThumbnailBackground.png"]];

        NSLog(@"[BundlrQL]: options=%@", (__bridge NSDictionary *)options);

        CGContextRef cgContext = QLPreviewRequestCreateContext(preview, thumbSize, true, nil);

        if (cgContext)
        {
            NSLog(@"[BundlrQL]: successfully aquired cgContext!");
            NSGraphicsContext *context = [NSGraphicsContext graphicsContextWithGraphicsPort:(void *)cgContext flipped:NO];

            if (context)
            {

                NSLog(@"[BundlrQL]: successfully aquired entryPointIcon!");
                [NSGraphicsContext saveGraphicsState];
                [NSGraphicsContext setCurrentContext:context];

                NSLog(@"[BundlrQL]: successfully set context!");

                NSRect iconRect = NSMakeRect(BUNDLR_ICON_RECT_X, BUNDLR_ICON_RECT_Y, BUNDLR_ICON_WIDTH, BUNDLR_ICON_HEIGHT);

                NSRect fullCanvasRect = NSMakeRect(0.0, 0.0, BUNDLR_THUMB_WIDTH, BUNDLR_THUMB_HEIGHT);

                NSLog(@"[BundlrQL]: drawing...");


                //[boxBackImg drawInRect:iconRect];
                [thumbnailBackground drawInRect: fullCanvasRect];
                [entryPointIcon drawInRect:iconRect];
                //[boxFrontImg drawInRect:iconRect];

                [NSGraphicsContext restoreGraphicsState];
            }
            NSLog(@"[BundlrQL]: flushing...");
            NSLog(@"[BundlrQL]: thubnail request: %@", preview);

            QLPreviewRequestFlushContext(preview, cgContext);
            NSLog(@"[BundlrQL]: releasing cgContext...");
            
            NSLog(@"[BundlrQL]: thubnail request2: %@", preview);
            CFRelease(cgContext);
        }

        return noErr;
    }
}

void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview)
{
    // Implement only if supported
}
