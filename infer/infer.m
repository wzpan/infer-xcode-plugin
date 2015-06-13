//
//  infer.m
//  infer
//
//  Created by 潘伟洲 on 15/6/13.
//  Copyright (c) 2015年 潘伟洲. All rights reserved.
//

#import "infer.h"

@interface infer()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@end

@implementation infer

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    // Create menu items, initialize UI, etc.
    // Sample Menu Item:
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Infer" action:@selector(doInfer) keyEquivalent:@""];
        //[actionMenuItem setKeyEquivalentModifierMask:NSAlphaShiftKeyMask | NSControlKeyMask];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
    }
}

// Sample Action, for menu item:
- (void)doInfer
{
    NSString *projectURL = [[[self currentProjectURL] description ]substringFromIndex:7];
    NSMutableString *path;
    path = [NSMutableString stringWithCapacity:40];
    [path appendString:projectURL];
    [path appendString:@"scripts/infer_commands.sh"];
    
    NSDictionary *environmentDict = [[NSProcessInfo processInfo] environment];
    
    NSString *shellString = [environmentDict objectForKey:@"SHELL"];
    NSArray *args = [NSArray arrayWithObjects:path.description, projectURL, nil];
    
    NSTask *task = [[NSTask alloc] init];
    NSPipe *outputPipe = [NSPipe pipe];
    NSPipe *errorPipe = [NSPipe pipe];
    [task setStandardOutput: outputPipe];
    [task setStandardError: errorPipe];
    
    [task setLaunchPath:shellString];
    [task setArguments:args];
    
    NSFileHandle *outputFileHandler = [outputPipe fileHandleForReading];
    NSFileHandle *errorFileHandler = [errorPipe fileHandleForReading];
    
    [task launch];
    [task waitUntilExit];
    
    // Task launched now just read and print the data
    NSData *data = [outputFileHandler readDataToEndOfFile];
    NSString *outPutValue = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    
    NSData *errorData = [errorFileHandler readDataToEndOfFile];
    NSString *errorValue = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
    
    NSLog(@"[Error] infer: %@", errorValue);
    NSLog(@"[Info] infer: %@", outPutValue);
}


- (NSURL *)currentProjectURL
{
    for (NSDocument *document in [NSApp orderedDocuments]) {
        @try {
            //        _workspace(IDEWorkspace) -> representingFilePath(DVTFilePath) -> relativePathOnVolume(NSString)
            NSURL *workspaceDirectoryURL = [[[document valueForKeyPath:@"_workspace.representingFilePath.fileURL"] URLByDeletingLastPathComponent] filePathURL];
            
            if(workspaceDirectoryURL) {
                return workspaceDirectoryURL;
            }
        }
        
        @catch (NSException *exception) {
            NSLog(@"OROpenInAppCode Xcode plugin: Raised an exception while asking for the documents '_workspace.representingFilePath.relativePathOnVolume' key path: %@", exception);
        }
    }
    
    return nil;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
