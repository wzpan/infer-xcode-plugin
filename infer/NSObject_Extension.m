//
//  NSObject_Extension.m
//  infer
//
//  Created by 潘伟洲 on 15/6/13.
//  Copyright (c) 2015年 潘伟洲. All rights reserved.
//


#import "NSObject_Extension.h"
#import "infer.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[infer alloc] initWithBundle:plugin];
        });
    }
}
@end
