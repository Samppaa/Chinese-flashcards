//
//  RoundedView.m
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 27.8.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import "RoundedView.h"

@implementation RoundedView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10.0;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
