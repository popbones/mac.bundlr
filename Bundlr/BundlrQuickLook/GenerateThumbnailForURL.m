#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>

OSStatus GenerateThumbnailForURL(void *thisInterface, QLThumbnailRequestRef thumbnail, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options, CGSize maxSize);
void CancelThumbnailGeneration(void *thisInterface, QLThumbnailRequestRef thumbnail);

/* -----------------------------------------------------------------------------
    Generate a thumbnail for file

   This function's job is to create thumbnail for designated file as fast as possible
   ----------------------------------------------------------------------------- */

#define BUNDLR_THUMB_SIZE 1024
#define BUNDLR_THUMB_WIDTH 721
#define BUNDLR_THUMB_HEIGHT 945
#define BUNDLR_ICON_RECT_X 104
#define BUNDLR_ICON_RECT_Y 240
#define BUNDLR_ICON_WIDTH 512
#define BUNDLR_ICON_HEIGHT 512

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "PPBBundlrBundle.h"

CGImageRef CGImageWithNSImage(NSImage *image);

/*
OSStatus GenerateThumbnailForURL(void *thisInterface, QLThumbnailRequestRef thumbnail, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options, CGSize maxSize)
{
    @autoreleasepool {
        // To complete your generator please implement the function GenerateThumbnailForURL in GenerateThumbnailForURL.c
        NSURL *bundleUrl = (__bridge NSURL *)url;
        
        PPBBundlrBundle *bundle = [PPBBundlrBundle bundleWithURL:bundleUrl];
        NSLog(@"[BundlrQL]: bundleUrl: %@", bundleUrl);
        
        NSString *entryPointPath = [bundle entryPointPath];
        NSLog(@"[BundlrQL]: entryPointPath: %@", entryPointPath);
        
        if (entryPointPath == nil || [entryPointPath isEqualToString:@""])
        {
            // No valid entry point found for the bundle.
            return noErr;
        }
        
        CFDictionarySetValue((CFMutableDictionaryRef)options, kQLThumbnailOptionIconModeKey, kCFBooleanFalse);
        
        NSImage *entryPointIcon = [[NSWorkspace sharedWorkspace] iconForFile:entryPointPath];

        NSRect destRect = NSMakeRect(0.0, 0.0, 512.0, 512.0);
        CGImageRef entryPointIconRef = [entryPointIcon CGImageForProposedRect:&destRect context:NULL hints:NULL];
        
        NSLog(@"[BundlrQL]: AFTER ENTRY_POINT_ICON_REF <<<<<<<<<<<<<<<<<<<<");
        
        if (entryPointIconRef)
        {
            NSLog(@"[BundlrQL]: SETIMAGE <<<<<<<<<<<<<<<<<<<<<");
            QLThumbnailRequestSetImage(thumbnail, entryPointIconRef, NULL);
            //QLThumbnailRequestSetImageWithData(thumbnail, (CFDataRef) entryPointIconRef, NULL);
        }
        
        return noErr;
    }
}
 */

OSStatus GenerateThumbnailForURL(void *thisInterface, QLThumbnailRequestRef thumbnail, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options, CGSize maxSize)
{
    return GeneratePreviewForURL(thumbnail, url, contentTypeUTI, options, maxSize);
}

//OSStatus GenerateThumbnailForURL(void *thisInterface, QLThumbnailRequestRef thumbnail, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options, CGSize maxSize)
//{
//    @autoreleasepool {
//        // To complete your generator please implement the function GenerateThumbnailForURL in GenerateThumbnailForURL.c
//        NSURL *bundleUrl = (__bridge NSURL *)url;
//        NSLog(@"[BundlrQL]: bundleUrl: %@", bundleUrl);
//        
//        PPBBundlrBundle *bundle = [PPBBundlrBundle bundleWithURL:bundleUrl];
//        
//        NSString *entryPointPath = [bundle entryPointPath];
//        NSLog(@"[BundlrQL]: entryPointPath: %@", entryPointPath);
//        
//        NSString *extension = [[bundleUrl path] pathExtension];
//        
//        //NSImage *bundleIcon = [[NSWorkspace sharedWorkspace] iconForFile:[bundleUrl path]];
//        
//        // TODO: Check if there is QuickLook folder in the bundle, if so cancel.
//        
//        if (entryPointPath == nil || [entryPointPath isEqualToString:@""])
//        {
//            // No valid entry point found for the bundle.
//            return noErr;
//        }
//    
//        NSSize thumbSize = CGSizeMake(BUNDLR_THUMB_WIDTH, BUNDLR_THUMB_HEIGHT);
//        
//        CFBundleRef genBundleRef = QLThumbnailRequestGetGeneratorBundle(thumbnail);
//        NSURL *resourceDir = (__bridge_transfer NSURL *)CFBundleCopyResourcesDirectoryURL(genBundleRef);
//
//        NSLog(@"[BundlrQL]: successfully aquired context!");
//        NSImage *entryPointIcon = [[NSWorkspace sharedWorkspace] iconForFile:entryPointPath];
//        NSImage *thumbnailBackground = [[NSImage alloc]initWithContentsOfURL:[resourceDir URLByAppendingPathComponent:@"ThumbnailBackground.png"]];
//
//        
////        NSSize maxSize = QLThumbnailRequestGetMaximumSize(thumbnail);
//
//        NSLog(@"[BundlrQL]: options=%@", (__bridge NSDictionary *)options);
//        
//        NSDictionary *contextProperties = [NSDictionary dictionaryWithObjectsAndKeys:
//                                                  (id)kCFBooleanFalse, (id)kQLThumbnailOptionIconModeKey,
////                                                  (id)extension, (id)kQLThumbnailPropertyExtensionKey,
//                                                  (id)@"box", (id)kQLThumbnailPropertyExtensionKey,
////                                                  badgeImgRef, (id)kQLThumbnailPropertyBadgeImageKey,
//                                                  nil];
//        NSLog(@"[BundlrQL]: contextProperties=%@", contextProperties);
//        
//        CGContextRef cgContext = QLThumbnailRequestCreateContext(thumbnail, thumbSize, false, (__bridge CFDictionaryRef)contextProperties);
//        
//        if (cgContext)
//        {
//            NSLog(@"[BundlrQL]: successfully aquired cgContext!");
//            NSGraphicsContext *context = [NSGraphicsContext graphicsContextWithGraphicsPort:(void *)cgContext flipped:NO];
//
//            if (context)
//            {
//                
//                NSLog(@"[BundlrQL]: successfully aquired entryPointIcon!");
//                [NSGraphicsContext saveGraphicsState];
//                [NSGraphicsContext setCurrentContext:context];
//                
//                NSLog(@"[BundlrQL]: successfully set context!");
//
//                NSRect iconRect = NSMakeRect(BUNDLR_ICON_RECT_X, BUNDLR_ICON_RECT_Y, BUNDLR_ICON_WIDTH, BUNDLR_ICON_HEIGHT);
//                
//                NSRect fullCanvasRect = NSMakeRect(0.0, 0.0, BUNDLR_THUMB_WIDTH, BUNDLR_THUMB_HEIGHT);
//                
//                NSLog(@"[BundlrQL]: drawing...");
//                
//                
//                //[boxBackImg drawInRect:iconRect];
//                [thumbnailBackground drawInRect: fullCanvasRect];
//                [entryPointIcon drawInRect:iconRect];
//                //[boxFrontImg drawInRect:iconRect];
//                
//                [NSGraphicsContext restoreGraphicsState];
//            }
//            NSLog(@"[BundlrQL]: flushing...");
//            NSLog(@"[BundlrQL]: thubnail request: %@", thumbnail);
//            
//            QLThumbnailRequestFlushContext(thumbnail, cgContext);
//            NSLog(@"[BundlrQL]: releasing cgContext...");
//            
//            NSLog(@"[BundlrQL]: thubnail request2: %@", thumbnail);
//            CFRelease(cgContext);
//        }
////        NSLog(@"[BundlrQL]: releasing entryPointUrlRef...");
//
//        NSLog(@"[BundlrQL]: thumbnail: %@", thumbnail);
//        return noErr;
//    }
//}

void CancelThumbnailGeneration(void *thisInterface, QLThumbnailRequestRef thumbnail)
{
    // Implement only if supported
}

CGImageRef CGImageWithNSImage(NSImage *image)
{
    // create the image somehow, load from file, draw into it...
    CGImageSourceRef source;
    
    source = CGImageSourceCreateWithData((__bridge CFDataRef)[image TIFFRepresentation], NULL);
    CGImageRef maskRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
    
    return maskRef;
}


