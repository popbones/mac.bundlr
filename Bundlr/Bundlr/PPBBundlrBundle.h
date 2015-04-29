//
//  PPBBundlrBundle.h
//  Bundlr
//
//  Created by Popbones on 20/12/2013.
//  Copyright (c) 2013 Popbones. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBundlrManualEntryPoint @"EntryPoint"
#define kBundlrBundleDataDirName @"Data"
#define kBundlrEntryPointPropertyKey @"BundlrEntryPoint"

@interface PPBBundlrBundle : NSBundle

+(PPBBundlrBundle *)bundleWithPath:(NSString *)fullPath;
+(PPBBundlrBundle *)bundleWithURL:(NSURL *)url;
-(NSString *) entryPointPath;
-(NSString *) dataPath;
-(NSImage *) entryPointThumbnail;
//-(BOOL) hasQuickLookData;
//-(void) setQuickLookData:(NSImage *)thumbImg;

@end
