//
//  CFTextField.m
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 26.7.2015.
//  Copyright (c) 2015 Samuli Lehtonen. All rights reserved.
//

#import "CFTextField.h"

@implementation CFTextField

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(BOOL)becomeFirstResponder
{
    return YES;
}

@end
