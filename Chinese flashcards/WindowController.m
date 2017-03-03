//
//  WindowController.m
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 27.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import "WindowController.h"
#import <AppKit/AppKit.h>

@interface WindowController ()

@end

@implementation WindowController

- (instancetype)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}



- (void)windowDidLoad
{
    [super windowDidLoad];
    self.window.titleVisibility = NSWindowTitleHidden;
    //self.window.styleMask = self.window.styleMask | NSFullSizeContentViewWindowMask;
    //self.window.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
}


@end
