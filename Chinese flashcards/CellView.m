//
//  CellView.m
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 27.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import "CellView.h"

@implementation CellView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [_progress setDoubleValue:20.0];
    }
    return self;
}

- (void)setBackgroundStyle:(NSBackgroundStyle)backgroundStyle {
    [super setBackgroundStyle:backgroundStyle];
    self.packName.textColor = (backgroundStyle == NSBackgroundStyleLight ? [NSColor darkGrayColor] : [NSColor colorWithCalibratedWhite:0.85 alpha:1.0]);
    self.packWordAmount.textColor = (backgroundStyle == NSBackgroundStyleLight ? [NSColor darkGrayColor] : [NSColor colorWithCalibratedWhite:0.85 alpha:1.0]);
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}

@end
