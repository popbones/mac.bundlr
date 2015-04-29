//
//  PPBAppDelegate.h
//  Canopener
//
//  Created by Popbones on 19/12/2013.
//  Copyright (c) 2013 Popbones. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PPBBundlrBundle.h"

#define kBundlrDefaultEntryPoint @"Document"
#define kBundlrEntryPointKeyName @"BundlrEntryPoint"
#define kBundlrBundleDataDirName @"Data"
#define kBundlrManualEntryPointName @"EntryPoint"

@interface PPBAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

+ (BOOL)openFile:(NSString *)filename;

@end
