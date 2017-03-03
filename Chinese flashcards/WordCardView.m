//
//  WordCardView.m
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 16.7.2015.
//  Copyright (c) 2015 Samuli Lehtonen. All rights reserved.
//

#import "WordCardView.h"

@implementation WordCardView

- (void)drawRect:(NSRect)dirtyRect {
    [[NSColor whiteColor] setFill];
    NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);
    [super drawRect:dirtyRect];
    
    NSShadow *dropShadow = [[NSShadow alloc] init];
    [dropShadow setShadowColor:[NSColor lightGrayColor]];
    [dropShadow setShadowOffset:NSMakeSize(0, -5.0)];
    [dropShadow setShadowBlurRadius:6.0];
    [self setWantsLayer: YES];
    [self setShadow: dropShadow];
}


@end
