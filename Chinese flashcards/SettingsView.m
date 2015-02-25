//
//  SettingsView.m
//  Chinese flashcards
//
//  Created by Samuli Lehtonen on 15.10.2014.
//  Copyright (c) 2014 Samuli Lehtonen. All rights reserved.
//

#import "SettingsView.h"

@interface SettingsView ()

@end

@implementation SettingsView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *state = [defaults objectForKey:@"includeKnownWords"];
    if(state.boolValue)
        _includeKnownWordsCheckBox.state = NSOnState;
    else
        _includeKnownWordsCheckBox.state = NSOffState;
    
}

-(IBAction)changeIncludeKnownWords:(id)sender
{
    NSButton *button = (NSButton*)sender;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(button.state == NSOffState)
    {
        NSNumber *state = [NSNumber numberWithBool:NO];
        [defaults setObject:state forKey:@"includeKnownWords"];
    }
    else
    {
        NSNumber *state = [NSNumber numberWithBool:YES];
        [defaults setObject:state forKey:@"includeKnownWords"];
    }
}

@end
