//
//  WordCellView.m
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 15.7.2015.
//  Copyright (c) 2015 Samuli Lehtonen. All rights reserved.
//

#import "WordCellView.h"

@implementation WordCellView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)setBackgroundStyle:(NSBackgroundStyle)backgroundStyle {
    [super setBackgroundStyle:backgroundStyle];
    self.word.textColor = (backgroundStyle == NSBackgroundStyleLight ? [NSColor darkGrayColor] : [NSColor colorWithCalibratedWhite:0.85 alpha:1.0]);
    self.translation.textColor = (backgroundStyle == NSBackgroundStyleLight ? [NSColor darkGrayColor] : [NSColor colorWithCalibratedWhite:0.85 alpha:1.0]);
}

@end
