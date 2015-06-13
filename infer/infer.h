//
//  infer.h
//  infer
//
//  Created by 潘伟洲 on 15/6/13.
//  Copyright (c) 2015年 潘伟洲. All rights reserved.
//

#import <AppKit/AppKit.h>

@class infer;

static infer *sharedPlugin;

@interface infer : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end